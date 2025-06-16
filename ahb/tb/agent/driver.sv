`include "uvm_macros.svh"
import uvm_pkg::*;


class driver extends uvm_driver #(ahb_sequence_item);

	uvm_analysis_port #(ahb_sequence_item) analysis_port_drvr;
    
    `uvm_component_utils(driver)
    virtual ahb_interface ahb_intf;
   	ahb_sequence_item item, item1;
	// Semaphore Declaration
	semaphore transfer_lock = new(1);
  
  
	function new(string name= "driver", uvm_component parent = null);
    	super.new(name, parent);
    	`uvm_info(get_type_name(),"---- AHB Driver Constructed ----", UVM_LOW);
  	endfunction


  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	`uvm_info(get_type_name(), "AHB Driver 'Build Phase' Started", UVM_HIGH);
    	if (!uvm_config_db#(virtual ahb_interface)::get(this, "", "ahb_interface", ahb_intf))
        `uvm_fatal(get_type_name(), "Did not get virtual interface")
        analysis_port_drvr = new("analysis_port_drvr", this);
      item1 = ahb_sequence_item::type_id::create("item1");
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
      	`uvm_info(get_type_name(), "AHB Driver 'Connect Phase' Started", UVM_HIGH);
	endfunction
  
  
  	virtual task run_phase(uvm_phase phase);
  		super.run_phase(phase);
       	`uvm_info(get_type_name(), "AHB Driver 'RUN Phase' Started", UVM_LOW)
    	ahb_reset();
     	fork
     		do_pipeline_transfer;
     		do_pipeline_transfer;
     	join
    endtask
     
   //--------------------------------------------------------------------------//
   //--------------------------- RESET TASK -----------------------------------//
   //--------------------------------------------------------------------------//


    task ahb_reset();
    	`uvm_info(get_type_name(),"********** AHB Reset Task Called **********", UVM_HIGH);
      	ahb_intf.HRESETn <= 1'b0; // ACTIVATE RESET 
      	ahb_intf.HSELx   <= 1'b0;
      	ahb_intf.HWRITE  <= 1'b0;
      	ahb_intf.HTRANS  <= 2'b00;
      	ahb_intf.HSIZE   <= 3'b000;
      	ahb_intf.HBURST  <= 3'b000;
      	ahb_intf.HADDR   <= 0;
      	ahb_intf.HWDATA  <= 0; 
      	@(negedge ahb_intf.HCLK);
     
      	ahb_intf.HRESETn <= 1'b1; // DEACTIVATE RESET 
      	@(negedge ahb_intf.HCLK);
    endtask
  
   
   	//-----------------------------------------------------------------------------------//
   	//-------------------------------- PIPELINE TRANSFER --------------------------------// 
  	//---------------------------------- WRITE & READ ----------------------------------//

    
    task do_pipeline_transfer();
  		`uvm_info(get_type_name(),"********** AHB PIPELINE TRANSFER STARTED **********", UVM_HIGH);
      	forever begin
          	 //------ ADDRESS PHASE ------//
      		//--- address & control ----//
      		transfer_lock.get();
      		seq_item_port.get(item);
      		ahb_intf.HRESETn <= 1'b1; 			// DEACTIVATE RESET 
     		ahb_intf.HSELx   <= 1'b1;   		// SELECT HIGH
     		ahb_intf.HTRANS  <= item.htrans;	// SEQ/NONSEQ
     		ahb_intf.HSIZE   <= item.hsize;     // WORD/HALFWORD/BYTE
      		ahb_intf.HBURST  <= item.hburst; 	// SINGLE/INCR/WRAP
      		ahb_intf.HADDR   <= item.start_address;    // DRIVE ADDRESS
      		if(item.has_write)begin
      			ahb_intf.HWRITE  <= 1'b1;   		// WRITE DATA
      		end
      		else begin
      			ahb_intf.HWRITE  <= 1'b0;   		// READ DATA
      		end
      		@(negedge ahb_intf.HCLK);
      		if(!ahb_intf.HREADY)begin
        		@(negedge ahb_intf.HCLK);
       		end
      		transfer_lock.put();   
      		   		
      		//------- DATA PHASE -------//
      		//--- read & write data ---//
			if(item.has_write)begin
			//	$display("DATA_PHASE_STARTED [WRITE]. . . . . @[%0t]", $time);
				ahb_intf.HWRITE  <= 1'b1;   		// WRITE DATA
              item1=ahb_sequence_item::type_id::create("item1");
        		ahb_intf.HWDATA  <= item.write_data; // DRIVE DATA
                item1.write_data = item.write_data;
              item1.start_address = item.start_address;
           //   $display("write data item = %0h", item.write_data);
            //  $display("write data item1 = %0h", item1.write_data);
              analysis_port_drvr.write(item1);
            end
        	else begin
        	//	$display("DATA_PHASE_STARTED [READ]. . . . . @[%0t]", $time);
     			ahb_intf.HWRITE  <= 1'b0;   		// READ DATA
        	end
      		if(!ahb_intf.HREADY)begin
        		@(negedge ahb_intf.HCLK);
       		end
       		seq_item_port.put(item);
        end
    endtask

endclass

