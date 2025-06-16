class ahb_incr8_byte_wr_test extends ahb_base_test;

    `uvm_component_utils(ahb_incr8_byte_wr_test)

    function new(string name="ahb_incr8_byte_wr_test", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "---- AHB incr8_byte_WRITE_READ Test Constructed ----", UVM_LOW);
    endfunction

    bit [31:0] start_address = 360; //0x0A
    bit bsy = 1'b0;
    bit rnd = 1'b1;

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "AHB incr8_byte_WRITE_READ Test 'Run Phase' Started", UVM_HIGH);
        ahb_incr8_byte_write(start_address, bsy, rnd);
        ahb_incr8_byte_read(start_address, bsy);
        phase.drop_objection(this);
    endtask


endclass
