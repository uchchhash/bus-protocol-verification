package ahb_test_pkg;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import env_pkg::*;
    import ahb_agnt_pkg::*;
      
    `include "ahb_base_test.sv"

    `include "ahb_random_wr_test.sv"
    //  `include "ahb_reset_test.sv"

    `include "ahb_single_word_wr_test.sv"
    `include "ahb_single_halfword_wr_test.sv"
    `include "ahb_single_byte_wr_test.sv"


  //  `include "ahb_incr_word_wr_test.sv"
  //  `include "ahb_incr_halfword_wr_test.sv"
  //  `include "ahb_incr_byte_wr_test.sv"

  //  `include "ahb_incr4_word_wr_test.sv"
    `include "ahb_incr4_halfword_wr_test.sv"
  //  `include "ahb_incr4_byte_wr_test.sv"

  //  `include "ahb_incr8_word_wr_test.sv"
  //  `include "ahb_incr8_halfword_wr_test.sv"
  //  `include "ahb_incr8_byte_wr_test.sv"

 //   `include "ahb_incr16_word_wr_test.sv"
  //  `include "ahb_incr16_halfword_wr_test.sv"
  //  `include "ahb_incr16_byte_wr_test.sv"

  //  `include "ahb_wrap4_word_wr_test.sv"
  //  `include "ahb_wrap4_halfword_wr_test.sv"
   // `include "ahb_wrap4_byte_wr_test.sv"


  //  `include "ahb_wrap8_word_wr_test.sv"
  //  `include "ahb_wrap8_halfword_wr_test.sv"
  //  `include "ahb_wrap8_byte_wr_test.sv"

 //   `include "ahb_wrap16_word_wr_test.sv"
  //  `include "ahb_wrap16_halfword_wr_test.sv"
 //   `include "ahb_wrap16_byte_wr_test.sv"

  


endpackage
