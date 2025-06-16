`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_spi_test_pkg::*;

module tb_top;

    // Clock Generation
	bit PCLK;
	initial forever #(1e9 / (2 * PCLK_FREQ)) PCLK = ~PCLK;

    // Take the interface instances and send the clock
    apb_interface apb_intf(PCLK);     		// APB interface
    interrupt_interface intr_intf(PCLK);  	// Interrupt Interface
    spi_interface spi_vif[7:0]();     		// Take interface array for SPI slaves
    
    // Variables declaration for ss_pad_o, sclk_pad_o, mosi_pad_o, miso_pad_i signals
    wire [7:0] ss_pad_o_signal; // output
    wire sclk_pad_o_signal; // output
    wire mosi_pad_o_signal; // output
    logic miso_pad_i_signal; // input
    
    //---- Connect Outputs -------//
    // genvar is used as an integer during elaboration and create instances of the generate block
    // generate-endgenerate keyward is optional
	generate
	for (genvar i = 0; i < 8; i++) begin
		assign spi_vif[i].SLVSEL = ss_pad_o_signal[i];
		assign spi_vif[i].SCLK   = sclk_pad_o_signal;
		assign spi_vif[i].MOSI   = mosi_pad_o_signal;
	end	
	endgenerate
	
	//---- Connect Inputs ------//
	always_comb begin
		case(ss_pad_o_signal) 
			8'b11111110 : miso_pad_i_signal = spi_vif[0].MISO;
			8'b11111101 : miso_pad_i_signal = spi_vif[1].MISO;
			8'b11111011 : miso_pad_i_signal = spi_vif[2].MISO;	
			8'b11110111 : miso_pad_i_signal = spi_vif[3].MISO;	
			8'b11101111 : miso_pad_i_signal = spi_vif[4].MISO;	
			8'b11011111 : miso_pad_i_signal = spi_vif[5].MISO;	
			8'b10111111 : miso_pad_i_signal = spi_vif[6].MISO;	
			8'b01111111 : miso_pad_i_signal = spi_vif[7].MISO;	
		endcase
	end
	
    // DUT connection
    spi_top DUT(.PCLK(PCLK),  // APB Signals
                .PRESETN(apb_intf.PRESETn),
                .PSEL(apb_intf.PSEL),
                .PENABLE(apb_intf.PENABLE),
                .PWRITE(apb_intf.PWRITE),
                .PADDR(apb_intf.PADDR),           
                .PWDATA(apb_intf.PWDATA),
                .PRDATA(apb_intf.PRDATA),     
                .PREADY(apb_intf.PREADY),
                .PSLVERR(apb_intf.PSLVERR), 
                // Interrupt Signal		
                .IRQ(intr_intf.IRQ),	
                // SPI Signals    
                .ss_pad_o(ss_pad_o_signal), 
                .sclk_pad_o(sclk_pad_o_signal),
                .mosi_pad_o(mosi_pad_o_signal),
                .miso_pad_i(miso_pad_i_signal)
                );	



	// Generate block to create 8 instances of the "spi_interface" module.
	// The genvar data type is used as a loop variable to select each interface instance from the "spi_vif" array. 
	// It allows the code to dynamically select the interface instance based on the current loop iteration.
	// The initial statement inside the loop is used to configure the virtual interface instances using the UVM configuration database. 
	// The configuration is set based on the index value of the current loop iteration. 
	generate
		for(genvar i=0; i<8; i++) begin
		    initial uvm_config_db#(virtual spi_interface)::set(null, $sformatf("uvm_test_top.env.spi_agnt%0d", i), "spi_interface", spi_vif[i]);
		end
	endgenerate	
	
	
    initial begin
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top.env.apb_agnt", "apb_interface", apb_intf);
        uvm_config_db#(virtual interrupt_interface)::set(null, "uvm_test_top.env.intr_agnt", "interrupt_interface", intr_intf);
        run_test();
    end


endmodule





