class axi_reset_test extends axi_base_test;

    // -------------------------------- //
    // ----- Factory Registration ----- //
    // -------------------------------- //
    `uvm_component_utils(axi_reset_test)

    // -------------------------------- //
    // -------- Data Members  --------- //
    // -------------------------------- //

    // -------------------------------- //
    // ----- Methods of Reset Test ---- //
    // -------------------------------- //
    extern function new(string name = "axi_reset_test", uvm_component parent = null);	
    extern task run_phase(uvm_phase phase);

endclass : axi_reset_test


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_reset_test::new(string name = "axi_reset_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "***** AXI Reset Test Constructed *****", UVM_NONE);	
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task axi_reset_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "***** AXI Reset Test : Run Phase Started  *****", UVM_MEDIUM);	
    run_reset_sequence();
    `uvm_info(get_type_name(), "***** AXI Reset Test : Run Phase Finished *****", UVM_MEDIUM);	
    phase.drop_objection(this);
endtask
  
