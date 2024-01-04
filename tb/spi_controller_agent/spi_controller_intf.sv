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
logic             o_TX_Ready;       // [MASTER] Transmit Ready for next byte

// RX (MISO) Signals
logic             o_RX_DV;           // Data Valid pulse (1 clock cycle)
logic    [7:0]    o_RX_Byte;         // [MASTER] Byte received on MISO  || [SLAVE] Byte recieved on MOSI


//********* MACROS FUNCTIONS ***********//
`define spi_cont_assert_clk(arg) \
  assert property (@(posedge i_Clk) disable iff (!i_Rst_L) arg);

`define spi_cont_assert_async_rst(arg) \
  assert property (@(negedge i_Rst_L) 1'b1 |=> @(posedge i_Clk) arg);


Assert_spi_cont_rst_check :
 `spi_cont_assert_async_rst(i_TX_Byte==0 && i_TX_DV==0 && o_TX_Ready==0 
                            && o_RX_DV==0 && o_RX_Byte==0)

Assert_spi_cont_data_valid_pulse_high_one_cycle_rx :
 `spi_cont_assert_clk( o_RX_DV |=> !o_RX_DV )

Assert_spi_cont_data_valid_pulse_high_one_cycle_tx :
 `spi_cont_assert_clk( i_TX_DV |=> !i_TX_DV )
    
endinterface : spi_controller_intf