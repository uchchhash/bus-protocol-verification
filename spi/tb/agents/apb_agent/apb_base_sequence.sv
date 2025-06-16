class apb_base_sequence extends uvm_sequence#(apb_sequence_item);

    // Factory Registration
    `uvm_object_utils(apb_base_sequence)

    // Constructor Function
    function new(string name="apb_base_sequence");
        super.new(name);
       // `uvm_info(get_type_name(), "---- APB Sequence Constructed ----", UVM_HIGH);
    endfunction

    rand bit [4:0]  write_addr;
    rand bit [4:0]  read_addr;
    rand bit [31:0] write_data;
    bit [31:0] read_data;


    task body();
        apb_sequence_item apb_item;
        `uvm_info(get_type_name(), "====  APB Base Sequence Body Task Called   ====", UVM_MEDIUM)
        `uvm_info(get_type_name(), "====  APB Base Sequence Body Task Finished ====", UVM_MEDIUM)
    endtask  

    

endclass

