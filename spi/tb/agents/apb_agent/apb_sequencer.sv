class apb_sequencer extends uvm_sequencer #(apb_sequence_item);
	
    `uvm_component_utils(apb_sequencer)

      function new(string name="apb_sequencer", uvm_component parent = null);
          super.new(name, parent);
          `uvm_info(get_type_name(), "---- APB Sequencer Constructed ----", UVM_LOW);
      endfunction

  
endclass
