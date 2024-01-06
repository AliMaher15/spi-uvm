package spi_slave_agent_pkg;

    //uvm pakage and macros
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import spi_item_pkg::*;

    `include "spi_slave_agent_cfg_c.svh"
    `include "spi_slave_monitor_c.svh"
    `include "spi_slave_agent_seqr_c.svh"
    `include "spi_slave_driver_c.svh"
    `include "spi_slave_agent_c.svh"
  
  
  endpackage : spi_slave_agent_pkg