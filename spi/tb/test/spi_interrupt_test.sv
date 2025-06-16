class spi_interrupt_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_interrupt_test)

    // Constructor  
    function new(string name = "spi_interrupt_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Interrupt Test Constructed =====", UVM_LOW)
    endfunction

    bit ie; // Interrupt Enable or Disable

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Interrupt Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);

		repeat(10)begin
	    for(int i = 0; i<=1; i++) begin
	    	ie = i;
			run_interrupt_sequence(ie);
	    end 
	    end
		phase.drop_objection(this);
		`uvm_info(get_type_name(),"===== SPI Interrupt Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
endclass

