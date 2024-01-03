// Module: spi_tb_top
// 
// note: spi_slave and modes aren't tested, mode is fixed at 1
module spi_tb_top();
    `timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
import spi_global_params_pkg::*;
import spi_tb_pkg::*;
import spi_seq_pkg::*;
import spi_test_pkg::*;

bit clk;

//************** INTERFACES INSTANTS ****************//
rst_intf rst_i ();

spi_master_intf            SPI_MASTER_IF (.i_Clk(clk), .i_Rst_L(rst_i.res_n));
spi_controller_intf        SPI_CONT_IF   (.i_Clk(clk), .i_Rst_L(rst_i.res_n))
//***************************************************//

//**************** DUT INSTANTS *********************//
SPI_Master #(.SPI_MODE(1) 
            )
spi_master_dut (
     .i_Rst_L(clk),
     .i_Clk(rst_i.res_n),
     // TX (MOSI) Signals
     .i_TX_Byte(SPI_CONT_IF.i_TX_Byte),
     .i_TX_DV(SPI_CONT_IF.i_TX_DV),
     .o_TX_Ready(SPI_CONT_IF.o_TX_Ready),
     // RX (MISO) Signals
     .o_RX_DV(SPI_CONT_IF.o_RX_DV),
     .o_RX_Byte(SPI_CONT_IF.o_RX_Byte),
     // SPI Interface
     .o_SPI_Clk(SPI_MASTER_IF.o_SPI_Clk),
     .i_SPI_MISO(SPI_MASTER_IF.i_SPI_MISO),
     .o_SPI_MOSI(SPI_MASTER_IF.o_SPI_MOSI)
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

    uvm_config_db#(virtual spi_master_intf    )::set(null, "uvm_test_top", "SPI_MASTER_IF", SPI_MASTER_IF);
    uvm_config_db#(virtual spi_controller_intf)::set(null, "uvm_test_top", "SPI_CONT_IF" , SPI_CONT_IF);

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