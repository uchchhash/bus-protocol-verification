
class i2c_m_driver extends uvm_driver #(i2c_m_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_driver)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  virtual i2c_m_interface i2c_vif;
  i2c_m_agent_config i2c_m_agnt_cfg;

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // Read/Write Control
  parameter I2C_WR = 1'b0;
  parameter I2C_RD = 1'b1;
  int j = 0;

  // ACK / Not-ACK detector
  parameter ACK  = 1'b0;
  parameter NACK = 1'b1;

  // Serial Clock low/high periods
  // tLOW = 600 // tHIGH = 1300 // Fscl = 400Khz // Tscl = 2500
  parameter tLOW  = 1600;
  parameter tHIGH = 900;
  parameter tBUF  = 1300;  // Bus free time between STOP & START
  
  parameter tVD_DAT = 900; // Data valid time
  parameter tVD_ACK = 900; // Data valid acknowledgement time

  // Setup and Hold Times 
  parameter tHD_STA = 600; // Hold time for (repeted) START condition
  parameter tSU_STA = 600; // Setup time for repeted START condition
  parameter tHD_DAT = 0;   // Hold time for DATA
  parameter tSU_DAT = 100; // Setup time for DATA
  parameter tSU_STO = 600; // Setup time for STOP condition
  
  // --------------------------------------- //
  // ----- Methods of I2C Slave Driver ----- //
  // --------------------------------------- //
  extern function new(string name = "i2c_m_driver", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drv_i2c_reset();
  extern task drv_i2c_bus(input i2c_m_sequence_item i2c_item);
  extern task write_to_i2c_bus(input i2c_m_sequence_item i2c_item);
  extern task read_from_i2c_bus(input i2c_m_sequence_item i2c_item);

  extern task drv_i2c_start();
  extern task drv_i2c_restart();  
  extern task drv_i2c_stop();
  extern task mntr_i2c_ack(input bit ack_nack);
  extern task drv_i2c_byte(input byte i2c_byte, input string byte_type);
  extern task mntr_i2c_byte();
  extern task drv_i2c_ack(input bit ack_nack);

endclass : i2c_m_driver



// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_driver::new(string name = "i2c_m_driver", uvm_component parent = null);
   super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Driver-1 Constructed *****", UVM_NONE);
endfunction

// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //
function void i2c_m_driver::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "***** I2C Slave Driver : Inside Build Phase *****", UVM_NONE);
endfunction

// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task i2c_m_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  //`uvm_info(get_type_name(), "***** I2C Slave Driver : Run Phase Started  *****", UVM_MEDIUM);	
  forever begin
    i2c_m_sequence_item i2c_item;
    seq_item_port.get_next_item(i2c_item);
    `uvm_info (get_type_name(), $sformatf("######## Got Items @Driver ######## %s", i2c_item.convert2string), UVM_MEDIUM) 
    if(i2c_item.assert_reset) drv_i2c_reset();
    else if (!i2c_item.assert_reset) drv_i2c_bus(i2c_item);
    seq_item_port.item_done();
  end
endtask


// ===================================== //
// ========== Drive I2C Reset ========== //
// ===================================== //

task i2c_m_driver::drv_i2c_reset();
  `uvm_info(get_type_name(), " ######## I2C Reset Initiated ########", UVM_MEDIUM);	
  // Global Signals
  i2c_vif.RST    <= 1'b1;
  // Read-Only Registers
  i2c_vif.MYREG4 <= 8'h11;
  i2c_vif.MYREG5 <= 8'h22;
  i2c_vif.MYREG6 <= 8'h33;
  i2c_vif.MYREG7 <= 8'h44;
  repeat(2)@(posedge i2c_vif.CLK);
  i2c_vif.RST   <= 1'b0;
  repeat(3)@(posedge i2c_vif.CLK);
  `uvm_info(get_type_name(), " ######## I2C Reset Finished ########", UVM_MEDIUM);	
endtask


// =================================== //
// ========== Drive I2C Bus ========== //
// =================================== //

task i2c_m_driver::drv_i2c_bus(input i2c_m_sequence_item i2c_item);
  if(i2c_item.assert_write == 1 && i2c_item.assert_read == 0) begin
    `uvm_info(get_type_name(), " ######## I2C Write Transfer Initiated ########", UVM_MEDIUM);
    write_to_i2c_bus(i2c_item);
    `uvm_info(get_type_name(), " ######## I2C Write Transfer Finished  ########", UVM_MEDIUM);
  end
  else if(i2c_item.assert_write == 0 && i2c_item.assert_read == 1) begin
    `uvm_info(get_type_name(), " ######## I2C Read Transfer Initiated  ########", UVM_MEDIUM);	
    read_from_i2c_bus(i2c_item);
    `uvm_info(get_type_name(), " ######## I2C Read Transfer Finished   ########", UVM_MEDIUM);	 
  end
endtask


// ======================================================== //
// ========== I2C Write with single START & STOP ========== //
// ======================================================== //
// -> Master starts transaction by driving START condition	
// -> Master sets DEVICE ADDRESS with WRITE (0x78)	
// -> Slave receives the device address by providing ACK	
// -> Master sets Starting REGISTER ADDRESS (0x00/0x01/0x02/0x03) 	
// -> Slave receives the register address by providing ACK	
// -> N Times :	
//     -> Master writes DATA BYTE
//     -> Slave receives data byte by providing ACK
// -> Master stops transaction by driving STOP condition
// -? Provide Buffer time before starting another transaction

task i2c_m_driver::write_to_i2c_bus(input i2c_m_sequence_item i2c_item);
  drv_i2c_start();
  drv_i2c_byte(i2c_item.dev_addr_wr, "DEV_ADDR_WR");  
  mntr_i2c_ack(ACK);   
  drv_i2c_byte(i2c_item.reg_addr, "REG_ADDR");
  mntr_i2c_ack(ACK); 
  for (int i=0; i<i2c_item.num_writes; i++) begin
    if(i==0) begin
      drv_i2c_byte(i2c_item.write_data[7:0], "WDATA_BYTE_1");
      mntr_i2c_ack(ACK);    
    end
    else if (i==1) begin
      drv_i2c_byte(i2c_item.write_data[15:8], "WDATA_BYTE_2");
      mntr_i2c_ack(ACK);          
    end
    else if (i==2) begin
      drv_i2c_byte(i2c_item.write_data[23:16], "WDATA_BYTE_3");
      mntr_i2c_ack(ACK);          
    end
    else if (i==3) begin
      drv_i2c_byte(i2c_item.write_data[31:24], "WDATA_BYTE_4");
      mntr_i2c_ack(NACK);          
    end
  end
  drv_i2c_stop();
endtask



// ======================================================= //
// ========== I2C Read with single START & STOP ========== //
// ======================================================= //

// -> Master starts transaction by driving START condition
// -> Master sets DEVICE ADDRESS with WRITE (0x78)		
// -> Slave receives the device address by providing ACK		
// -> Master sets REGISTER ADDRESS (0x00/0x01/0x02/0x03) 		
// -> Slave receives the register address by providing ACK		
// -> (NOT-REPETED-START) ::
//     -> Master stops transaction by driving STOP condition	
//     -> Master starts transaction by driving START condition
// -> (REPETED-START) ::
//     -> Master Continues the transaction by driving Repeted START condition
// -> Master sets DEVICE ADDRESS with READ (0x79)		
// -> Slave receives the device address by providing ACK		
// -> N-Times :
//     -> Slave provides one DATA BYTE	
//     -> Master receives data bytes by providing NACK	
// -> Master stops transaction by driving STOP condition		

task i2c_m_driver::read_from_i2c_bus(input i2c_m_sequence_item i2c_item);
  drv_i2c_start(); 
  drv_i2c_byte(i2c_item.dev_addr_wr, "DEV_ADDR_WR");
  mntr_i2c_ack(ACK);
  drv_i2c_byte(i2c_item.reg_addr, "REG_ADDR"); 
  mntr_i2c_ack(ACK); 

  if(i2c_item.assert_restart) begin
    drv_i2c_restart();
  end
  else if (!i2c_item.assert_restart) begin
    drv_i2c_stop();
    drv_i2c_start();
  end
  drv_i2c_byte(i2c_item.dev_addr_rd, "DEV_ADDR_RD"); 
  mntr_i2c_ack(ACK);
  for (int i=0; i<i2c_item.num_reads; i++) begin
    mntr_i2c_byte;
    if(i==i2c_item.num_reads-1) drv_i2c_ack(NACK);
    else drv_i2c_ack(ACK);
  end
  drv_i2c_stop();
endtask



// ========================================= //
// ========== I2C Start Condition ========== //
// ========================================= //

// SDA transition to LOW before SCL transition to LOW
// -> SDA & SCL Line is released state at firts
// -> Provide HIGH time for SCL : tHIGH-tHD_STA = 900-600 = 300
// -> Acquire the SDA line and make it low 
// -> Provide HOLD time for start : tHD_STA = 600
// -> Acquire the SCL line and make it low
// -> Master is in control of SCL & SDA lines

task i2c_m_driver::drv_i2c_start();
  // Before acquiring the BUS
  i2c_vif.SDA_RELEASE = 1;
  i2c_vif.SCL_RELEASE = 1;
  #(tHIGH-tHD_STA);
  i2c_vif.SDA_RELEASE = 0;  
  i2c_vif.SDA_OUT = 0;
  #(tHD_STA); 
  i2c_vif.SCL_RELEASE = 0;
  i2c_vif.SCL_OUT = 0;
 //`uvm_info(get_type_name(), "****************************** I2C Driver : Start Driven :: SDA & SCL acquired ******************************", UVM_MEDIUM) 
