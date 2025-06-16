class environment_config extends uvm_object;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //  
  `uvm_object_utils(environment_config)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  bit has_scoreboard = 1;
  bit has_functional_coverage = 1;
 	

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  function new(string name = "environment_config");
    super.new(name);
    `uvm_info(get_type_name(), "***** AXI Environment Config Constructed *****", UVM_NONE);	
  endfunction
  	

endclass : environment_config


