`include "uvm_macros.svh"
import uvm_pkg::*;

class ahb_sequence extends uvm_sequence;
	`uvm_object_utils(ahb_sequence)
  
  	function new(string name="ahb_sequence");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- AHB Sequence Constructed ----", UVM_LOW);
  	endfunction

  	//---- Flags to control the test type ----//
    bit has_reset;
    bit has_read;
  	bit has_write;
  
  	//---- Data and Address ----//
    bit [`addrWidth-1:0] start_address;
    
    //---- Control Signals ----//
    bit [1:0] htrans;
    bit [2:0] hsize;
    bit [2:0] hburst;
    int burst_size;     // #burst from hburst
    int transfer_size;  // #Bytes from hsize
  	bit hselx;
  	bit hwrite;
  	bit hresetn;
  	bit hready;
  	bit hresp;

  
  	//---- Response Handler ---//
    int count;
  
    //------Wrap Info Calculation------//
	int wrap_boundary; // Lower address to WRAP to
	int upper_limit;   // Upper address limit to make WRAP
	
	task body();
		ahb_sequence_item item;
		item = ahb_sequence_item::type_id::create("item");
      	use_response_handler(1);
		count = 0;
      	//-------
      	item.hselx = hselx;
      	item.hwrite = hwrite;
      	item.hresetn = hresetn;
      	item.hready = hready;
      	item.hresp = hresp;
      	//------
		wrap_info(hburst, hsize, transfer_size, burst_size, wrap_boundary, upper_limit);
		if(has_reset)begin
          `uvm_do_with(item,{item.has_reset == has_reset;})
      	end
		else begin
 			start_item(item);
      		item.hburst= hburst;
      		item.hsize = hsize;
      		item.htrans  = `NONSEQ;
      		if(has_write)begin
      			item.has_write = has_write;
      			item.write_data = $urandom_range((2**(transfer_size*8))-1);
      		end
      		if(has_write || has_read)begin
      			item.has_read = has_read;
          		if(hburst ==`SINGLE)begin
              		item.start_address = start_address;
            		start_address = start_address + transfer_size;
        		end 
        		else begin
					if(hburst== `WRAP4 || hburst == `WRAP8 || hburst == `WRAP16) begin
               			if(start_address < upper_limit) begin
       						item.start_address   = start_address;
                      		start_address = start_address + transfer_size;
       					end
	         			if(start_address >= upper_limit) begin
       						item.start_address   = wrap_boundary;
                			start_address = wrap_boundary;
                        	start_address = start_address + transfer_size;
       					end
					end
            		else begin 
                    	item.start_address = start_address;
            			start_address = start_address + transfer_size;
            		end
        		end
        		finish_item(item);
			end
      		for(int i=1; i<burst_size; i=i+1) begin
				start_item(item);
				if(has_write)begin
					item.has_write = has_write;
      				item.write_data = $urandom_range((2**(transfer_size*8))-1);
      			end
				if(has_write || has_read)begin
					item.has_read = has_read;
        			if(hburst ==`SINGLE)begin
        				item.htrans  = `NONSEQ;
            			item.start_address = start_address;
            			start_address = start_address + transfer_size;
        			end
					else begin
						item.htrans  = `SEQ;
        				if(hburst== `WRAP4 || hburst == `WRAP8 || hburst == `WRAP16) begin
               				if(start_address < upper_limit) begin
       							item.start_address   = start_address;
                      			start_address = start_address + transfer_size;
                      		//	$display("Address = %0d", item.start_address);
       						end
                      		if(start_address >= upper_limit) begin
                          	//	$display("upper limit = %0d", upper_limit);
       							item.start_address   = wrap_boundary;
                        		start_address = wrap_boundary + transfer_size;
       						end
                    	end
             			else begin
              				item.start_address = start_address;
            				start_address = start_address + transfer_size;
             			end
					end
          			finish_item(item);
				end
           	 end
           	 wait(count == burst_size);
		end
	endtask
	
	
	function void response_handler(uvm_sequence_item response);
		count++;
	endfunction
  
  	//------------ CALCULATE WRAP INFO ----------//
  	function void wrap_info(input int hburst, int hsize, output int transfer_size, int burst_size, int wrap_boundary, int upper_limit);
    	`uvm_info(get_type_name(),"********** WRAP INFO CALCULATION **********", UVM_HIGH);
      	if(hburst== `WRAP8 || hburst == `INCR8)begin
        	burst_size = 8;
      	end
      	else if (hburst == `WRAP4 || hburst == `INCR4)begin
        	burst_size = 4;
      	end
      	else begin //SINGLE/INCR/INCR16/WRAP16
        	burst_size = 16; 
      	end
      	transfer_size = 2**(hsize);
    	wrap_boundary = (start_address/(burst_size*transfer_size))*(burst_size*transfer_size);
    	upper_limit = wrap_boundary+(burst_size*transfer_size);
  	endfunction

endclass
