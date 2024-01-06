package spi_tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
 
    import spi_item_pkg::*;
    import spi_slave_agent_pkg::*;
    import spi_controller_agent_pkg::*;
    import spi_global_params_pkg::*;

    `include "rst_driver_c.svh"

    `include "spi_checkers/spi_coverage_c.svh"
    `include "spi_checkers/spi_sb_comparator_c.svh"
    `include "spi_checkers/spi_sb_predictor_c.svh"
    `include "spi_checkers/spi_scoreboard_c.svh"
    `include "spi_env_cfg_c.svh"
    `include "spi_vsequencer_c.svh"	
    `include "spi_env_c.svh"    

endpackage : spi_tb_pkg