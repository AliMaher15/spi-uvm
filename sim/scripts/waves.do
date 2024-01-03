# Clocks
add wave /spi_tb_top/clk
add wave /spi_tb_top/rst_i/res_n

# SPI MASTER Inputs
add wave     -group     SPI_M_IN     -color Magenta     /spi_tb_top/SPI_MASTER_IF/i_SPI_MISO
                    
# SPI MASTER Outputs
add wave     -group     SPI_M_OUT     -color Pink       /spi_tb_top/SPI_MASTER_IF/o_SPI_Clk \
                                                        /spi_tb_top/SPI_MASTER_IF/o_SPI_MOSI

# SPI CONTROLLER Inputs
add wave     -group     SPI_CONT_IN   -color Magenta    /spi_tb_top/SPI_CONT_IF/i_TX_DV \
                                                        /spi_tb_top/SPI_CONT_IF/i_TX_Byte
                    
# SPI CONTROLLER Outputs
add wave     -group     SPI_CONT_OUT   -color Pink      /spi_tb_top/SPI_CONT_IF/o_TX_Ready \
                                                        /spi_tb_top/SPI_CONT_IF/o_RX_DV \
                                                        /spi_tb_top/SPI_CONT_IF/o_RX_Byte