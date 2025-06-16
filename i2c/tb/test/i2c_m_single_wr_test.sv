class i2c_m_single_wr_test extends i2c_m_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_single_wr_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //

  // Flags to control randomization
  bit rand_addr = 0;
  bit rand_data = 0;

  // Data & Address
  bit [7:0] reg_addr = 0;
  byte data_byte_1 = 8'h89; 
  byte data_byte_2 = 8'hab;
  byte data_byte_3 = 8'hcd;
  byte data_byte_4 = 8'hef;
  bit [31:0] write_data = {data_byte_4, data_byte_3, data_byte_2, data_byte_1};

  // -------------------------------- //
  // ----- Methods of Register_Write_Read Test ---- //
  // -------------------------------- //
  extern function new(string name = "i2c_m_single_wr_test", uvm_component parent = null);	
  extern task run_phase(uvm_phase phase);

endclass : i2c_m_single_wr_test


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_single_wr_test::new(string name = "i2c_m_single_wr_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C RW Register Sigle Write-Read Test Constructed *****", UVM_NONE);	
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task i2c_m_single_wr_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** I2C RW Register Single Write-Read Test : Run Phase Started  *****", UVM_MEDIUM);	
 
  run_i2c_reset_sequence();
  run_i2c_single_write(reg_addr, rand_addr, write_data, rand_data);
  run_i2c_single_read(reg_addr, rand_addr);

  `uvm_info(get_type_name(), "***** I2C RW Register Single Write-Read Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);
endtask