endtask

// ========================================= //
// ========== I2C Repeated Start  ========== //
// ========================================= //

task i2c_m_driver::drv_i2c_restart();
  // Acquire the SDA & SCL lines
  i2c_vif.SCL_RELEASE = 0;  
  //i2c_vif.SDA_OUT = 1;
  i2c_vif.SCL_OUT = 0;
  #(tLOW);
  // Make SCL High & START setup time
  i2c_vif.SCL_OUT = 1;
  #(tSU_STA);
  // Make SDA Low & START hold time
  i2c_vif.SDA_RELEASE = 0;  
  i2c_vif.SDA_OUT = 0;
  #(tHD_STA);
  `uvm_info(get_type_name(), "**************************** I2C Driver : RE Start Driven :: SDA & SCL acquired ******************************", UVM_MEDIUM)   
endtask


//



// ======================================== //
// ========== I2C Stop Condition ========== //
// ======================================== //
// SDA transition to HIGH after SCL transition to High
// -> Acquire the SDA & SCL lines and make them LOW
// -> Provide SCL LOW time : tLOW = 1600;
// -> Make SCL HIGH
// -> Provide Stop SETUP time : tSU_STO = 600;
// -> Make SDA HIGH
// -> Provide SCL High time : tHIGH-tSU_STO = 900-600 = 300
// -> Provide Buffer time after STOP is driven

task i2c_m_driver::drv_i2c_stop();
  // Acquire the SDA & SCL lines
  i2c_vif.SCL_RELEASE = 0;
  i2c_vif.SDA_RELEASE = 0;
  i2c_vif.SCL_OUT = 0;
  i2c_vif.SDA_OUT = 0;
  #(tLOW);
  i2c_vif.SCL_OUT = 1;
  #(tSU_STO);
  i2c_vif.SDA_OUT = 1; 
  #(tHIGH-tSU_STO);
 // `uvm_info(get_type_name(), "************************** I2C Stop Driven :: SDA & SCL Line Released **************************", UVM_MEDIUM)
  #(tBUF);
