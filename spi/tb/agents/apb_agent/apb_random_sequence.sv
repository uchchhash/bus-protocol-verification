class apb_random_sequence extends apb_base_sequence;

    // Factory Registration
    `uvm_object_utils(apb_random_sequence)

    // Constructor Function
    function new(string name="apb_random_sequence");
        super.new(name);
        `uvm_info(get_type_name(), "---- APB Sequence Constructed ----", UVM_HIGH);
    endfunction

    

    task body();
        apb_sequence_item apb_item;
        `uvm_info(get_type_name(), "====  APB Random Sequence Body Task Called   ====", UVM_MEDIUM)
        `uvm_info(get_type_name(), "====  APB Random Sequence Body Task Finished ====", UVM_MEDIUM)
    endtask  

    

endclass

