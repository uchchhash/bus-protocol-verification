`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;

	// Clock Generation
  	bit HCLK;
  	initial forever #5 HCLK = ~ HCLK;

    
	ahb_interface ahb_intf(HCLK); // Interface Instance

	// DUT connection
  
  	ahbslv DUT(.hclk(ahb_intf.HCLK),
               .hsel_i(ahb_intf.HSELx),
               .hwrite_i(ahb_intf.HWRITE),
               .hresetn(ahb_intf.HRESETn),
               .htrans_i(ahb_intf.HTRANS),
               .hsize_i(ahb_intf.HSIZE),
               .hburst_i(ahb_intf.HBURST),
               .haddr_i(ahb_intf.HADDR),
  			   .hwdata_i(ahb_intf.HWDATA),
  			   .hready_o(ahb_intf.HREADY),
  			   .hresp_o(ahb_intf.HRESP),
               .hrdata_o(ahb_intf.HRDATA));  
	
	initial begin
    	uvm_config_db#(virtual ahb_interface)::set(null, "uvm_test_top", "ahb_interface", ahb_intf); 
    	run_test();
    //  run_test("reset_test");
    //	run_test("single_write_read_test");
  	//	run_test("incr_write_read_test");
	//	run_test("wrap_write_read_test");
	end
  
  	initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars;
    end
   
endmodule
