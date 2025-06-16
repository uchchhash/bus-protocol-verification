class environment_config extends uvm_object;
 
  	`uvm_object_utils(environment_config)
  	

  	function new(string name= "environment_config");
    	super.new(name);
        `uvm_info(get_type_name(), "==== Environment Config Constructed ====", UVM_MEDIUM);
  	endfunction
  	
  	bit has_scoreboard = 1;

endclass
