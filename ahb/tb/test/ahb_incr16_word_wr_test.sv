class ahb_incr16_word_wr_test extends ahb_base_test;

    `uvm_component_utils(ahb_incr16_word_wr_test)

    function new(string name="ahb_incr16_word_wr_test", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "---- AHB incr16_word_WRITE_READ Test Constructed ----", UVM_LOW);
    endfunction

    bit [31:0] start_address = 380; //0x64
    bit rnd = 1'b1;
    bit bsy = 1'b0;


    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "AHB incr16_word_WRITE_READ Test 'Run Phase' Started", UVM_HIGH);
        ahb_incr16_word_write(start_address ,bsy, rnd);
        ahb_incr16_word_read(start_address ,bsy);
        phase.drop_objection(this);
    endtask



/*

    bit [31:0] start_address0 = 100; 
    bit [31:0] start_address1 = 200;
    bit [31:0] start_address2 = 400; 

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "AHB incr16_word_WRITE_READ Test 'Run Phase' Started", UVM_HIGH);
        ahb_incr16_word_write(start_address0 ,bsy, rnd);
        ahb_wrap16_word_write(start_address1 ,bsy, rnd);
        ahb_incr_word_write(start_address2 ,bsy, rnd);

        ahb_wrap16_word_read(start_address1 ,bsy);
        ahb_incr16_word_read(start_address0 ,bsy);
        ahb_incr_word_read(start_address2 ,bsy);
        phase.drop_objection(this);
    endtask

*/


endclass
