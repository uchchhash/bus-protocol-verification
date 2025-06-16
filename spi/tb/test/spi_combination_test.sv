class spi_combination_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_combination_test)

    // Constructor  
    function new(string name = "spi_combination_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI combination Test Constructed =====", UVM_LOW)
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
	
	// Divider Array Creation
	parameter div_range = 4369;
	bit [31:0] div_range_start [15];
	bit [31:0] div_range_end [15];
	bit [31:0] div_array [15];

	// Character Length Array Creation
	parameter len_range = 16; 
	bit [31:0] len_range_start [10];
	bit [31:0] len_range_end [10];
	bit [31:0] len_array [10];

	
    // ---------- Run Phase ----------l//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Combination Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
 
		// Divide the DIVIDER [0:65535] value into 15 ranges
		for (int i = 0; i < 15; i++) begin
			div_range_start[i] = i*div_range;
			div_range_end[i] = ((i + 1)*div_range) - 1;
			div_array[i] = $urandom_range(div_range_start[i], div_range_end[i]);
			//`uvm_info(get_type_name(), $sformatf("start[%0d]  = %0d || end[%0d] = %0d || div[%0d] = %0d", i, div_range_start[i], i, div_range_end[i], i, div_array[i]), UVM_MEDIUM);				
		end	 

		// Divide the CHAR_LEN [0:127] value into 8 ranges
		for (int i = 0; i<8; i++) begin
			len_range_start[i] = i*len_range;
			len_range_end[i] = ((i+1)*len_range)-1;
			len_array[i] = $urandom_range(len_range_start[i], len_range_end[i]);
			//`uvm_info(get_type_name(), $sformatf("start[%0d]  = %0d || end[%0d] = %0d || len[%0d] = %0d", i, len_range_start[i], i, len_range_end[i], i, len_array[i]), UVM_MEDIUM);				
		end
		 
		for(int i = 0; i <= 0; i ++) begin
			slvsel = slvsel_array[i];  // Select Slave
			for(int div_index = 0; div_index <= 0; div_index ++) begin
				divider = 1;//div_array[div_index];  // select divider
				for(int len_index=0; len_index <=0; len_index++) begin
					char_len = 0;//len_array[len_index]; // select char_len    						
					for(int mode_val = 0; mode_val <=1; mode_val++) begin	
						mode = mode_val;   // select mode	    			
						for(int lsb_val = 0; lsb_val <= 1; lsb_val++) begin
							lsb = lsb_val; // select lsb/msb				
							for(int ie_val = 0; ie_val <= 1; ie_val++) begin
								ie = ie_val; // Select IE enable/disable			
								for(int ass_val=0; ass_val<=1; ass_val++) begin
									ass = ass_val;  // auto/manual chip-select 		
									run_comb_sequence(divider, slvsel, char_len, mode, lsb, ass, ie);
									#500ns;
									repeat(2)$display();
								end
							end
						end
					end
				end
			end
		end	 
       
        phase.drop_objection(this);
        `uvm_info(get_type_name(),"===== SPI Combination Test Run Phase Finished =====", UVM_MEDIUM)
    endtask

  
endclass



