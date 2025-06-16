package intr_agnt_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import spi_agnt_pkg::*;
    import apb_agnt_pkg::*;
    
    `include "interrupt_monitor.sv"
    `include "interrupt_agent_config.sv"
    `include "interrupt_agent.sv"
    `include "interrupt_predictor.sv"



endpackage
