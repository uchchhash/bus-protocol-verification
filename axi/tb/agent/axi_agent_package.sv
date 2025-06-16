
package axi_agnt_pkg;

  //----- Include UVM Macros -----//
  `include "uvm_macros.svh"
  `include "tb_def.sv"

  //----- Import Packages ------//
  import uvm_pkg::*;


  // ---------- Structs Declaration --------- //
  typedef struct packed { bit [AWID_WIDTH-1:0] awid;  bit [ADDR_WIDTH-1:0] awaddr; bit [3:0] awlen; bit [2:0] awsize; bit [1:0] awburst; bit rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay;} aw_struct;
  typedef struct packed { bit [DATA_WIDTH-1:0] wdata; bit [STRB_WIDTH-1:0]  wstrb; bit rand_data, rand_wstrb, has_delay;} w_struct;
  typedef struct packed { bit [ARID_WIDTH-1:0] arid;  bit [ADDR_WIDTH-1:0] araddr; bit [3:0] arlen; bit [2:0] arsize; bit [1:0] arburst; bit rand_id, rand_addr, rand_len, rand_size, rand_burst, has_delay;} ar_struct;


  //----- Include Test Package classes -----//
  `include "axi_sequence_item.sv"
  `include "axi_sequence_base.sv"
  `include "axi_sequence_lib.sv"	

  `include "axi_agent_config.sv"
  `include "axi_monitor.sv"
  `include "axi_driver.sv"
  `include "axi_driver2.sv"	
  `include "axi_sequencer.sv"
  `include "axi_agent.sv"


endpackage




