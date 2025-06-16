`include "uvm_macros.svh"
import uvm_pkg::*;

class environment_config extends uvm_object;
 
  	`uvm_object_utils(environment_config)
  	

  	function new(string name= "environment_config");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- APB ENV_CONFIG Constructed ----", UVM_HIGH);
  	endfunction
  	
  	bit has_scoreboard;
  	
  	

endclass
