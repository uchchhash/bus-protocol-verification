class spi_char_len_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_char_len_test)

    // Constructor  
    function new(string name = "spi_char_len_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Character Length Test Constructed =====", UVM_LOW)
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(),"===== SPI Character Length Test Run Phase Started =====", UVM_MEDIUM)
        
        repeat(10) begin
        for(int len_val = 0; len_val<127; len_val++) begin
			run_char_len_sequence(len_val);
        end 
        end
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Character Length Test Run Phase Finished =====", UVM_MEDIUM)
    endtask
  
  
endclass

