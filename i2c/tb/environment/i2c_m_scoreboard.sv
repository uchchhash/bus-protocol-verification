


// Declare imp for expected and actual items 
`uvm_analysis_imp_decl(_port_mntr2scb)


class i2c_m_scoreboard extends uvm_scoreboard;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_scoreboard)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  i2c_m_sequence_item i2c_item;
  uvm_analysis_imp_port_mntr2scb#(i2c_m_sequence_item, i2c_m_scoreboard) analysis_imp_mntr2scb;
       

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  int pass_count, fail_count;

  // --------------------------------- //
  // ----- Methods of AXI Driver ----- //
  // --------------------------------- //
  extern function new(string name = "i2c_m_scoreboard", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern function void write_port_mntr2scb (i2c_m_sequence_item i2c_item);
  extern function void report_phase(uvm_phase phase);		

endclass

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_scoreboard::new(string name="i2c_m_scoreboard", uvm_component parent= null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C Master Scoreboard Constructed *****", UVM_NONE);
endfunction


// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void i2c_m_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "***** I2C Master Scoreboard : Inside Build Phase *****", UVM_NONE);
    analysis_imp_mntr2scb    = new("analysis_imp_mntr2scb", this);      
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

function void i2c_m_scoreboard::write_port_mntr2scb(i2c_m_sequence_item i2c_item);
  if(i2c_item.ctrl == 0) begin
    if(i2c_item.wdata == i2c_item.rdata) begin
      `uvm_info (get_type_name(), $sformatf("  PASS :: EXP_ADDR = %0h | EXP_DATA = %0h ||  ACT_ADDR = %0h | ACT_DATA = %0h", i2c_item.reg_addr, i2c_item.wdata, i2c_item.reg_addr, i2c_item.rdata), UVM_MEDIUM);
      pass_count++;
    end
    else begin
      `uvm_info (get_type_name(), $sformatf("  FAIL :: EXP_ADDR = %0h | EXP_DATA = %0h ||  ACT_ADDR = %0h | ACT_DATA = %0h", i2c_item.reg_addr, i2c_item.wdata, i2c_item.reg_addr, i2c_item.rdata), UVM_MEDIUM);
      fail_count++;
    end
  end
  else if (i2c_item.ctrl == 1) begin
    if(i2c_item.dev_addr_wr == 8'h78) begin
      `uvm_info (get_type_name(), $sformatf("  PASS :: EXP_DEV_ADDR_WR = %0h ||  ACT_DEV_ADDR_WR = %0h", i2c_item.dev_addr_wr, 8'h78), UVM_MEDIUM);
      pass_count++;
    end
    else begin
      `uvm_info (get_type_name(), $sformatf("  FAIL :: EXP_DEV_ADDR_WR = %0h ||  ACT_DEV_ADDR_WR = %0h", i2c_item.dev_addr_wr, 8'h78), UVM_MEDIUM);
      fail_count++;
    end
  end
  else if (i2c_item.ctrl == 2) begin
      if(i2c_item.dev_addr_rd == 8'h79) begin
      `uvm_info (get_type_name(), $sformatf("  PASS :: EXP_DEV_ADDR_RD = %0h ||  ACT_DEV_ADDR_RD = %0h", i2c_item.dev_addr_rd, 8'h79), UVM_MEDIUM);
      pass_count++;
    end
    else begin
      `uvm_info (get_type_name(), $sformatf("  FAIL :: EXP_DEV_ADDR_RD = %0h ||  ACT_DEV_ADDR_RD = %0h", i2c_item.dev_addr_rd, 8'h79), UVM_MEDIUM);
      fail_count++;
    end
  end
endfunction



function void i2c_m_scoreboard::report_phase(uvm_phase phase);
  // `uvm_info(get_type_name(),"AXI Scoreboard 'Report Phase' Started", UVM_MEDIUM)
  repeat(2) $display();
  if(fail_count !=0)begin
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ********      *        ********    **          ********    *******       |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ******       * *          **       **          **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **          *****         **       **          ********    *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **         *     *        **       **          **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **        *       *    ********    ********    ********    *******       |"), UVM_MEDIUM)  
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)      
  end
  else begin
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ********       *       ********    ********    ********    *******       |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **    **      * *      **          **          **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ********     *****     ********    ********    ********    *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **          *     *          **          **    **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **         *       *   ********    ********    ********    *******       |"), UVM_MEDIUM) 
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)       
  end
  `uvm_info (get_type_name(), $sformatf("=============================== Report Summary ==============================="), UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("======    Total Test: %0d   ||  Total Pass: %0d  ||  Total Fail: %0d    ======", pass_count+fail_count,pass_count, fail_count),UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
endfunction




