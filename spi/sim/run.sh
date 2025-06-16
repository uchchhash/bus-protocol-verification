
#------ Remove INCA_libs -------#

if [[ -d INCA_libs ]];
then
    rm -r ./INCA_libs/
fi

#------ Required Variables -------#
# $1 --> Run mode
# $2 --> Verbosity
# $3 --> Test Name

#------- Create a Test List --------#
filenames=`ls ../tb/test/*.sv`

declare -a array1
declare -a array2
array2=(apb_spi_base_test apb_spi_test_package spi_reg_wr_test spi_reg_reset_test spi_cov_test spi_high_frequency_test spi_low_frequency_test spi_combination_test spi_random_test)

for i in $filenames
do
   file="$(basename "$i" .sv )"
   array1+="$file "
done

for i in ${array2[@]}; 
do
	array1=( "${array1[@]/$i}" )
done


if [ $1 == "batch" ]
then
    echo "========== Batch Mode Called ==========";
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$3

elif [ $1 == "gui" ]
then
    echo "========== GUI Mode Called ==========";
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random -gui +UVM_VERBOSITY=$2 +UVM_TESTNAME=$3
    
elif [ $1 == "regress" ]
then
	echo "========== Regression Mode Called ==========";
	for i in $array1
	do   
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i
	done	
	
elif [ $1 == "single_cov" ]
then
	echo "========== Single Test with Coverage Mode Called ==========";
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$3 -coverage all -covtest $3
	iccr iccr_cov.cmd
	firefox html*/index.html &
	
elif [ $1 == "regress_cov" ]
then
	echo "========== Regression Test with Coverage Mode Called ==========";
	for i in $array1
	do   
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i
	done	
	iccr iccr_merge_cov.cmd
	firefox html*/index.html &

elif [ $1 == "regress_cov_exclude" ]
then
	echo "========== Regression Test with Coverage Mode Called (Excluding Signals from given list) ==========";
	for i in $array1
	do   
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i -covfile toggle_exclude.ccf
	done
	iccr iccr_merge_cov.cmd
	firefox html*/index.html &

fi




