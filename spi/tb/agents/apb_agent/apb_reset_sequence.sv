class apb_reset_sequence extends apb_base_sequence;

    `uvm_object_utils(apb_reset_sequence)

    function new(string name="apb_reset_sequence");
        super.new(name);
    //	`uvm_info(get_type_name(), "---- APB Reset Sequence Constructed ----", UVM_LOW);
    endfunction

    task body();
       	apb_sequence_item item;
		//`uvm_info(get_type_name(), "==============  APB Reset Sequence Body Task Called  ==============", UVM_LOW)
      	`uvm_do_with(item, {item.has_reset  == 1;})
      	//`uvm_info(get_type_name(), "==============  APB Reset Sequence Body Task Finished ==============", UVM_LOW)
    endtask

    
endclass
