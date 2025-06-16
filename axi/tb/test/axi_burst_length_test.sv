
class axi_burst_length_test extends axi_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_burst_length_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // ----- Write Address Channel (AW) ----- //
  bit [AWID_WIDTH-1:0] awid    = 10;    
  bit [ADDR_WIDTH-1:0] awaddr  = 5000;  
  bit [3:0] 	       awlen   = 8;   
  bit [2:0] 	       awsize  = BYTE_4;  
  bit [1:0] 	       awburst = INCR;

  // ----- Read Address Channel (AW) ----- //
  bit [ARID_WIDTH-1:0] arid    = 10;   
  bit [ADDR_WIDTH-1:0] araddr  = 5000; 
  bit [3:0] 	       arlen   = 8;  
  bit [2:0] 	       arsize  = BYTE_4; 
  bit [1:0] 	       arburst = INCR;

 
  // ----- Additional Signals ----- //	
  bit [ADDR_WIDTH-1:0] start_addr  = 16;    
  int addr_count;	 // number of ADDR's per ID
  bit has_delay  = 0;    // assert handshake delay or not
  
  int length_count = 36; // Total Number of Length 
  int burst_count = 3;  // Total Number of Burst Type
  
  
  bit [3:0] wrap_length_array [3:0] = {1, 3, 7, 15};
  bit [2:0] burst_type_array  [2:0] = {FIXED, INCR, WRAP};

  // Randomize Signals
  bit rand_id = 1;
  bit rand_addr = 0;
  bit rand_len = 0;
  bit rand_size = 0;
  bit rand_burst = 0;

  // ------ Test Procedure ------- //
  // Burst-Type-Count   :: 3 (FIXED, INCR, WRAP)
  // Burst-Length-Count :: 36 (FIXED:0-15 || INCR: 0-15 || WRAP : 1,3,7,15) 
  // Address-Increment :: // assuming maximum size
  // if(first-transfer) addr = start_address
  // For Fixed :: (remaining-transfer) addr = previous_address + 4
  // For INCR/WRAP :: (remaining-transfer) addr = previous_addr + 4*length_count


  // -------------------------------------- //
  // ----- Methods of incr_burst Test ---- //
  // -------------------------------------- //
  extern function new(string name = "axi_burst_length_test", uvm_component parent = null);	
  extern task run_phase(uvm_phase phase);

endclass : axi_burst_length_test

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_burst_length_test::new(string name = "axi_burst_length_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Burst Length Test Constructed *****", UVM_NONE);	
endfunction

// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task axi_burst_length_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** AXI Burst Length Test : Run Phase Started  *****", UVM_MEDIUM);
  

  // For FIXED Burst :: Length = 0-15
  length_count = 16;
  // Write-Transfer
  for(int i = length_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum  transfer per ID
      begin
        awburst = FIXED;
        awlen = ii;
        awaddr = (ii==0)? awaddr : awaddr + 4;
        //`uvm_info(get_type_name(), $sformatf("WTest[%0d] :: [ID = %0d][ADDR = %0d][Len = %0d][Size = %0d][Burst = %0d] ", ii, awid, awaddr, awlen, awsize, awburst), UVM_MEDIUM)
        run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
  wait fork;
  
  // Read-Transfer
  for(int i = length_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum  transfer per ID
      begin
        //`uvm_info(get_type_name(), $sformatf("RTest[%0d] :: [ID = %0d][ADDR = %0d][Len = %0d][Size = %0d][Burst = %0d] ", ii, arid, araddr, arlen, arsize, arburst), UVM_MEDIUM)
        arburst = FIXED;
        arlen = ii;
        araddr = (ii==0)? araddr : araddr + 4;
        run_read_test_sequence(arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
   wait fork;
          
  
// //   #50ns;

  // For INCR Burst :: Length = 0-15
  length_count = 16;
  // Write-Transfer
  for(int i = length_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum  transfer per ID
      begin
        awburst = INCR;
        awlen = ii;
        awaddr = (ii==0)? awaddr : awaddr + (ii*4);
        `uvm_info(get_type_name(), $sformatf("WTest[%0d] :: [ID = %0d][ADDR = %0d][Len = %0d][Size = %0d][Burst = %0d] ", ii, awid, awaddr, awlen, awsize, awburst), UVM_MEDIUM)        
        run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
  wait fork;
  $display();

  // Read-Transfer
  for(int i = length_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum  transfer per ID
      begin
        arburst = INCR;
        arlen = ii;
        araddr = (ii==0)? araddr : araddr + (ii*4);
        `uvm_info(get_type_name(), $sformatf("RTest[%0d] :: [ID = %0d][ADDR = %0d][Len = %0d][Size = %0d][Burst = %0d] ", ii, arid, araddr, arlen, arsize, arburst), UVM_MEDIUM)        
        run_read_test_sequence(arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
  wait fork;  
  
   #50ns;

  // For WRAP Burst :: Length = 1,3,7,15
  length_count = 4;
  // Write-Transfer
  for(int i = length_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum  transfer per ID
      begin
        //`uvm_info(get_type_name(), $sformatf("WTest[%0d] :: [ID = %0d][ADDR = %0d][Len = %0d][Size = %0d][Burst = %0d] ", ii, awid, awaddr, awlen, awsize, awburst), UVM_MEDIUM)
        awburst = WRAP;
        awlen = wrap_length_array[ii];
        awaddr = (ii==0)? awaddr : awaddr + (wrap_length_array[ii]*4);
        run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end
  wait fork;
  $display();

  // Read-Transfer
  for(int i = length_count-1; i>=0; i--) begin
    fork
      automatic int ii = i; // Maximum  transfer per ID
      begin
        //`uvm_info(get_type_name(), $sformatf("RTest[%0d] :: [ID = %0d][ADDR = %0d][Len = %0d][Size = %0d][Burst = %0d] ", ii, arid, araddr, arlen, arsize, arburst), UVM_MEDIUM)
        arburst = WRAP;
        arlen = wrap_length_array[ii];
        araddr = (ii==0)? araddr : araddr + (wrap_length_array[ii]*4);
        run_read_test_sequence(arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
      end
    join_none
  end 
  wait fork;
  
//   #50ns;


  `uvm_info(get_type_name(), "***** AXI Burst Length Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);
endtask






