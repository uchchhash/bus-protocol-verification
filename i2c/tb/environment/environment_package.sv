package env_pkg;

  //----- Include UVM Macros -----//
  `include "uvm_macros.svh"

  //----- Import Packages ------//
  import uvm_pkg::*;
  import i2c_m_agnt_pkg::*;


  //----- Include Test Package classes -----//
  `include "i2c_m_coverage.sv"  
  `include "i2c_m_scoreboard.sv"  
  `include "environment_config.sv"
  `include "environment.sv"

endpackage
