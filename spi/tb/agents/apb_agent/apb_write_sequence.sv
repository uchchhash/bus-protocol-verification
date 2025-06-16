class apb_write_sequence extends apb_base_sequence;

    `uvm_object_utils(apb_write_sequence)

    function new(string name="apb_reset_sequence");
        super.new(name);
    //	`uvm_info(get_type_name(), "---- APB Write Sequence Constructed ----", UVM_LOW);
    endfunction


    task body();
        apb_sequence_item item;
        `uvm_info(get_type_name(), "==============  APB Write Sequence Body Task Called   ==============", UVM_LOW)
    //    `uvm_info (get_type_name(), $sformatf("[V_SEQ2APB_W_SEQ] Write_Address = %0h, Write_Data = %0h", write_address, write_data), UVM_LOW)
        `uvm_do_with(item, {item.pwrite  == 1;
                            item.write_addr == local::write_addr;
                            item.write_data == local::write_data;
                          })
                          
     //   `uvm_info (get_type_name(), $sformatf("[APB_W_SEQ2DRIVER] Write_Address = %0h, Write_Data = %0h,", item.write_address, item.write_data), UVM_LOW)
        `uvm_info(get_type_name(), "==============  APB Write Sequence Body Task Finished ==============", UVM_LOW)
    endtask

    
endclass

