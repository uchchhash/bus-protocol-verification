class ahb_random_wr_test extends ahb_base_test;

    `uvm_component_utils(ahb_random_wr_test)

    function new(string name="ahb_random_wr_test", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "---- AHB RANDOM_WRITE_READ Test Constructed ----", UVM_LOW);
    endfunction

    int total_rtest = 50;
    bit rnd_test = 1'b1;
    bit bsy = 1'b0;
    bit rnd = 1'b1;

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "AHB Random_WRITE_READ Test 'Run Phase' Started", UVM_HIGH);
        ahb_random_wr(bsy, rnd, rnd_test, total_rtest);
        phase.drop_objection(this);
    endtask


endclass
