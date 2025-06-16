package env_pkg;
  
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import spi_reg_pkg::*;
    import intr_agnt_pkg::*;
    import apb_agnt_pkg::*;
    import spi_agnt_pkg::*;


	`include "spi_coverage.sv"
    `include "spi_reg_predictor.sv"
    `include "scoreboard.sv"
    `include "environment_config.sv"
    `include "environment.sv"



endpackage
