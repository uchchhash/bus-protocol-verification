
class spi_msb_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_msb_test)

    // Constructor  
    function new(string name = "spi_msb_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI MSB Test Constructed =====", UVM_LOW)
    endfunction


	bit lsb = `MSB // MSB first transfer

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI MSB Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		repeat(100)run_lsb_sequence(lsb);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI MSB Test Run Phase Finished =====", UVM_MEDIUM)
    endtask


  
endclass





