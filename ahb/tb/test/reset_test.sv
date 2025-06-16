`include "uvm_macros.svh"
import uvm_pkg::*;


class reset_test extends ahb_base_test;
	`uvm_component_utils(reset_test)
  
  	function new(string name="reset_test", uvm_component parent=null);
    	super.new(name, parent);
      	`uvm_info(get_type_name(), "---- AHB RESET Test Constructed ----", UVM_LOW);
  	endfunction

  
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
      	`uvm_info(get_type_name(), "AHB RESET Test 'Build Phase' Constructed", UVM_HIGH);   
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
      	`uvm_info(get_type_name(), "AHB RESET Test 'Connect Phase' Started", UVM_HIGH);
  	endfunction
  
  	virtual task run_phase(uvm_phase phase);
    	phase.raise_objection(this);
        `uvm_info(get_type_name(), "AHB RESET Test 'Run Phase' Started", UVM_HIGH);
        ahb_reset();
    	phase.drop_objection(this);
  	endtask
  
  
endclass
