`include "uvm_macros.svh"
import uvm_pkg::*;

class write_read_test extends apb_base_test;
  
    `uvm_component_utils(write_read_test)
  
  	function new(string name="write_read_test", uvm_component parent=null);
    	super.new(name, parent);
        `uvm_info(get_type_name(), "---- APB WRITE_READ Test Constructed ----", UVM_HIGH);
  	endfunction

    //int has_scoreboard;
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
        `uvm_info(get_type_name(), "APB WRITE_READ Test 'Build Phase' Constructed", UVM_HIGH);  
         env_config.has_scoreboard = 1;
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
        `uvm_info(get_type_name(), "APB WRITE_READ Test 'Connect Phase' Started", UVM_HIGH);
  	endfunction
  
  	virtual task run_phase(uvm_phase phase);
    	phase.raise_objection(this);
        `uvm_info(get_type_name(), "APB WRITE_READ Test 'Run Phase' Started", UVM_HIGH);
        apb_reset();
      for(int i = 0; i < 256; i++) begin		
			apb_write(i);
            apb_read(i);
        end
    	phase.drop_objection(this);
  	endtask
  
  
endclass
