
# can use instance=/tb/dut/* to cover all dut's instances

vcover report coverage/spi_cov.ucdb  -cvg      -details                                 -output   coverage/fun_coverage.txt
vcover report coverage/spi_cov.ucdb  -details  -assert                                  -output   coverage/assertions.txt
vcover report coverage/spi_cov.ucdb  -instance=/spi_tb_top/spi_master_dut               -output   coverage/code_coverage.txt
vcover report coverage/spi_cov.ucdb  -instance=/spi_tb_top/spi_master_dut  -details     -output   coverage/code_coverage_details.txt