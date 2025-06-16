package apb_spi_test_pkg;

    // Standard UVM import & include:
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Any further package imports:
    import apb_spi_test_seq_pkg::*;
    import apb_spi_reg_seq_pkg::*;
    import env_pkg::*;
    import spi_reg_pkg::*;
    import apb_agnt_pkg::*;
    import spi_agnt_pkg::*;
    import intr_agnt_pkg::*;


    // Includes:
     `include "apb_spi_base_test.sv"
     `include "spi_msb_test.sv"
     `include "spi_lsb_test.sv"
     `include "spi_mode0_test.sv"
     `include "spi_mode1_test.sv"



     `include "spi_interrupt_test.sv"
     `include "spi_char_len_test.sv"
     `include "spi_auto_ss_test.sv"
     `include "spi_slvsel_test.sv"
     `include "spi_divider_test.sv"
     `include "spi_random_test.sv"
  	 `include "spi_combination_test.sv"
  
 	 `include "spi_high_frequency_test.sv" 
 	 `include "spi_low_frequency_test.sv"
  
  
  	`include "spi_reg_access_test.sv"
  	`include "spi_reg_reset_test.sv"
  	`include "spi_reg_bit_bash_test.sv"
  	`include "spi_reg_wr_test.sv"
  	
  	
endpackage
