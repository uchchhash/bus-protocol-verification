#!/bin/bash
# "Test_Name = $1"
#"Gui_or_Batch = $2"
rm -r ./INCA_libs/

if [[ ( $2 == "gui" ) ]]; then
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=$1 -$2
else
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=$1
fi
