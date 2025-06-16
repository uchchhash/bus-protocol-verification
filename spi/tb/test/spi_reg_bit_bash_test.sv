class spi_reg_bit_bash_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_reg_bit_bash_test)

    // Constructor  
    function new(string name = "spi_reg_bit_bash_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Register Bit Bash Test Constructed =====", UVM_LOW)
    endfunction


    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Register Bit Bash Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		repeat(10) run_reg_bit_bash_sequence;
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Register Bit Bash Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
endclass
