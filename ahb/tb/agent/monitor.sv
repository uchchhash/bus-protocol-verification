`include "uvm_macros.svh"
import uvm_pkg::*;


class monitor extends uvm_monitor;  

	`uvm_component_utils(monitor)
    ahb_sequence_item ahb_seq_item;
    virtual ahb_interface ahb_intf;
     
    // analysis port to broadcast packet
  	uvm_analysis_port #(ahb_sequence_item) analysis_port_mntr;
  	uvm_analysis_port #(ahb_sequence_item) analysis_port_cov;
  
  	function new(string name="monitor", uvm_component parent = null);
		super.new(name, parent);
      	`uvm_info(get_type_name(), "---- AHB Monitor Constructed ----", UVM_LOW);
	endfunction
  
    
    virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
      	`uvm_info(get_type_name(), "AHB Monitor 'Build Phase' Started", UVM_HIGH);
      	if (!uvm_config_db#(virtual ahb_interface)::get(this, "", "ahb_interface", ahb_intf))
        	`uvm_fatal(get_type_name(), "Did not get virtual interface")
        analysis_port_mntr = new("analysis_port_mntr", this);
      	analysis_port_cov = new("analysis_port_cov", this);
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
      	`uvm_info(get_type_name(), "AHB Monitor 'Connect Phase' Started", UVM_HIGH);
    endfunction 
   
    virtual task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	fork
    		begin
    			forever begin
          			@(negedge ahb_intf.HCLK);
          			if(ahb_intf.HSELx == 1 && ahb_intf.HRESETn == 1  && ahb_intf.HWRITE == 0) begin
          				ahb_seq_item = ahb_sequence_item::type_id::create("ahb_seq_item", this);
    					ahb_seq_item.read_data = ahb_intf.HRDATA;
                    	ahb_seq_item.start_address = ahb_intf.HADDR;
                		//	$display("[READ DATA FROM MONITOR >>] Act_Data : %0h , Act_Address : %0h, @[%0t]",ahb_seq_item.read_data,ahb_seq_item.start_address, $time);
                    	analysis_port_mntr.write(ahb_seq_item);
                  		//	analysis_port_cov.write(ahb_seq_item);
                	end
    			end
            end
    	    begin	
		    	forever begin
                  @(negedge ahb_intf.HCLK); 
					ahb_seq_item = ahb_sequence_item::type_id::create("ahb_seq_item", this);
                  	ahb_seq_item.hselx = ahb_intf.HSELx;
                  	ahb_seq_item.hwrite = ahb_intf.HWRITE;
                  	ahb_seq_item.hresetn = ahb_intf.HRESETn;
                  	ahb_seq_item.htrans = ahb_intf.HTRANS;
                  	ahb_seq_item.hsize = ahb_intf.HSIZE;
                  	ahb_seq_item.hburst = ahb_intf.HBURST;
                  	ahb_seq_item.start_address = ahb_intf.HADDR;
                  	ahb_seq_item.read_data = ahb_intf.HRDATA;
                  	ahb_seq_item.hready = ahb_intf.HREADY;
                  	ahb_seq_item.hresp = ahb_intf.HRESP;
                  	ahb_seq_item.write_data = ahb_intf.HWDATA;
                  //	$display("[@ %0t] Monitor to Coverage Transaction >>>>>>>>>>" ,$time);
                  //	$display("[@ %0t] HRESP = %0d, HREADY = %0d, HSELx = %0d, HRESETn = %0d, HTRANS = %0d, HSIZE = %0d, HBURST = %0d", $time,ahb_seq_item.hresp , ahb_seq_item.hready, ahb_seq_item.hselx, ahb_seq_item.hresetn, ahb_seq_item.htrans,ahb_seq_item.hsize, ahb_seq_item.hburst);
                  //	$display("[@ %0t] ADDRESS = %0h, WRITE_DATA = %0h, READ_DATA = %0h",$time, ahb_seq_item.start_address, ahb_seq_item.write_data, ahb_seq_item.read_data);
                  	analysis_port_cov.write(ahb_seq_item);
				end
			end
		join
    endtask

  
endclass
