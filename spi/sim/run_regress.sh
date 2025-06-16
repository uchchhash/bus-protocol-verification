#!/bin/bash
rm -r ./INCA_libs/
filenames=`ls ../tb/test/*.sv`

declare -a array1
declare -a array2
array2=(apb_spi_base_test apb_spi_test_package spi_reg_bit_bash_test spi_reg_access_test spi_reg_reset_test spi_random_test spi_combination_test)

for i in $filenames
do
   file="$(basename "$i" .sv )"
   array1+="$file "
done
#echo $array1


for i in ${array2[@]}; 
do
	array1=( "${array1[@]/$i}" )
done
#echo $array1

rm -r ./INCA_libs/

for i in $array1
do   
if [[ ( $1 == "cov" ) ]]; then
	#./run.sh $i $2 $3
	irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME=$i -coverage all -covtest $i
else
#	./run.sh $i
	irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME=$i 
fi
done



#set merge -union
#iccr merge cov_work/scope/* -output merge_dir
#iccr load_test merge_dir
#iccr report_html *
#exit
#firefox html*/index.html &
