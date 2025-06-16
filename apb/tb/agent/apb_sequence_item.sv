`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_sequence_item extends uvm_sequence_item;

  	`uvm_object_utils(apb_sequence_item)

  	function new(string name= "apb_sequence_item");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- APB Sequence Item Constructed ----", UVM_HIGH);
  	endfunction
  
  	 bit has_reset;
  	 bit has_read;
  	 bit has_write;
  
     rand logic [31:0] write_data;
  	 bit [31:0] read_data;
 	 bit [31:0] address;
 	 logic PRESETn;
 	 logic PSEL;
 	 logic PENABLE;
 	 logic PWRITE;

  
  
endclass
