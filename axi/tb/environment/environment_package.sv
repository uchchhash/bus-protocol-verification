
package env_pkg;

  //----- Include UVM Macros -----//
  `include "uvm_macros.svh"

  //----- Import Packages ------//
  import uvm_pkg::*;
  import axi_agnt_pkg::*;


  //----- Include Test Package classes -----//
  `include "axi_coverage.sv"
  `include "axi_scoreboard.sv"
  `include "axi_predictor.sv"	
  `include "environment_config.sv"
  `include "environment.sv"

endpackage


