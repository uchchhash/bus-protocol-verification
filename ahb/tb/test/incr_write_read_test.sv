`include "uvm_macros.svh"
import uvm_pkg::*;


class incr_write_read_test extends ahb_base_test;
  
	`uvm_component_utils(incr_write_read_test)
  
  	function new(string name="incr_write_read_test", uvm_component parent=null);
    		super.new(name, parent);
    		`uvm_info(get_type_name(), "---- AHB INCR_WRITE_READ Test Constructed ----", UVM_LOW);
  	endfunction

  	virtual function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
      		`uvm_info(get_type_name(), "AHB INCR_WRITE_READ Test 'Build Phase' Constructed", UVM_HIGH);  
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    		super.connect_phase(phase);
      		`uvm_info(get_type_name(), "AHB INCR_WRITE_READ Test 'Connect Phase' Started", UVM_HIGH);
  	endfunction
 
  	bit [31:0] start_address = 12;
  	bit[2:0] hburst = 7; //INCR=1/INCR4=3/INCR8=5/INCR16=7
  	bit [2:0] hsize = 2; //WORD=2/HALFWORD=1/BYTE=0
  
  
  	virtual task run_phase(uvm_phase phase);
    	phase.raise_objection(this);
       	`uvm_info(get_type_name(), "AHB INCR_WRITE_READ Test 'Run Phase' Started", UVM_HIGH);
        ahb_incr_write(start_address, hburst, hsize);
        ahb_incr_read(start_address, hburst, hsize);
       	phase.drop_objection(this);
  	endtask

endclass
