class spi_low_frequency_test extends apb_spi_base_test;

    // Factory Registration
    `uvm_component_utils(spi_low_frequency_test)

    // Constructor  
    function new(string name = "spi_low_frequency_test", uvm_component parent =null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Low Frequency Test Constructed =====", UVM_LOW)
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

	// Divide the Divider array into two parts 
	// High Frequency Range : [0-1000] ---> divide the range into 10 ranges 
	// Low Frequency Range : [1001-65535] ---> divide the range into 5 ranges


	// Divider Array Creation
	parameter div_RANGE = 12907;
	bit [31:0] div_range_start [5];
	bit [31:0] div_range_end [5];
	bit [31:0] div_array[5];

	// Character Length Array Creation
	parameter len_RANGE = 32; 
	bit [31:0] len_range_start [4];
	bit [31:0] len_range_end [4];
	bit [31:0] len_array [4];


    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"===== SPI Low Frequency Test Run Phase Started =====", UVM_MEDIUM)
        phase.raise_objection(this);
		// Divide the DIVIDER [1001:65535] value into 5 ranges
		for (int i = 0; i < 5; i++) begin
			div_range_start[i] = i*div_RANGE;
			div_range_end[i] = ((i + 1)*div_RANGE) - 1;
			div_range_start[i] = div_range_start[i] + 1000;
			div_range_end[i] = div_range_end[i] + 1000;
			div_array[i] = $urandom_range(div_range_start[i], div_range_end[i]);
			`uvm_info(get_type_name(), $sformatf("start[%0d]  = %0d || end[%0d] = %0d || div[%0d] = %0d", i, div_range_start[i], i, div_range_end[i], i, div_array[i]), UVM_MEDIUM);			
		end
		
		// Divide the CHAR_LEN [0:127] value into 4 ranges
		for (int i = 0; i<4; i++) begin
			len_range_start[i] = i*len_RANGE;
			len_range_end[i] = ((i+1)*len_RANGE)-1;
			len_array[i] = $urandom_range(len_range_start[i], len_range_end[i]);
			//`uvm_info(get_type_name(), $sformatf("start[%0d]= %0d || end[%0d] = %0d || len[%0d] = %0d", i, len_range_start[i], i,len_range_end[i], i, len_array[i]), UVM_MEDIUM);				
		end
		
		for(int i = 0; i <= 7; i ++) begin
			slvsel = slvsel_array[i];  // Select Slave
			for(int div_index = 0; div_index <= 4; div_index ++) begin
				divider = div_array[div_index];  // select divider
				for(int len_index=0; len_index <=3; len_index++) begin
					char_len = len_array[len_index]; // select char_len    						
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
        `uvm_info(get_type_name(),"===== SPI Low Frequency Test Run Phase Finished =====", UVM_MEDIUM)       
    endtask

endclass



