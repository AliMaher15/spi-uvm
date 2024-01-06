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
do scripts/compile_dut.do
do scripts/compile_tb.do 

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt spi_tb_top  -o top_opt    -debugdb      +acc        +cover=sbecf

#***************************************************#
# Simulation of Tests
#***************************************************#

do    scripts/spi_controller_only_test.do


#***************************************************#
# save the coverage in text files
#***************************************************#
#vcover merge  coverage/spi_cov.ucdb \
#              coverage/spi_controller_only_test_c.ucdb   \
#              coverage/spi_controller_and_master_test_c.ucdb  

#do    scripts/vcover.do



quit -sim