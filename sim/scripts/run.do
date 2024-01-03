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
vopt spi_tb_top -o top_opt -debugdb  +acc +cover=sbecf

#***************************************************#
# Simulation of Tests
#***************************************************#

#********************************** RUN A TEST ***********************************#
transcript file log/spi_controller_only_test_c.log
vsim top_opt -c -assertdebug -debugDB -fsmdebug -coverage +UVM_TESTNAME=spi_controller_only_test_c
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value spi_controller_only_test_c
coverage save coverage/spi_controller_only_test_c.ucdb
#*********************************************************************************#

#***************************************************#
# Close the Transcript file
#***************************************************#
transcript file ()

#***************************************************#
# draw the dut pins in waveforms
#***************************************************#
do waves.do

#***************************************************#
# save the coverage in text files
#***************************************************#
vcover merge  coverage/spi_cov.ucdb \
              coverage/spi_controller_only_test_c.ucdb   
              
              
vcover report coverage/spi_cov.ucdb  -cvg      -details    -output   coverage/fun_coverage.txt
vcover report coverage/spi_cov.ucdb  -details  -assert     -output   coverage/assertions.txt
vcover report coverage/spi_cov.ucdb                        -output   coverage/code_coverage.txt

#quit -sim