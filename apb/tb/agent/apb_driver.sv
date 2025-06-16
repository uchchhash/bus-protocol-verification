`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver #(apb_sequence_item);
  
    // analysis port to broadcast packet
    uvm_analysis_port #(apb_sequence_item) analysis_port_drvr;
    
    `uvm_component_utils(driver)
    // Virtual Interface
    virtual apb_interface apb_intf;
  
	function new(string name= "driver", uvm_component parent = null);
    	super.new(name, parent);
		`uvm_info(get_type_name(), $sformatf("---- APB Driver Constructed ----"), UVM_HIGH);
  	endfunction


   
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
      	`uvm_info(get_type_name(), "APB Driver 'Build Phase' Started", UVM_HIGH);
      	if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_interface", apb_intf))
        `uvm_fatal(get_type_name(), "Did not get virtual interface")
        analysis_port_drvr = new("analysis_port_drvr", this);
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	`uvm_info(get_type_name(), "APB Driver 'Connect Phase' Started", UVM_HIGH);
	endfunction
  
  apb_sequence_item apb_seq_item;
  	virtual task run_phase(uvm_phase phase);
  		super.run_phase(phase);
  		forever begin
      	    seq_item_port.get_next_item(apb_seq_item);
          	if(apb_seq_item.has_reset == 1 && apb_seq_item.has_write == 0 && apb_seq_item.has_read == 0) begin 
            	apb_reset();
          	end
          
            if(apb_seq_item.has_reset == 0 && apb_seq_item.has_write == 1 && apb_seq_item.has_read == 0) begin 
             	apb_write();
            end
          
            if(apb_seq_item.has_reset == 0 && apb_seq_item.has_write == 0 && apb_seq_item.has_read == 1) begin 
             	apb_read();
            end
     	    seq_item_port.item_done();
     	end
    endtask
    
    task apb_reset();
       `uvm_info(get_type_name(),"********** APB Reset Task Called **********", UVM_HIGH);
        apb_intf.PRESETn <= 1'b0;
		apb_intf.PADDR   <= 32'h0;
		apb_intf.PSEL    <= 1'b0;
		apb_intf.PENABLE <= 1'b0;
		apb_intf.PWRITE  <= 1'b0;
		apb_intf.PWDATA  <= 32'h0;
		@(negedge apb_intf.clk);
		
		apb_intf.PRESETn <= 1'b1;
		@(negedge apb_intf.clk);
    	
    endtask
    
    task apb_write();
       `uvm_info(get_type_name(),"********** APB WRITE Task Called **********", UVM_HIGH);
        if(!apb_seq_item.randomize()) begin
			$display("ERROR: APB Sequence Item Randomization Failed");
		end
		
		apb_intf.PSEL        <= 1'b1;
		apb_intf.PWRITE      <= 1'b1;
		apb_intf.PENABLE     <= 1'b0;
        apb_intf.PADDR       <= apb_seq_item.address;
     //   $display("Write Address Received at DRIVER  ========== %0d ", apb_seq_item.address );
        apb_intf.PWDATA      <= apb_seq_item.write_data;
     //   $display("Write Data Received at DRIVER  ========== %0d ", apb_seq_item.write_data);
		@(negedge apb_intf.clk);
		
		apb_intf.PENABLE  <= 1'b1;
		analysis_port_drvr.write(apb_seq_item);
		@(negedge apb_intf.clk);
		
		apb_intf.PENABLE  <= 1'b0;
		apb_intf.PSEL     <= 1'b0;
		@(negedge apb_intf.clk);
    		 

    endtask
    
    task apb_read();
        `uvm_info(get_type_name(),"********** APB READ Task Called **********", UVM_HIGH);
    	apb_intf.PWRITE  <= 1'b0;
		apb_intf.PSEL    <= 1'b1;
		apb_intf.PENABLE <= 1'b0;
		apb_intf.PADDR   <= apb_seq_item.address;
		@(negedge apb_intf.clk);
		
		apb_intf.PENABLE <= 1'b1;
		@(negedge apb_intf.clk);
		
		apb_intf.PSEL    <= 1'b0;
		apb_intf.PENABLE <= 1'b0;
		@(negedge apb_intf.clk);

    endtask
  
endclass
