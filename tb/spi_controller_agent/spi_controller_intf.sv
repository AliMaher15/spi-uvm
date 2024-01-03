// Interface: spi_controller_intf
//
interface spi_controller_intf
                      (
                        input i_Clk,
                        input i_Rst_L
                      );

// TX (MOSI) Signals
logic    [7:0]    i_TX_Byte;        // [MASTER] Byte to transmit on MOSI   ||  [SLAVE] Byte to transmit on MISO
logic             i_TX_DV;          // Data Valid Pulse with i_TX_Byte
logic             o_TX_Ready;       // {MASTER] Transmit Ready for next byte


//********* MACROS FUNCTIONS ***********//
`define spi_cont_assert_clk(arg) \
  assert property (@(posedge CLK) disable iff (!RST) arg);

`define spi_cont_assert_async_rst(arg) \
  assert property (@(negedge RST) 1'b1 |=> @(posedge CLK) arg);


Assert_spi_cont_rst_check :
 `spi_cont_assert_async_rst(i_TX_Byte==0 && i_TX_DV==0 && o_TX_Ready==0)
    
endinterface : spi_controller_intf