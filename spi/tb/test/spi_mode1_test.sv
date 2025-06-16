
class spi_mode1_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_mode1_test)

    // Constructor  
    function new(string name = "spi_mode1_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI MODE-1 Test Constructed =====", UVM_LOW)
    endfunction


	bit [1:0] mode = MODE01; // MODE-1

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI MODE-1 Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		repeat(100)run_modes_sequence(mode);
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI MODE-1 Test Run Phase Finished =====", UVM_MEDIUM)
    endtask


  
endclass
