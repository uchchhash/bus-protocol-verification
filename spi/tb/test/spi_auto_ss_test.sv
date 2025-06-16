class spi_auto_ss_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_auto_ss_test)

    // Constructor  
    function new(string name = "spi_auto_ss_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Auto/Manual Slave-Select Test Constructed =====", UVM_LOW)
    endfunction


    bit ass;

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Auto/Manual Slave-Select Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
        repeat(10) begin
        for(int i = 0; i<=1; i++) begin
            ass = ~i;
			run_auto_ss_sequence(ass);
        end
        end
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Auto/Manual Slave-Select Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
endclass

