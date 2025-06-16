`include "uvm_macros.svh"
import uvm_pkg::*;


class apb_sequence extends uvm_sequence;
	
  	`uvm_object_utils(apb_sequence)
  
	function new(string name="apb_sequence");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- APB Sequence Constructed ----", UVM_HIGH);
  	endfunction
  	
  	apb_sequence_item apb_seq_item;
  	bit has_reset;
  	bit has_read;
  	bit has_write;
    bit [31:0] address;
  	
  	virtual task body();
  		apb_seq_item = apb_sequence_item::type_id::create("apb_seq_item");
        start_item(apb_seq_item);
  	    apb_seq_item.has_reset = has_reset;
  	    apb_seq_item.has_read= has_read;
  	    apb_seq_item.has_write = has_write;
  	  	//  $display("Address Received at Sequence ========== %0d ", address );
        apb_seq_item.address = address;
     	//   $display("Address Received at Sequence_ITEM ========== %0d ", apb_seq_item.address );
  	    finish_item(apb_seq_item);
  	endtask
  

endclass
