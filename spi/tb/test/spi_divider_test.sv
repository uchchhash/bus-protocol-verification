class spi_divider_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_divider_test)

    // Constructor  
    function new(string name = "spi_divider_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Clock Divider Test Constructed =====", UVM_LOW)
    endfunction


	bit [15:0] div_array[0:17] = '{16'h00, 16'h01, 16'h02, 16'h04, 16'h08, 16'h10, 16'h20, 16'h40, 16'h80, 16'h100, 16'h200, 16'h400, 16'h800, 16'h1000, 16'h2000, 16'h4000, 16'h8000, 16'hFFFF};


    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Clock Divider Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);   	
    	
    	for(int i=0; i<=5; i++) begin
      		run_divider_sequence(div_array[i]);
      	end
      	
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Clock Divider Test Run Phase Finished =====", UVM_MEDIUM)       
    endtask

endclass



