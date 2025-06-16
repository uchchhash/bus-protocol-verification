class ahb_reset_test extends ahb_base_test;
  
    `uvm_component_utils(ahb_reset_test)
      
    function new(string name = "ahb_reset_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"==== AHB 'Reset Test' Constructed ====", UVM_MEDIUM)
    endfunction


    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name, "AHB Reset Test 'Run Phase' Started", UVM_MEDIUM)
        ahb_reset();
        phase.drop_objection(this);
    endtask
  
endclass
