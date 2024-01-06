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
vlog -f scripts/tb.f     +define+def_spi_CLK_PERIOD=10

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt spi_tb_top  -o top_opt    -debugdb      +acc        +cover=sbecf

#***************************************************#
# Simulation of Tests
#***************************************************#

do    scripts/spi_controller_and_master_test.do


#***************************************************#
# save the coverage in text files
#***************************************************#

#do    scripts/vcover.do



quit -sim