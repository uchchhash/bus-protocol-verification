class i2c_m_monitor extends uvm_monitor;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_monitor)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  virtual i2c_m_interface i2c_vif;
  i2c_m_sequence_item i2c_item;
  i2c_m_agent_config i2c_m_agnt_cfg;
  uvm_analysis_port #(i2c_m_sequence_item) analysis_port_mntr2scb;  // Monitor to Scoreboard
  uvm_analysis_port #(i2c_m_sequence_item) analysis_port_mntr2cov;  // Monitor to Coverage

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  int scl_counter;
  bit [8:0] i2c_byte;
  bit ack_nack;

  // Bit and Byte Counter
  int rbit_count, wbit_count;
  int rbyte_count, wbyte_count;
  bit [31:0] data_bytes;
  bit [31:0] read_data;

  // Serial Clock low/high periods
  // tLOW = 600 // tHIGH = 1300 // Fscl = 400Khz // Tscl = 2500
  parameter tLOW  = 1600;
  parameter tHIGH = 900;
  parameter tBUF  = 1300;  // Bus free time between STOP & START
  

  // Setup and Hold Times 
  parameter tHD_STA = 600; // Hold time for (repeted) START condition
  parameter tSU_STA = 600; // Setup time for repeted START condition
  parameter tSU_STO = 600; // Setup time for STOP condition

  // ----------------------------------------- //
  // ----- Methods of i2c_master monitor ----- //
  // ----------------------------------------- //
  extern function new(string name = "i2c_m_monitor", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task mntr_i2c_start();
  extern task mntr_i2c_stop();
  extern task mntr_i2c_stop_start();
  extern task mntr_i2c_write();
  extern task mntr_i2c_read();
  extern task mntr_i2c_bus();
  extern task capture_timings();
  //extern task write_to_regs();
  extern task read_from_regs(input bit [7:0] reg_addr,input bit [7:0] read_data, input int ctrl, input int stop_start_count, input bit ro_test);
  extern task write_to_regs(input bit [7:0] reg_addr, input bit [7:0] write_data, input int ctrl);

  
  // Initialize variables to track previous state
  bit prev_scl;
  bit prev_sda;
  bit sda0, sda1, sda2, sda3, sda4, sda5;
  bit next_sda;
  bit start_detected, stop_detected;
  bit stop_start_detected;
  int stop_start_count;
  int start_count, stop_count;

  bit [7:0] data_reg_arr [8] = '{default: 8'b0};

  bit [31:0] wdata, rdata0, rdata1;
  bit [7:0] dev_addr_wr, dev_addr_rd, reg_addr;

