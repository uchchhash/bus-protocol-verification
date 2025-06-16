`include "uvm_macros.svh"
import uvm_pkg::*;


module tb_top;

	// Clock Generation
  	bit clk;
  	initial forever #5 clk = ~clk;

   

  	apb_interface apb_intf(clk); // Interface Instance

	// DUT connection
    apb_slave DUT(.paddr(apb_intf.PADDR),
                .pwdata(apb_intf.PWDATA),
                .pwrite(apb_intf.PWRITE),
                .psel(apb_intf.PSEL),
                .penable(apb_intf.PENABLE),
                .pclk(clk),
                .rst_n(apb_intf.PRESETn),
                .prdata(apb_intf.PRDATA));
                
	
	initial begin
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top", "apb_interface", apb_intf); 
        run_test();
	end
  


endmodule
