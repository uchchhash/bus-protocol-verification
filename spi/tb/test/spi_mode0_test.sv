
class spi_mode0_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_mode0_test)

    // Constructor  
    function new(string name = "spi_mode0_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI MODE-0 Test Constructed =====", UVM_LOW)
    endfunction


	bit [1:0] mode = MODE00; // MODE-0

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI MODE-0 Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		repeat(100) begin
			run_modes_sequence(mode);
			#5000ns;
		end
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI MODE-0 Test Run Phase Finished =====", UVM_MEDIUM)
    endtask

  
endclass
