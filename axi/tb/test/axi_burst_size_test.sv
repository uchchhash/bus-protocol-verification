

class axi_burst_size_test extends axi_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_burst_size_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // ----- Write Address Channel (AW) ----- //
  bit [AWID_WIDTH-1:0] awid    = 10;    
  bit [ADDR_WIDTH-1:0] awaddr  = 0;
  bit [3:0] 	       awlen   = 0; 
  bit [2:0] 	       awsize  = BYTE_2;  
  bit [1:0] 	       awburst = WRAP;

  // ----- Read Address Channel (AW) ----- //
  bit [ARID_WIDTH-1:0] arid    = 10;   
  bit [ADDR_WIDTH-1:0] araddr  = 0;
  bit [3:0] 	       arlen   = 0;  
  bit [2:0] 	       arsize  = BYTE_2; 
  bit [1:0] 	       arburst = WRAP;

  // ----- Test Specific Signals ----- //	



  bit has_delay  = 0;       // assert handshake delay or not

  // Randomize Signals
  bit rand_id = 1;
  bit rand_addr = 0;
  bit rand_len = 1;
  bit rand_size = 0;
  bit rand_burst = 1;
  bit rand_wstrb = 1;
  bit rand_data = 1;
  

	// ----- Test Procedure ------ //
  int transfer_count = 1;  // Number of transfers in the test
	int address_count = 2;   // Number of address-transfer per burst size
  int size_count = 3;      // Number of Burst Size Variants  
  bit [2:0] size_arr [0:2] = {BYTE_1, BYTE_2, BYTE_4}; // Burst Size Variants
  
	// transfer-loop
	// awaddr = start_addr 
	// 


  // -------------------------------------- //
  // ----- Methods of incr_burst Test ---- //
  // -------------------------------------- //
  extern function new(string name = "axi_burst_size_test", uvm_component parent = null);	
  extern task run_phase(uvm_phase phase);

endclass : axi_burst_size_test

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_burst_size_test::new(string name = "axi_burst_size_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Burst Size Test Constructed *****", UVM_NONE);	
endfunction

// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //


task axi_burst_size_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** AXI Burst Size Test : Run Phase Started  *****", UVM_MEDIUM);


	for (int i = transfer_count - 1; i >= 0; i--) begin
		for (int j = size_count - 1; j >= 0; j--) begin
			for (int k = address_count - 1; k >= 0; k--) begin
				fork
					automatic int ii = i;
					automatic int jj = j;
					automatic int kk = k;
					begin
						awsize = size_arr[jj];
						// Calculate the awaddr
						if (ii== 0 && jj == 0 && kk == 0) begin
							awaddr = awaddr;
						end
						else begin
							if(awsize !=WORD) awaddr = awaddr + 16*(awsize+1);
							else if (awsize == WORD) awaddr = awaddr + 16*(awsize+2);
						end
						//`uvm_info(get_type_name(), $sformatf("[===write====AxSIZE-Test][#t = %0d][#s = %0d][#a= %0d]  [size = %0d] [addr = %0d]", ii, jj, kk, awsize, awaddr), UVM_MEDIUM)
						run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
					end
				join_none
			end
		end
	end
	wait fork;


	for (int i = transfer_count - 1; i >= 0; i--) begin
		for (int j = size_count - 1; j >= 0; j--) begin
			for (int k = address_count - 1; k >= 0; k--) begin
				fork
					automatic int ii = i;
					automatic int jj = j;
					automatic int kk = k;
					begin
						arsize = size_arr[jj];
						// Calculate the araddr
						if (ii== 0 && jj == 0 && kk == 0) begin
							araddr = araddr;
						end
						else begin
							if(arsize !=WORD) araddr = araddr + 16*(arsize+1);
							else if (arsize == WORD) araddr = araddr + 16*(arsize+2);
						end
						//`uvm_info(get_type_name(), $sformatf("[====read====AxSIZE-Test][#t = %0d][#s = %0d][#a= %0d]  [size = %0d] [addr = %0d]", ii, jj, kk, arsize, araddr), UVM_MEDIUM)
						run_read_test_sequence(arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
					end
				join_none
			end
		end
	end
	wait fork;

  `uvm_info(get_type_name(), "***** AXI Burst Size Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);
endtask



