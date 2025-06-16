class ahb_driver extends uvm_driver #(ahb_sequence_item);

    
    `uvm_component_utils(ahb_driver)
    virtual ahb_interface ahb_intf;
	// Semaphore Declaration
	semaphore transfer_lock = new(1);
    ahb_sequence_item item;
  
  
    function new(string name= "ahb_driver", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- AHB Driver Constructed ----", UVM_LOW);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "AHB Driver 'Build Phase' Started", UVM_HIGH);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "AHB Driver 'RUN Phase' Started", UVM_LOW)
        ahb_reset();  
        fork
            pipeline_transfer;
            pipeline_transfer;
        join
    endtask
     
   //--------------------------------------------------------------------------//
   //--------------------------- RESET TASK -----------------------------------//
   //--------------------------------------------------------------------------//


    task ahb_reset();
    	`uvm_info(get_type_name(),"********** AHB Reset Task Called **********", UVM_HIGH);
      	ahb_intf.HRESETN <= `ACTIVATE; // ACTIVATE RESET 
      	ahb_intf.HSEL    <= `LOW;
      	ahb_intf.HWRITE  <= `LOW;
      	ahb_intf.HTRANS  <= `IDLE;
      	ahb_intf.HSIZE   <= 3'b000;
      	ahb_intf.HBURST  <= 3'b000;
      	ahb_intf.HADDR   <= 32'h00000000;
      	ahb_intf.HWDATA  <= 32'h00000000; 
      	@(negedge ahb_intf.HCLK);
     
      	ahb_intf.HRESETN <= `DEACTIVATE; // DEACTIVATE RESET 
        @(negedge ahb_intf.HCLK);
    endtask
    
  
   	//-----------------------------------------------------------------------------------//
   	//-------------------------------- PIPELINE TRANSFER --------------------------------// 
  	//---------------------------------- WRITE & READ ----------------------------------//
 	//-----------------------------------------------------------------------------------//

    task pipeline_transfer();
  	    `uvm_info(get_type_name(),"********** AHB PIPELINE TRANSFER STARTED **********", UVM_HIGH);
      	forever begin
      		transfer_lock.get();
      		seq_item_port.get_next_item(item);
          	//------ ADDRESS PHASE ------//
      		//--- address & control ----//
            //`uvm_info(get_type_name(),"********** Address/Control Phase Started **********", UVM_HIGH);
      		ahb_intf.HRESETN <= `DEACTIVATE; 			
  		    ahb_intf.HSEL    <= `HIGH;
     		ahb_intf.HTRANS  <= item.htrans;
     		ahb_intf.HSIZE   <= item.hsize;    
      		ahb_intf.HBURST  <= item.hburst; 	
      		ahb_intf.HADDR   <= item.start_address;
      		ahb_intf.HWRITE  <= item.hwrite;
            @(negedge ahb_intf.HCLK);
      	    while(!ahb_intf.HREADY_I) @(negedge ahb_intf.HCLK);
      		transfer_lock.put();

      		//------- DATA PHASE -------//
      		//--- read & write data ---//
            //`uvm_info(get_type_name(),"********** Data Phase Started **********", UVM_HIGH);
          	ahb_intf.HWRITE  <= item.hwrite;
          	if(item.hwrite) begin
                ahb_intf.HWDATA <= item.write_data;
            end
       		seq_item_port.item_done();
        end
    endtask


endclass

