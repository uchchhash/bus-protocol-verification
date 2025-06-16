
class axi_combination_test extends axi_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_combination_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // ----- Write Address Channel (AW) ----- //
  bit [AWID_WIDTH-1:0] awid    = 10;    
  bit [ADDR_WIDTH-1:0] awaddr  = 33;  
  bit [3:0] 	       awlen   = 3;   
  bit [2:0] 	       awsize  = BYTE_2;  
  bit [1:0] 	       awburst = INCR;
  // ----- Write Data Channel (W) ----- //	
  bit [WID_WIDTH-1:0]  wid     = 10;
  bit [STRB_WIDTH-1:0] wstrb   = 4'b1111;
  bit [DATA_WIDTH-1:0] wdata   = 32'h12345678;
  // ----- Read Address Channel (AW) ----- //
  bit [ARID_WIDTH-1:0] arid    = 10;   
  bit [ADDR_WIDTH-1:0] araddr  = 33;  
  bit [3:0] 	       arlen   = 3;  
  bit [2:0] 	       arsize  = BYTE_2; 
  bit [1:0] 	       arburst = INCR;

  // ----- Additional Signals ----- //	
  bit has_delay  = 0;    // assert handshake delay or not
   
  // Randomize Signals
  bit rand_id = 0;
  bit rand_addr = 0;
  bit rand_len = 0;
  bit rand_size = 0;
  bit rand_burst = 0;
  bit rand_wstrb = 0;
  bit rand_data = 1;

  // -------------------------------------- //
  // ----- Methods of combination Test ---- //
  // -------------------------------------- //
  extern function new(string name = "axi_combination_test", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : axi_combination_test


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_combination_test::new(string name = "axi_combination_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Combination Test Constructed *****", UVM_NONE);	
endfunction

// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void axi_combination_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  set_type_override_by_type(axi_driver::get_type(), axi_driver2::get_type());
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //


task axi_combination_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** AXI Combination Test : Run Phase Started  *****", UVM_MEDIUM);

  fork : write_channel_fork
    begin : aw_block // Initiate AW-Channel Sequence
      run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
    end : aw_block
    begin : w_block // Initiate W-Channel Sequence (AWLEN+1 times)
      for (int i = awlen; i >= 0; i--) begin 
        automatic int ii = i;
          fork : w_fork // Fork the W-Channel Sequences
            begin
              run_write_data_test_sequence(wdata, wstrb, rand_data, rand_wstrb, has_delay);
            end
          join_none : w_fork
      end
    end : w_block
  join_none
  wait fork;



  // Read Transfer
  run_read_test_sequence (arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);


  `uvm_info(get_type_name(), "***** AXI Combination Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);
endtask
  





  




