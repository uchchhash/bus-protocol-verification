`uvm_analysis_imp_decl(_port_APBmntrAP)

class interrupt_predictor extends uvm_component;

	// Factory Registration
	`uvm_component_utils(interrupt_predictor)
	
	// Required Instances
	uvm_analysis_imp_port_APBmntrAP #(apb_sequence_item, interrupt_predictor) analysis_imp_APBmntrAP;
	uvm_analysis_port #(apb_sequence_item) analysis_port_INTRpredAP;
	apb_sequence_item intr_item;
    
    // Required Variables
    bit go_bsy_val;
    bit ie_val;
  
	//---- interrupt ----//
	uvm_event apb_tx_done;
	uvm_event spi_tx_done;

    function new(string name = "ahb_predictor", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "===== Interrupt Predictor Constructed =====", UVM_LOW)
    endfunction

    virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_type_name(), "===== Interrupt Predictor Build Phase Started =====", UVM_LOW)
		analysis_imp_APBmntrAP = new("analysis_imp_APBmntrAP", this); 
		analysis_port_INTRpredAP = new("analysis_port_INTRpredAP", this);  

		//----- interrupt handling -------//
		if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done",spi_tx_done)) begin
		`uvm_fatal(get_type_name(), "Did not get the SPI EVENT")
		end
		else `uvm_info(get_type_name(), "Got the SPI EVENT at interrupt", UVM_MEDIUM);

		if(!uvm_config_db#(uvm_event)::get(this,"","apb_tx_done",apb_tx_done)) begin
		`uvm_fatal(get_type_name(), "Did not get the APB EVENT")
		end
		else `uvm_info(get_type_name(), "Got the APB EVENT at interrupt", UVM_MEDIUM);      
    endfunction


     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
        	// When SPI Transfer Finishes The IRQ is asserted if IE bit is set to HIGH
			spi_tx_done.wait_trigger;
			analysis_port_INTRpredAP.write(intr_item);

			// When APB Transfer Finishes The IRQ is cleared
			apb_tx_done.wait_trigger();
			intr_item.IRQ = 0; // expected is low
			analysis_port_INTRpredAP.write(intr_item);
        end
    endtask
  

	virtual function void write_port_APBmntrAP (apb_sequence_item apb_item);
		// Receive IE Bit from APB Monitor during Control Register Write
		if(apb_item.pwrite == 1 && apb_item.write_addr == 5'h10) begin
			intr_item = apb_sequence_item::type_id::create("intr_item", this);
			ie_val = apb_item.write_data[12];
			intr_item.IRQ = ie_val; // expected value depends on IE
		end
	endfunction
	
endclass

