class i2c_m_agent_config extends uvm_object;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //  
 `uvm_object_utils(i2c_m_agent_config)
          
  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  uvm_active_passive_enum status = UVM_ACTIVE; 
  bit assert_write;
  bit assert_read;
  bit assert_restart;
  bit ro_test;

  // 
  bit rw_ctrl;

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  function new(string name = "i2c_m_agent_config");
    super.new(name);
    `uvm_info(get_type_name(), "***** I2C Slave Agent Config Constructed *****", UVM_NONE);	
  endfunction
  	

endclass : i2c_m_agent_config
