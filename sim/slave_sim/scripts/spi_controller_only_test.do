#***************************************************#
# Start a new Transcript File
#***************************************************#

transcript file log/spi_controller_only_test_c.log

#***************************************************#
# Start Simulation (choose your options)
#***************************************************#

vsim top_opt -c    -assertdebug    -debugDB     -fsmdebug    -coverage    +UVM_TESTNAME=spi_controller_only_test_c
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

#***************************************************#
# Save Coverage Results in .ucdb file
#***************************************************#

coverage attribute -name TESTNAME -value spi_controller_only_test_c
coverage save coverage/spi_controller_only_test_c.ucdb

#***************************************************#
# Close Transcript File by making a new one
#***************************************************#

transcript file ()

#***************************************************#
# draw the dut pins in waveforms
#***************************************************#

do waves.do