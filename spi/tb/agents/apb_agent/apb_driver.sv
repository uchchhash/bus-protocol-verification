class apb_driver extends uvm_driver #(apb_sequence_item);

    // Factory Registration
    `uvm_component_utils(apb_driver)

    // APB Interface
    virtual apb_interface apb_intf;
    apb_sequence_item apb_item;
  
    // Constructor Function
    function new(string name= "apb_driver", uvm_component parent = null);
        super.new(name, parent);
    	`uvm_info(get_type_name(),"---- APB Driver Constructed ----", UVM_LOW);
    endfunction

    // ---------- BUild Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "APB Driver 'Build Phase' Started", UVM_HIGH);
    endfunction
   

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
     //	`uvm_info(get_type_name(), "APB Driver 'RUN Phase' Started", UVM_LOW)
        apb_reset();
        apb_transfer();
    endtask

    //----- Inidividual Tasks -----//
    task apb_reset();
      //  `uvm_info(get_type_name(),"********** APB Reset Task Called **********", UVM_HIGH);
      	apb_intf.PRESETn      <= 1'b0;
        apb_intf.PSEL <= 1'b0;
        apb_intf.PENABLE <= 1'b0;
        apb_intf.PWRITE <= 1'b0;
        apb_intf.PADDR  <= 0;
        apb_intf.PWDATA <= 0;
      	@(posedge apb_intf.PCLK);
        apb_intf.PRESETn      <= 1'b1;
        @(posedge apb_intf.PCLK);
        apb_intf.PRESETn      <= 1'b0;
        @(posedge apb_intf.PCLK);
        apb_intf.PRESETn      <= 1'b1;
      	@(posedge apb_intf.PCLK);
    endtask

    
    task apb_write_read();
		apb_intf.PRESETn <= 1'b1;
		apb_intf.PSEL  <= 1'b1;
		apb_intf.PWRITE <= apb_item.pwrite;
		if(apb_item.pwrite == 1'b1) begin
		apb_intf.PADDR  <= apb_item.write_addr;
		apb_intf.PWDATA <= apb_item.write_data;
		end
		else if (apb_item.pwrite == 1'b0) begin
		apb_intf.PADDR  <= apb_item.read_addr;
		end
		@(posedge apb_intf.PCLK);
		apb_intf.PENABLE <= 1'b1;
		wait (apb_intf.PREADY);
		apb_item.read_data = apb_intf.PRDATA; // Capture Read Data when PREADY,PSEL,PENABLE is high
		//`uvm_info (get_type_name(), $sformatf(" RDATA = %0h", apb_item.read_data), UVM_LOW)
		@(posedge apb_intf.PCLK);
		apb_intf.PENABLE  <= 1'b0;
		apb_intf.PSEL     <= 1'b0;
		@(posedge apb_intf.PCLK);
    endtask
    
    task apb_transfer();
        forever begin
            seq_item_port.get_next_item(apb_item);
            //`uvm_info(get_type_name(),"********** APB Transfer Task Called **********", UVM_LOW);                     
            //`uvm_info (get_type_name(), $sformatf(" Has_Reset = %0d", apb_item.has_reset), UVM_LOW)
            if(apb_item.has_reset == 1) begin
                 //`uvm_info (get_type_name(), $sformatf(" Has_Reset = %0d", apb_item.has_reset), UVM_LOW)
            	 apb_reset();            
            end
            else if (apb_item.has_reset == 0) begin       
			//	apb_reset();
				apb_write_read();
		        //`uvm_info(get_type_name(),"********** APB Transfer Task Finished **********", UVM_LOW);
            end
            seq_item_port.item_done();
        end
    endtask   
    
endclass