endtask


// ===================================== //
// ========== I2C Byte Drive  ========== //
// ===================================== //
// SDA changes when SCL is LOW
// -> Bus is in control of Master
// -> Make SCL low 
// -> Change the SDA : Drive the Bit
// -> Provide SCL low time : 600ns
// -> Make SCL High
// -> Provide SCL high time : 1300ns
// -> Release the SDA

task i2c_m_driver::drv_i2c_byte(input byte i2c_byte, input string byte_type);
  //`uvm_info(get_type_name(), $sformatf("************************ I2C Byte Transfer Started [%s] :: [%0h][%b] :: SDA Line Acquired **", byte_type, i2c_byte, i2c_byte), UVM_MEDIUM)
  for(int i =7; i >=0; i--) begin
    i2c_vif.SCL_OUT = 0;
    #(tVD_DAT);
    i2c_vif.SDA_RELEASE = 0;      
    i2c_vif.SDA_OUT = i2c_byte[i];    
    //`uvm_info(get_type_name(), $sformatf(">>>>>>>>>> ########## [VALID-BIT-Transfer] [%s] :: [%0b] ##########", byte_type, i2c_vif.SDA_OUT), UVM_MEDIUM)    
    #(400);
    i2c_vif.SCL_OUT = 1;
    #(tHIGH);
  end
  i2c_vif.SDA_RELEASE = 1;  
  //`uvm_info(get_type_name(), "** I2C Byte Transfer Finished :: SDA Line Released **", UVM_MEDIUM)
endtask

// =========================================== //
// ========== I2C ACK/NACK Monitor  ========== //
// =========================================== //

// Master releases the SDA line during the ninth clock pulse
// Slave Acquires the SDA line to provide ACK/NACK
// if Slave pulls the SDA line to LOW : ACK
// if Slave pulls the SDA line to HIGH : NACK
// Monitor the SDA during the high period of the ninth clock pulse

task i2c_m_driver::mntr_i2c_ack(input bit ack_nack);
  i2c_vif.SDA_RELEASE = 1;
  i2c_vif.SCL_OUT = 0;
  #(tLOW);
  i2c_vif.SCL_OUT = 1;
 // `uvm_info(get_type_name(), $sformatf("** I2C Slave ACK/NACK Detection EXP :: [%0d] || ACT :: [%0d] :: SDA Line Released**", ack_nack, i2c_vif.SDA), UVM_MEDIUM)  
  #(tHIGH);  
  // if(i2c_vif.SDA) `uvm_fatal(get_type_name(), "********** Transaction not Acknowledged **********")  
endtask



// ======================================= //
// ========== I2C Byte Monitor  ========== //
// ======================================= //

task i2c_m_driver::mntr_i2c_byte();
  //`uvm_info(get_type_name(), "** I2C Byte Monitor Started :: SDA Line Released **", UVM_MEDIUM)  
  i2c_vif.SDA_RELEASE = 1;
  for(int i =0; i <=7; i++) begin
    i2c_vif.SCL_OUT = 0;
    #(tLOW);
    i2c_vif.SCL_OUT = 1;
    #(tHIGH);
  //  `uvm_info(get_type_name(), $sformatf("** I2C Valid Bit Monitor [%0d] **", i2c_vif.SDA), UVM_MEDIUM)
  end
endtask



// ========================================== //
// ========== I2C ACK/NACK Driver  ========== //
// ========================================== //

task i2c_m_driver::drv_i2c_ack(input bit ack_nack);
// `uvm_info(get_type_name(), $sformatf("************** I2C Slave ACK/NACK Drive [%0d] :: Acquire SDA Line **********", ack_nack), UVM_MEDIUM)
  i2c_vif.SCL_OUT = 0;
  #tVD_ACK;
  i2c_vif.SDA_RELEASE = 0;  
  i2c_vif.SDA_OUT = ack_nack;  
  #400;
  i2c_vif.SCL_OUT = 1;
  #(tHIGH);
endtask





