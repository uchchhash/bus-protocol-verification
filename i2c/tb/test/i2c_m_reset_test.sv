class i2c_m_reset_test extends i2c_m_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_reset_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //

  // -------------------------------- //
  // ----- Methods of Reset Test ---- //
  // -------------------------------- //
  extern function new(string name = "i2c_m_reset_test", uvm_component parent = null);	
  extern task run_phase(uvm_phase phase);

endclass : i2c_m_reset_test


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_reset_test::new(string name = "i2c_m_reset_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C Slave Reset Test Constructed *****", UVM_NONE);	
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task i2c_m_reset_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** I2C Slave Reset Test : Run Phase Started  *****", UVM_MEDIUM);	
 
  run_i2c_reset_sequence();
  
  `uvm_info(get_type_name(), "***** I2C Slave Reset Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);
endtask
  

