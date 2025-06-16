
class spi_lsb_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_lsb_test)

    // Constructor  
    function new(string name = "spi_lsb_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI LSB Test Constructed =====", UVM_LOW)
    endfunction


	bit lsb = `LSB // LSB first transfer

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI LSB Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		repeat(100)run_lsb_sequence(lsb);
        phase.drop_objection(this);
        #100ns;
        `uvm_info(get_type_name(),"===== SPI LSB Test Run Phase Finished =====", UVM_MEDIUM)
    endtask


  
endclass
