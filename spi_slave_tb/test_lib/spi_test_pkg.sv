package spi_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import spi_item_pkg::*;
    import spi_global_params_pkg::*;
    import spi_slave_agent_pkg::*;
    import spi_controller_agent_pkg::*;
    import spi_seq_pkg::*;
    import spi_tb_pkg::*;

    `include "spi_base_vseq_c.svh"    
    `include "spi_base_test_c.svh"

    `include "spi_controller_only_vseq_c.svh"
    `include "spi_master_only_vseq_c.svh"




    `include "spi_controller_only_test_c.svh"
    `include "spi_controller_and_master_test_c.svh"



    `include "idle_reset_test_c.svh"
    `include "active_reset_test_c.svh"

endpackage : spi_test_pkg