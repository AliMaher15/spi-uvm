// Interface: spi_master_intf
//
interface spi_master_intf
                      (
                        input i_Clk,
                        input i_Rst_L
                      );

// SPI Interface
logic             i_SPI_MISO;       // master input, slave output serialized data (LSB first)
logic             o_SPI_MOSI;       // master output, slave input serialized data (MSB first)
logic             o_SPI_Clk;        // slave clock generated by master (at Mode "0"/"1" = 0)

// Clocking Block: mon_cb
//
// input #0: sampled in Observed region || output #0: sampled in NBA region
// default input #1step(before event with smallest precision) output #0(after event);
clocking mon_cb @(negedge o_SPI_Clk or negedge i_Rst_L);
  input 		      i_SPI_MISO;
  input           o_SPI_MOSI;    
endclocking : mon_cb


// Clocking Block: drv_cb
//
clocking drv_cb @(posedge o_SPI_Clk or negedge i_Rst_L);
  output 		      i_SPI_MISO;
endclocking : drv_cb

// ModPorts
modport mon_mp(clocking mon_cb, input i_Rst_L);
modport drv_mp(clocking drv_cb, input i_Rst_L);

//********* MACROS FUNCTIONS ***********//
`define spi_master_assert_clk(arg) \
  assert property (@(posedge i_Clk) disable iff (!i_Rst_L) arg);

`define spi_master_assert_async_rst(arg) \
  assert property (@(negedge i_Rst_L) 1'b1 |=> @(posedge i_Clk) arg);


Assert_spi_master_rst_interface_signals :
  `spi_master_assert_async_rst(i_SPI_MISO==0 && o_SPI_MOSI==0)
    
endinterface : spi_master_intf