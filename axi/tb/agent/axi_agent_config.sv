class axi_agent_config extends uvm_object;

	// -------------------------------- //
	// ----- Factory Registration ----- //
	// -------------------------------- //  
  	`uvm_object_utils(axi_agent_config)
  	
	// -------------------------------- //
	// -------- Data Members  --------- //
	// -------------------------------- //
  	uvm_active_passive_enum status = UVM_ACTIVE;
  	
	// -------------------------------- //
	// ---- Methods of Env Config ----- //
	// -------------------------------- //  	
	//extern function new(string name = "environment_config", uvm_component parent = null);	 	
	
	// -------------------------------- //
	// ----- Constructor Function ----- //
	// -------------------------------- //
	function new(string name = "axi_agent_config");
		super.new(name);
		`uvm_info(get_type_name(), "***** AXI Agent Config Constructed *****", UVM_NONE);	
	endfunction
  	

endclass : axi_agent_config


