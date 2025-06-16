package test_package;

	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import environment_package::*;
	import agent_package::*;
	
	
    `include "apb_base_test.sv"
    `include "reset_test.sv"
	`include "write_read_test.sv"

endpackage
