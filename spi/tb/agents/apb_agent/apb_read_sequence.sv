
class apb_read_sequence extends apb_base_sequence;

    `uvm_object_utils(apb_read_sequence)

    function new(string name="apb_reset_sequence");
        super.new(name);
    //	`uvm_info(get_type_name(), "---- APB Read Sequence Constructed ----", UVM_LOW);
    endfunction



    task body();
        apb_sequence_item item;
        `uvm_info(get_type_name(), "==============  APB Read Sequence Body Task Called  ==============", UVM_MEDIUM)
        `uvm_do_with(item, {item.pwrite  == 0;
                            item.read_addr == local::read_addr;
                          })
        `uvm_info(get_type_name(), "==============  APB Read Sequence Body Task Finished ==============", UVM_MEDIUM)
    endtask

    
endclass

