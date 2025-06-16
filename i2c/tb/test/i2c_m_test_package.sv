package i2c_m_test_pkg;
	
        
  //----- Include UVM Macros -----//
  `include "uvm_macros.svh"
	
  //----- Import Packages ------//
  import uvm_pkg::*;
  import env_pkg::*;
  import i2c_m_agnt_pkg::*;
    
  //----- Include Test Package classes -----//
  `include "i2c_m_base_test.sv"
  `include "i2c_m_reset_test.sv"
  `include "i2c_m_combination_test.sv"
  `include "i2c_m_single_wr_test.sv"
  `include "i2c_m_successive_wr_test.sv"
  `include "i2c_m_restart_wr_test.sv"
  `include "i2c_m_single_ro_test.sv"
  `include "i2c_m_successive_ro_test.sv"
  `include "i2c_m_restart_ro_test.sv"
  

endpackage
