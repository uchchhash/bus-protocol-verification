class axi_sequencer extends uvm_sequencer #(axi_sequence_item);
	
	// -------------------------------- //
	// ----- Factory Registration ----- //
	// -------------------------------- // 	
	`uvm_component_utils(axi_sequencer)

	// ---------------------------------- //
	// ----- Methods of AXI Sequencer --- //
	// ---------------------------------- //
	//extern function new(string name = "axi_sequencer", uvm_component parent = null);	
  
	// -------------------------------- //
	// ----- Constructor Function ----- //
	// -------------------------------- //
	function new(string name = "axi_sequencer", uvm_component parent = null);
          super.new(name, parent);
          `uvm_info(get_type_name(), "***** AXI Sequencer Constructed *****", UVM_NONE);	
	endfunction 
  
  
endclass : axi_sequencer
