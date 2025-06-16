class spi_cov_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_cov_test)

    // Constructor  
    function new(string name = "spi_cov_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Coverage Test Constructed =====", UVM_LOW)
    endfunction

	// Configurable variables
	bit ie = 1'b0; 						
	bit ass = 1'b0; 						
	bit lsb = 1'b0; 						
	bit [1:0] mode = 2'b01; 				
	bit [15:0] divider = 16'h00;
	bit [7:0] slvsel = 8'h01;
	bit [6:0] char_len = 0;

    bit [7:0] slvsel_array[0:7] = '{8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80};




    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Coverage Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);

        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Coverage Test Run Phase Finished =====", UVM_MEDIUM)       
    endtask
  
endclass




		RXTX2_MODE0_cross : cross RXTX2_cov, DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, RX_NEG, TX_NEG, LSB, IE, ASS {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																													    ignore_bins TXn_ignore = binsof(TX_NEG.TXn_LOW);}
		
		RXTX2_MODE1_cross : cross RXTX2_cov, DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, RX_NEG, TX_NEG, LSB, IE, ASS {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_LOW);
																													    ignore_bins TXn_ignore = binsof(TX_NEG.TXn_HIGH);}
