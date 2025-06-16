class spi_reg_access_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_reg_access_test)

    // Constructor  
    function new(string name = "spi_reg_access_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Register Access Test Constructed =====", UVM_LOW)
    endfunction


    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Register Access Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		repeat(10) run_reg_access_sequence;
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Register Access Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
endclass

