package spi_agnt_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    `include "tb_def.sv"

    `include "spi_sequence_item.sv"
    
    `include "spi_base_sequence.sv"
    `include "spi_miso_sequence.sv"

    `include "spi_agent_config.sv"
    `include "spi_sequencer.sv"
    `include "spi_monitor.sv"
    `include "spi_driver.sv"
    
    `include "spi_agent.sv"



endpackage
