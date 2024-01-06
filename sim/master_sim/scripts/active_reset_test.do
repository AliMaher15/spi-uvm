set testname   "active_reset_test_c"

#***************************************************#
# Start a new Transcript File
#***************************************************#

transcript file log/$testname.log

#***************************************************#
# Start Simulation (choose your options)
#***************************************************#

vsim top_opt -c    -assertdebug    -debugDB     -fsmdebug    -coverage    +UVM_TESTNAME=$testname
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

#***************************************************#
# Save Coverage Results in .ucdb file
#***************************************************#

coverage attribute -name TESTNAME -value $testname
coverage save coverage/$testname.ucdb

#***************************************************#
# Close Transcript File by making a new one
#***************************************************#

transcript file ()

#***************************************************#
# draw the dut pins in waveforms
#***************************************************#

do waves.do