class spi_random_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_random_test)

    // Constructor  
    function new(string name = "spi_random_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Random Test Constructed =====", UVM_LOW)
    endfunction


    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Random Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
	    repeat(1000) begin
	    	run_rand_sequence;
	    	#5000ns;
	    end
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Random Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
endclass

