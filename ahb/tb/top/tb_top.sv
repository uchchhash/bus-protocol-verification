`include "uvm_macros.svh"
import uvm_pkg::*;
import ahb_test_pkg::*;

module tb_top;

	// Clock Generation
  	bit HCLK;
  	initial forever #5 HCLK = ~ HCLK;

    
	ahb_interface ahb_intf(HCLK); 	// Interface Instance

	// DUT connection
  
  	ahbslv DUT(.hclk(HCLK),
               .hsel_i(ahb_intf.HSEL),
               .hwrite_i(ahb_intf.HWRITE),
               .hresetn(ahb_intf.HRESETN),
               .htrans_i(ahb_intf.HTRANS),
               .hsize_i(ahb_intf.HSIZE),
               .hburst_i(ahb_intf.HBURST),
               .haddr_i(ahb_intf.HADDR),
               .hwdata_i(ahb_intf.HWDATA),
               .hready_o(ahb_intf.HREADY),
               .hresp_o(ahb_intf.HRESP),
               .hrdata_o(ahb_intf.HRDATA));  
	 
	initial begin
        uvm_config_db#(virtual ahb_interface)::set(null, "uvm_test_top.env.ahb_agnt", "ahb_interface", ahb_intf); 
        $display("@[%0t] [tb_top] >>>>>>>>>> Initiaing UVM Phases by calling 'run_test' <<<<<<<<<<", $time);
        run_test();

  //    run_test("ahb_reset_test");

  //     run_test("ahb_random_wr_test.sv");
      
   //   run_test("ahb_single_word_wr_test");
     
     // run_test("ahb_single_halfword_wr_test");
   //   run_test("ahb_single_byte_wr_test");
      
  //    run_test("ahb_incr_word_wr_test");
   //   run_test("ahb_incr_halfword_wr_test");
  //    run_test("ahb_incr_byte_wr_test");
      
  //    run_test("ahb_incr4_word_wr_test");
  //    run_test("ahb_incr4_halfword_wr_test");
  //    run_test("ahb_incr4_byte_wr_test");
      
      //    run_test("ahb_incr8_word_wr_test");
      //    run_test("ahb_incr8_halfword_wr_test");
      //    run_test("ahb_incr8_byte_wr_test");

      //    run_test("ahb_incr16_word_wr_test");
       //   run_test("ahb_incr16_halfword_wr_test");
      //    run_test("ahb_incr16_byte_wr_test");
      
  //    run_test("ahb_wrap4_word_wr_test");
  //    run_test("ahb_wrap4_halfword_wr_test");
  //    run_test("ahb_wrap4_byte_wr_test");
      
      //    run_test("ahb_wrap8_word_wr_test");
      //    run_test("ahb_wrap8_halfword_wr_test");
      //    run_test("ahb_wrap8_byte_wr_test");
      
       //   run_test("ahb_wrap16_word_wr_test");
      //    run_test("ahb_wrap16_halfword_wr_test");
       //   run_test("ahb_wrap16_byte_wr_test");
      
      
    //  $finish(); 

	end
  

   
endmodule
