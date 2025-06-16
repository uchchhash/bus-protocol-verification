class axi_wstrb_test extends axi_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_wstrb_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // ----- Write Address Channel (AW) ----- //
  bit [AWID_WIDTH-1:0] awid    = 10;    
  bit [ADDR_WIDTH-1:0] awaddr  = 4;  
  bit [3:0] 	       awlen   = 3;   
  bit [2:0] 	       awsize  = BYTE_2;  
  bit [1:0] 	       awburst = INCR;
  // ----- Write Data Channel (W) ----- //	
  bit [WID_WIDTH-1:0]  wid      = 10;
  bit [STRB_WIDTH-1:0] wstrb   = 4'b0000;
  bit [DATA_WIDTH-1:0] wdata   = 32'h12345678;
  // ----- Read Address Channel (AW) ----- //
  bit [ARID_WIDTH-1:0] arid    = 10;   
  bit [ADDR_WIDTH-1:0] araddr  = 4; 
  bit [3:0] 	       arlen   = 3;  
  bit [2:0] 	       arsize  = BYTE_2; 
  bit [1:0] 	       arburst = INCR;

  // ----- Test Specific Signals ----- //	
  int strb_count = 16;      // Total STRB Variants (4'b0000 to 4'b1111)
  int transfer_count = 1;   // Number of Transfer per STRB value
  bit has_delay  = 0;       // assert handshake delay or not

 
  // Randomize Signals
  bit rand_id = 1;
  bit rand_addr = 0;
  bit rand_len = 0;
  bit rand_size = 1;
  bit rand_burst = 1;
  bit rand_wstrb = 0;
  bit rand_data = 1;

  
  // --------------------------------------- //
  // ----- Methods of Write Strobe Test ---- //
  // --------------------------------------- //
  extern function new(string name = "axi_wstrb_test", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);  
  extern task run_phase(uvm_phase phase);

endclass : axi_wstrb_test

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_wstrb_test::new(string name = "axi_wstrb_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI WSTRB Test Constructed *****", UVM_NONE);	
endfunction


// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void axi_wstrb_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  set_type_override_by_type(axi_driver::get_type(), axi_driver2::get_type());
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task axi_wstrb_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  //`uvm_info(get_type_name(), "***** AXI WSTRB Test : Run Phase Started  *****", UVM_MEDIUM); 



  // Write Transfer
  for (int i = strb_count-1; i>=0; i--) begin
    for (int j = transfer_count-1; j>=0; j--) begin
      automatic int ii = i;
      automatic int jj = j;
      fork : addr_fork
        begin : addr_block
          awaddr = awaddr + 4*(ii+2);
          run_write_test_sequence(awid, awaddr, awlen, awsize, awburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
        end : addr_block
        begin : data_block
          for (int k = awlen; k >= 0; k--) begin
            automatic int kk = k;
            fork : data_fork
              begin : data_task
                wstrb = ii;
                run_write_data_test_sequence(wdata, wstrb, rand_data, rand_wstrb, has_delay);
              end : data_task
            join_none : data_fork
          end
        end : data_block
    join_none : addr_fork
    end
  end
  wait fork;

  repeat(2)$display();

  // Read Transfer
  for(int i = strb_count-1; i>=0; i--) begin
    for(int j = (transfer_count-1); j>=0; j--) begin
      fork
        automatic int ii = i;
        automatic int jj = j;
        begin
          araddr = araddr + 4*(ii+2);
          run_read_test_sequence(arid, araddr, arlen, arsize, arburst, rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay);
        end
      join_none
    end
  end
  wait fork;

//  `uvm_info(get_type_name(), "***** AXI WSTRB Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);	
endtask

