class spi_slvsel_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_slvsel_test)

    // Constructor  
    function new(string name = "spi_slvsel_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Slave-Select Test Constructed =====", UVM_LOW)
    endfunction


	bit [7:0] slvsel_array[0:7] = '{8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80};
    
    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Slave-Select Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
      	repeat(10) begin
      	for(int i = 0; i <= 7 ; i ++) begin
			run_slvsel_sequence(slvsel_array[i]);
      	end
      	end
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Slave-Select Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
endclass

