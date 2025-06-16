
`timescale 1ns/1ps

package axi_test_pkg;
	
        
  //----- Include UVM Macros -----//
  `include "uvm_macros.svh"
	
  //----- Import Packages ------//
  import uvm_pkg::*;
  import env_pkg::*;
  import axi_agnt_pkg::*;
    
  //----- Include Test Package classes -----//
  `include "axi_base_test.sv"
  `include "axi_reset_test.sv"
  `include "axi_combination_test.sv"
  `include "axi_unaligned_wr_test.sv"

  `include "axi_wstrb_test.sv"
  `include "axi_burst_length_test.sv"
  `include "axi_burst_size_test.sv"
 
  `include "axi_fixed_burst_test.sv"
  `include "axi_fixed_write_incr_read_test.sv"
  `include "axi_fixed_write_wrap_read_test.sv"
  
  `include "axi_incr_burst_test.sv"
  `include "axi_incr_write_wrap_read_test.sv"
  `include "axi_incr_write_fixed_read_test.sv"

  
  `include "axi_wrap_burst_test.sv"
  `include "axi_wrap_write_incr_read_test.sv"
  `include "axi_wrap_write_fixed_read_test.sv"

  `include "axi_error_response_test.sv"
	`include "axi_concurrent_wr_test.sv"

endpackage