endclass : i2c_m_monitor


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_monitor::new(string name = "i2c_m_monitor", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C Master Monitor Constructed *****", UVM_NONE);
endfunction


// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void i2c_m_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** i2c_master Monitor : Inside Build Phase *****", UVM_NONE);
  analysis_port_mntr2scb  = new("analysis_port_mntr2scb", this);  
  analysis_port_mntr2cov  = new("analysis_port_mntr2cov", this);
endfunction

// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //


task i2c_m_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  //`uvm_info(get_type_name(), "***** i2c_master Monitor : Run Phase Started  *****", UVM_MEDIUM);
  fork
    mntr_i2c_bus();
    mntr_i2c_start();
    mntr_i2c_stop();
    mntr_i2c_stop_start();
  join_none
endtask


// ======================================= //
// ========== I2C Start Monitor ========== //
// ======================================= //
// SDA transition to LOW before SCL transition to LOW
// -> SDA & SCL Line is released state at firts
// -> Provide HIGH time for SCL : tHIGH-tHD_STA = 900-600 = 300
// -> Acquire the SDA line and make it low 
// -> Provide HOLD time for start : tHD_STA = 600
// -> Acquire the SCL line and make it low
// -> Master is in control of SCL & SDA lines


task i2c_m_monitor::mntr_i2c_stop();
  forever begin
    @(posedge i2c_vif.SCL);
    prev_sda = i2c_vif.SDA;
    #(tSU_STO);
    #1;
    next_sda = i2c_vif.SDA;
    if(prev_sda == 0 && next_sda == 1) begin
      stop_detected = 1'b1;
      stop_count++;
    end
  end
endtask


task i2c_m_monitor::mntr_i2c_start();
  forever begin
    @(posedge i2c_vif.SCL);
    prev_sda = i2c_vif.SDA;
    #(tSU_STA);
    #1;
    next_sda = i2c_vif.SDA;
    if(prev_sda == 1 && next_sda == 0) begin
      start_detected = 1'b1;
      start_count++;
    end  
  end
endtask


task i2c_m_monitor::mntr_i2c_stop_start();
  forever begin
    @(posedge i2c_vif.SCL);
    capture_timings();
  end
endtask


task i2c_m_monitor::capture_timings();
  fork
  begin
    sda0 = i2c_vif.SDA;
    #(tSU_STO+1);
    sda1 = i2c_vif.SDA;
    if(sda0 == 0 && sda1 == 1) begin
      stop_detected = 1'b1;
    end
    #(tHIGH-tSU_STO+1);
    sda2 = i2c_vif.SDA;
    #(tBUF+1);
    sda3 = i2c_vif.SDA;
    #(tHIGH-tHD_STA+1);
    sda4 = i2c_vif.SDA;
    #(tHD_STA);
    sda5 = i2c_vif.SDA;
    if(sda0 == 0 && sda1 == 1 && sda2 == 1 && sda3 == 1 && sda4 == 0 && sda5 == 0) begin
      stop_start_detected = 1'b1;
      if(i2c_m_agnt_cfg.assert_read) stop_start_count++;
      start_detected = 1;
      start_count++;
    end
   end
    join_none
endtask



//posedge of SCL : measure SDA : should be HIGH
//posedge of SCL + tHIGH-tHD_STA : measure SDA : should be low

task i2c_m_monitor::mntr_i2c_bus();
  forever begin
    @(posedge i2c_vif.SCL);
    if(i2c_m_agnt_cfg.assert_write == 1 && start_detected) mntr_i2c_write;
    else if(i2c_m_agnt_cfg.assert_read == 1 && start_detected) begin
      mntr_i2c_read;
    end
  end
endtask



// =================================================== //
// ========== I2C Write Transaction Monitor ========== //
// =================================================== //
// -> Monitor to START condition by Master
// -> Monitor the DEVICE ADDRESS with WRITE (0x78) by Master
// -> Monitor to ACK bit provided by Slave
// -> Monitor the starting REGISTER ADDRESS (0x00/0x01/0x02/0x03) by Master
// -> Monitor to ACK bit provided by Slave
// -> N Times :	
//     -> Monitor the DATA BYTE provided by Master
//     -> Monitor to ACK bit provided by Slave
// -> Monitor the STOP condition by Master

// -> For Write Transfer : 
// -> 1st Byte = dev_addr_wr // 9th bit = ack_nack
// -> 2nd Byte = reg_addr // 9th bit = ack_nack
// -> 3rd Byte  to 5th Byte = write-data // 9th bits = ack_nack


// -> Wait for the START condition
// -> @posedge of Serial Clock :
// -> Count the Bits, Count bytes at 9th bit & make bit count zero.
// -> Create the item @first bit
// -> Assign the items @first to eight bits
// -> Send the item @9th bit

task i2c_m_monitor::mntr_i2c_write();
  wbit_count++;
  if(wbit_count==1 && wbyte_count==6) begin
    wbyte_count = 0;
    wbit_count = 0;
  end
  if(wbit_count <9) begin
    if(wbyte_count == 0) begin
      dev_addr_wr = (dev_addr_wr << 1 ) | i2c_vif.SDA;
      if(wbit_count == 8 ) write_to_regs(dev_addr_wr, 0, 1); 
    end
    else if (wbyte_count == 1) reg_addr = (reg_addr << 1 ) | i2c_vif.SDA;
    else if (wbyte_count == 2) wdata[7:0]   = (wdata[7:0]   << 1 ) | i2c_vif.SDA;
    else if (wbyte_count == 3) wdata[15:8]  = (wdata[15:8]  << 1 ) | i2c_vif.SDA;
    else if (wbyte_count == 4) wdata[23:16] = (wdata[23:16] << 1 ) | i2c_vif.SDA;
    else if (wbyte_count == 5) wdata[31:24] = (wdata[31:24] << 1 ) | i2c_vif.SDA;
  end
  else if (wbit_count == 9) begin
    if(wbyte_count == 2) begin
        write_to_regs(reg_addr, wdata[7:0], 0);      
    end
    else if (wbyte_count > 2) begin
      reg_addr++;
      if(wbyte_count == 3) write_to_regs(reg_addr, wdata[15:8], 0);
      else if(wbyte_count == 4) write_to_regs(reg_addr, wdata[23:16], 0);
      else if(wbyte_count == 5) begin
        write_to_regs(reg_addr, wdata[31:24], 0);
       // wbyte_count = 0;
      end
    end
    wbit_count = 0;
    wbyte_count++;
  end
endtask




// ================================================== //
// ========== I2C Read Transaction Monitor ========== //
// ================================================== //
// -> Monitor to START condition by Master
// -> Monitor the DEVICE ADDRESS with WRITE (0x78) by Master
// -> Monitor to ACK bit provided by Slave
// -> Monitor the starting REGISTER ADDRESS (0x00/0x01/0x02/0x03) by Master
// -> Monitor to ACK bit provided by Slave
// -> Monitor the STOP then START or Repeated Start condition by Master
// -> Monitor the DEVICE ADDRESS with Read (0x78) by Master
// -> Monitor to ACK bit provided by Slave
// -> N Times :	
//     -> Monitor the DATA BYTE provided by Slave
//     -> Monitor to ACK bit provided by Master
// -> Monitor the STOP condition by Master

// -> For Read Transfer : 
// -> 1st Byte = dev_addr_wr // 9th bit = ack_nack
// -> 2nd Byte = reg_addr // 9th bit = ack_nack
// -> 3rd Byte = dev_addr_rd // 9th bit = ack_nack
// -> 4th Byte  to Nth Byte = read-data // 9th bits = ack_nack

task i2c_m_monitor::mntr_i2c_read();
  rbit_count++;   
  if(rbit_count==1 && rbyte_count==11) begin
    rbyte_count = 0;
    rbit_count = 0;
    stop_start_count = 0;
  end
  if(rbit_count < 9) begin
    if(rbyte_count == 0) begin
      dev_addr_wr = (dev_addr_wr << 1 ) | i2c_vif.SDA;
      if(rbit_count == 8) read_from_regs(dev_addr_wr, 0, 1, stop_start_count, i2c_m_agnt_cfg.ro_test);
    end
    else if (rbyte_count == 1) reg_addr = (reg_addr << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 2) begin
      dev_addr_rd = (dev_addr_rd << 1 ) | i2c_vif.SDA;
      if(rbit_count == 8) begin
        read_from_regs(dev_addr_rd, 0, 2, stop_start_count, i2c_m_agnt_cfg.ro_test);
      end
      else if(!i2c_m_agnt_cfg.ro_test && start_count==3) begin
        start_count=0;
        rbit_count=1;        
      end
      else if(i2c_m_agnt_cfg.ro_test && start_count==2) begin
        start_count=0;
        rbit_count=1;        
      end
    end
    else if (rbyte_count == 3) rdata0[7:0]   = (rdata0[7:0]   << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 4) rdata0[15:8]  = (rdata0[15:8]  << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 5) rdata0[23:16] = (rdata0[23:16] << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 6) rdata0[31:24] = (rdata0[31:24] << 1 ) | i2c_vif.SDA;
    // Read-Only-Registers
    else if (rbyte_count == 7)  rdata1[7:0]   = (rdata1[7:0]   << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 8)  rdata1[15:8]  = (rdata1[15:8]  << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 9)  rdata1[23:16] = (rdata1[23:16] << 1 ) | i2c_vif.SDA;
    else if (rbyte_count == 10) rdata1[31:24] = (rdata1[31:24] << 1 ) | i2c_vif.SDA;
  end
  else if (rbit_count == 9) begin
    if(rbyte_count == 1) reg_addr = reg_addr;
    else if (rbyte_count == 3) begin
      read_from_regs(reg_addr, rdata0[7:0], 0, stop_start_count, i2c_m_agnt_cfg.ro_test);
    end
    else if (rbyte_count > 3) begin
      reg_addr++;    
      if (rbyte_count == 4) read_from_regs(reg_addr, rdata0[15:8], 0, stop_start_count, i2c_m_agnt_cfg.ro_test);
      else if (rbyte_count == 5) read_from_regs(reg_addr, rdata0[23:16], 0, stop_start_count, i2c_m_agnt_cfg.ro_test);
      else if (rbyte_count == 6) read_from_regs(reg_addr, rdata0[31:24], 0, stop_start_count, i2c_m_agnt_cfg.ro_test);
      // Read-Only-Registers
      else if (rbyte_count == 7) read_from_regs(reg_addr, rdata1[7:0], 0, stop_start_count, 1);
      else if (rbyte_count == 8) read_from_regs(reg_addr, rdata1[15:8], 0, stop_start_count, 1);
      else if (rbyte_count == 9) read_from_regs(reg_addr, rdata1[23:16], 0, stop_start_count, 1);
      else if (rbyte_count == 10) begin
        read_from_regs(reg_addr, rdata1[31:24], 0, stop_start_count, 1);
        //rbyte_count = 0;
      end
    end
   // $display("======================================  rbit-count = %0d // rbyte-count = %0d", rbit_count, rbyte_count);    
    rbit_count = 0;
    rbyte_count++;// = rbyte_count == 10 ? 0 : rbyte_count+1;
  end
endtask


// Calculate Expected Values

task i2c_m_monitor::write_to_regs(input bit [7:0] reg_addr, input bit [7:0] write_data, input int ctrl);
  //`uvm_info(get_type_name(), $sformatf("########## [I2C_PRED] [Write-to-Reg] [ADDR = %0h][DATA = %0h]", reg_addr, write_data), UVM_MEDIUM);
  i2c_item = i2c_m_sequence_item::type_id::create("i2c_item");
  i2c_item.rw_ctrl = 0;
  i2c_item.ctrl = ctrl;  
  if(ctrl == 1) begin
    i2c_item.dev_addr_wr = reg_addr;
    //`uvm_info (get_type_name(), $sformatf("Send DEV_ADDR_WR to @COV :: %s", i2c_item.convert2string), UVM_MEDIUM)     
    analysis_port_mntr2scb.write(i2c_item);
  end
  else begin
    data_reg_arr[reg_addr] = write_data;
    // read only registers 
    data_reg_arr[4] = 8'h12;
    data_reg_arr[5] = 8'h34;
    data_reg_arr[6] = 8'h56;
    data_reg_arr[7] = 8'h78;
  end
endtask


task i2c_m_monitor::read_from_regs(input bit [7:0] reg_addr,input bit [7:0] read_data, input int ctrl, input int stop_start_count, input bit ro_test);
  i2c_item = i2c_m_sequence_item::type_id::create("i2c_item");
  i2c_item.rw_ctrl = 1;
  i2c_item.ctrl = ctrl;
  if(ctrl == 1) begin
    i2c_item.dev_addr_wr = reg_addr;
    dev_addr_wr = i2c_item.dev_addr_wr;
    //`uvm_info (get_type_name(), $sformatf("Send DEV_ADDR_WR to @COV :: %s", i2c_item.convert2string), UVM_MEDIUM)         
    analysis_port_mntr2scb.write(i2c_item);    
  end
  else if (ctrl == 2) begin
    i2c_item.dev_addr_rd = reg_addr;
    dev_addr_rd = i2c_item.dev_addr_rd;
   // `uvm_info (get_type_name(), $sformatf("Send DEV_ADDR_RD to @COV :: %s", i2c_item.convert2string), UVM_MEDIUM)         
    analysis_port_mntr2scb.write(i2c_item);    
  end
  else if (ctrl == 0) begin
    // read only registers 
    data_reg_arr[4] = 8'h12;
    data_reg_arr[5] = 8'h34;
    data_reg_arr[6] = 8'h56;
    data_reg_arr[7] = 8'h78;
    wdata = data_reg_arr[reg_addr];
    i2c_item.reg_addr = reg_addr;
    i2c_item.rdata = read_data;
    i2c_item.wdata = wdata;
    i2c_item.ro_test = ro_test;
    i2c_item.assert_restart = stop_start_count >= 2 ? 1'b1 : 1'b0;
    i2c_item.dev_addr_wr = dev_addr_wr;
    i2c_item.dev_addr_rd = dev_addr_rd;
    analysis_port_mntr2scb.write(i2c_item);
    analysis_port_mntr2cov.write(i2c_item);
  end
 // `uvm_info(get_type_name(), $sformatf("########## [I2C_PRED] [Read-from-Reg] [ADDR = %0h][WDATA = %0h] [RDATA = %0h]", reg_addr, wdata, read_data), UVM_MEDIUM);
endtask



