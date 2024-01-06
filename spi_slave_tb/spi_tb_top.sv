// Module: spi_tb_top
// 
// note: modes aren't tested, mode is fixed at 1

`timescale 1ns/1ps

module spi_tb_top();

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_global_params_pkg::*;
import spi_tb_pkg::*;
import spi_seq_pkg::*;
import spi_test_pkg::*;

bit clk;

//************** INTERFACES INSTANTS ****************//
rst_intf rst_i ();

spi_slave_intf             SPI_SLAVE_IF  (.i_Clk(clk), .i_Rst_L(rst_i.res_n));
spi_controller_intf        SPI_CONT_IF   (.i_Clk(clk), .i_Rst_L(rst_i.res_n));
//***************************************************//

//**************** DUT INSTANTS *********************//
SPI_Slave #(.SPI_MODE(1))
spi_slave_dut (
     .i_Rst_L(rst_i.res_n),
     .i_Clk(clk),
     // TX (MOSI) Signals
     .i_TX_Byte(SPI_CONT_IF.i_TX_Byte),
     .i_TX_DV(SPI_CONT_IF.i_TX_DV),
     // RX (MISO) Signals
     .o_RX_DV(SPI_CONT_IF.o_RX_DV),
     .o_RX_Byte(SPI_CONT_IF.o_RX_Byte),
     // SPI Interface
     .i_SPI_Clk(SPI_SLAVE_IF.i_SPI_Clk),
     .i_SPI_MOSI(SPI_SLAVE_IF.i_SPI_MOSI),
     .o_SPI_MISO(SPI_SLAVE_IF.o_SPI_MISO),
     .i_SPI_CS_n(SPI_SLAVE_IF.i_SPI_CS_n)
     );
//***************************************************//

//************** ASSERTIONS MODULE ******************//
// inside interfaces
//***************************************************// 

//***************** START TEST **********************//
// pass the interfaces handles then run the test
initial begin
    // Set interfaces handles to uvm_test_top
    uvm_resource_db#(virtual rst_intf)::set("rst_intf", "rst_i", rst_i);

    uvm_config_db#(virtual spi_slave_intf.drv_mp    )::set(null, "uvm_test_top", "SPI_SLAVE_DRV_MP", SPI_SLAVE_IF.drv_mp);
    uvm_config_db#(virtual spi_slave_intf.mon_mp    )::set(null, "uvm_test_top", "SPI_SLAVE_MON_MP", SPI_SLAVE_IF.mon_mp);

    uvm_config_db#(virtual spi_controller_intf.drv_mp)::set(null, "uvm_test_top", "SPI_CONT_DRV_MP" , SPI_CONT_IF.drv_mp);
    uvm_config_db#(virtual spi_controller_intf.mon_mp)::set(null, "uvm_test_top", "SPI_CONT_MON_MP" , SPI_CONT_IF.mon_mp);

    run_test();
end
//***************************************************// 

//***************** CLOCK ***************************//
initial begin
    clk = 0;
    forever begin  
        #(CLK_PERIOD/2);  clk = ~clk;
    end
end
//***************************************************// 

endmodule : spi_tb_top