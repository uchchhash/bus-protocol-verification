


class axi_wrap_write_fixed_read_test extends axi_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_wrap_write_fixed_read_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // ----- Write Address Channel (AW) ----- //
  bit [AWID_WIDTH-1:0] awid    = 10;    
  bit [ADDR_WIDTH-1:0] awaddr  = 4;
  bit [3:0] 	       awlen   = 0; 
  bit [2:0] 	       awsize  = BYTE_2;  
  bit [1:0] 	       awburst = WRAP;

  // ----- Read Address Channel (AW) ----- //
  bit [ARID_WIDTH-1:0] arid    = 10;   
  bit [ADDR_WIDTH-1:0] araddr  = 4;
  bit [3:0] 	       arlen   = 0;  
  bit [2:0] 	       arsize  = BYTE_2; 
  bit [1:0] 	       arburst = FIXED;

  // ----- Additional Signals ----- //	
  int id_count   = 1;	 // number of ID's to be written
  int addr_count = 3;	 // number of ADDR's per ID
  bit has_delay  = 0;    // assert handshake delay or not
  bit [ADDR_WIDTH-1:0] start_addr; // Hold the starting address
  
  // Randomize Signals
  bit rand_id = 1;
  bit rand_addr = 0;
  bit rand_len = 1;
  bit rand_size = 1;
  bit rand_burst = 0;
  bit rand_wstrb = 0;
  bit rand_data = 1;

  // ----------------------------------------------- //
  // ----- Methods of wrap_write_incr_read Test ---- //
  // ----------------------------------------------- //
  extern function new(string name = "axi_wrap_write_fixed_read_test", uvm_component parent = null);	
  extern task run_phase(uvm_phase phase);

endclass : axi_wrap_write_fixed_read_test

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_wrap_write_fixed_read_test::new(string name = "axi_wrap_write_fixed_read_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI WRAP-Write FIXED-Read Test Constructed *****", UVM_NONE);	
endfunction

// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task axi_wrap_write_fixed_read_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** AXI WRAP-Write FIXED-Read Test: Run Phase Started  *****", UVM_MEDIUM);

  // Write Transfer 
  for(int i = addr_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum transfer per ID
      begin          
        run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
  wait fork;

  // Read Transfer
  for(int i = addr_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum transfer per ID
      begin
        run_read_test_sequence(arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
  wait fork;

  #100ns;


`uvm_info(get_type_name(), "***** AXI WRAP Write - Fixed Read Test  : Run Phase Finished  *****", UVM_MEDIUM);
  phase.drop_objection(this);
endtask



