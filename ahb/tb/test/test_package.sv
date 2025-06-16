package test_package;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import environment_package::*;
	import agent_package::*;
	
	
    `include "ahb_base_test.sv"
    `include "reset_test.sv"
	`include "single_write_read_test.sv"
	`include "incr_write_read_test.sv"
	`include "wrap_write_read_test.sv"

endpackage
