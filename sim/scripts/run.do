#***************************************************#
# Clean Work Library
#***************************************************#
if [file exists "work"] {vdel -all}
vlib work

#***************************************************#
# Start a new Transcript File
#***************************************************#
transcript file log/RUN_LOG.log

#***************************************************#
# Compile RTL and TB files
#***************************************************#
vlog -f scripts/dut.f
vlog -f scripts/tb.f

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt spi_tb_top  -o top_opt    -debugdb      +acc        +cover=sbecf

#***************************************************#
# Simulation of Tests
#***************************************************#

#********************************** RUN TEST ***********************************#
do    scripts/spi_controller_only_test.do
#*********************************************************************************#



#***************************************************#
# save the coverage in text files
#***************************************************#
vcover merge  coverage/spi_cov.ucdb \
              coverage/spi_controller_only_test_c.ucdb   \
              coverage/spi_controller_and_master_test_c.ucdb  

# can use instance=/tb/dut/* to cover all dut's instances

vcover report coverage/spi_cov.ucdb  -cvg      -details                                 -output   coverage/fun_coverage.txt
vcover report coverage/spi_cov.ucdb  -details  -assert                                  -output   coverage/assertions.txt
vcover report coverage/spi_cov.ucdb  -instance=/spi_tb_top/spi_master_dut               -output   coverage/code_coverage.txt
vcover report coverage/spi_cov.ucdb  -instance=/spi_tb_top/spi_master_dut  -details     -output   coverage/code_coverage_details.txt

quit -sim