#!/bin/bash
filenames=`ls ../TB/test/*.sv`

declare -a array1
declare -a array2
array2=(apb_base_test test_package)

for i in $filenames
do
   file="$(basename "$i" .sv )"
   array1+="$file "
done
//echo $array1


for i in ${array2[@]}; 
do
	array1=( "${array1[@]/$i}" )
done
//echo $array1


for i in $array1
do   
if [[ ( $1 == "cov" ) ]]; then
	#./run.sh $i $2 $3
	irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME=$i -coverage all -covtest $i
	rm -r ./INCA_libs/
else
#	./run.sh $i
	irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME=$i 
	rm -r ./INCA_libs/
fi
done

