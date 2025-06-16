class i2c_m_sequencer extends uvm_sequencer #(i2c_m_sequence_item);
	
  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 	
  `uvm_component_utils(i2c_m_sequencer)
  
  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  function new(string name = "i2c_m_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "***** I2C Slave Sequencer Constructed *****", UVM_NONE);	
  endfunction 
  
  
endclass : i2c_m_sequencer


