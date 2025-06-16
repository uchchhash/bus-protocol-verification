`include "uvm_macros.svh"
import uvm_pkg::*;

class monitor extends uvm_monitor;
  
    `uvm_component_utils(monitor)
    apb_sequence_item apb_seq_item;
     virtual apb_interface apb_intf;
     
    // analysis port to broadcast packet
    uvm_analysis_port #(apb_sequence_item) analysis_port_mntr;
    uvm_analysis_port #(apb_sequence_item) analysis_port_cov;
  
    function new(string name="minitor", uvm_component parent = null);
		super.new(name, parent);
    	`uvm_info(get_type_name(), "---- APB Monitor Constructed ----", UVM_HIGH);
	endfunction
  
    
    virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
 	    `uvm_info(get_type_name(), "APB Monitor 'Build Phase' Started", UVM_HIGH);
 	    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_interface", apb_intf))
        `uvm_fatal(get_type_name(), "Did not get virtual interface")
        analysis_port_mntr = new("analysis_port_mntr", this);
        analysis_port_cov = new("analysis_port_cov", this);
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	`uvm_info(get_type_name(), "APB Monitor 'Connect Phase' Started", UVM_HIGH);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	fork
    		begin
    			forever begin
    				@(negedge apb_intf.clk);
    				if(apb_intf.PRESETn == 1 && apb_intf.PSEL == 1  && apb_intf.PENABLE == 1 && apb_intf.PWRITE == 0) begin
    		    		apb_seq_item = apb_sequence_item::type_id::create("apb_seq_item", this);
    					apb_seq_item.read_data = apb_intf.PRDATA;
    					apb_seq_item.address = apb_intf.PADDR;
    					analysis_port_mntr.write(apb_seq_item);
    				end	
	    		end
    		end
    		
    	    begin	
		    	forever begin
					@(negedge apb_intf.clk); 
					// Write Condition
					if(apb_intf.PRESETn == 1 && apb_intf.PSEL == 1  && apb_intf.PENABLE == 1 && apb_intf.PWRITE == 1)begin
			    		apb_seq_item = apb_sequence_item::type_id::create("apb_seq_item", this);
						apb_seq_item.write_data = apb_intf.PWDATA;
						apb_seq_item.address = apb_intf.PADDR;
						apb_seq_item.PRESETn = apb_intf.PRESETn;
						apb_seq_item.PSEL = apb_intf.PSEL;
						apb_seq_item.PENABLE = apb_intf.PENABLE;
						apb_seq_item.PWRITE = apb_intf.PWRITE;
						analysis_port_cov.write(apb_seq_item);
					//	$display("Monitor to Coverage Transaction >>>>");
    				//	$display("PWRITE = %0d , PENABLE = %0d , PSEL = %0d, PRESETn = %0d , WRITE_DATA = %0h, ADDRESS = %0h, READ_DATA = %0h", apb_seq_item.PWRITE, apb_seq_item.PENABLE, apb_seq_item.PSEL, apb_seq_item.PRESETn, apb_seq_item.write_data, apb_seq_item.address, apb_seq_item.read_data);
					end
          
          			// Read Condition
          			else if(apb_intf.PRESETn == 1 && apb_intf.PSEL == 1  && apb_intf.PENABLE == 1 && apb_intf.PWRITE == 0)begin
						apb_seq_item = apb_sequence_item::type_id::create("apb_seq_item", this);
						apb_seq_item.read_data = apb_intf.PRDATA;
						apb_seq_item.address = apb_intf.PADDR;
						apb_seq_item.PRESETn = apb_intf.PRESETn;
						apb_seq_item.PSEL = apb_intf.PSEL;
						apb_seq_item.PENABLE = apb_intf.PENABLE;
						apb_seq_item.PWRITE = apb_intf.PWRITE;
              		    analysis_port_cov.write(apb_seq_item);
					 //   $display("Monitor to Coverage Transaction >>>>");
    				//	$display("PWRITE = %0d , PENABLE = %0d , PSEL = %0d, PRESETn = %0d , WRITE_DATA = %0h, ADDRESS = %0h, READ_DATA = %0h", apb_seq_item.PWRITE, apb_seq_item.PENABLE, apb_seq_item.PSEL, apb_seq_item.PRESETn, apb_seq_item.write_data, apb_seq_item.address, apb_seq_item.read_data);
					end
					// RESET Condition
					else if (apb_intf.PRESETn == 0)begin
						apb_seq_item = apb_sequence_item::type_id::create("apb_seq_item", this);
						apb_seq_item.PRESETn = apb_intf.PRESETn;
						analysis_port_cov.write(apb_seq_item);
					end
          
           		 // Other Conditions
          			else begin
             		   	apb_seq_item = apb_sequence_item::type_id::create("apb_seq_item", this);
               		    apb_seq_item.PRESETn = apb_intf.PRESETn;
						apb_seq_item.PSEL = apb_intf.PSEL;
						apb_seq_item.PENABLE = apb_intf.PENABLE;
               			analysis_port_cov.write(apb_seq_item);
					  //  $display("Monitor to Coverage Transaction >>>>");
    					//$display("PWRITE = %0d , PENABLE = %0d , PSEL = %0d, PRESETn = %0d , WRITE_DATA = %0h, ADDRESS = %0h, READ_DATA = %0h", apb_seq_item.PWRITE, apb_seq_item.PENABLE, apb_seq_item.PSEL, apb_seq_item.PRESETn, apb_seq_item.write_data, apb_seq_item.address, apb_seq_item.read_data);
           		 	end
           		 	
				end
			end
	join
    endtask
  
endclass
