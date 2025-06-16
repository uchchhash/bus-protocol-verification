
#------ Remove INCA_libs -------#

if [[ -d INCA_libs ]];
then rm -r ./INCA_libs/
fi

#------ Remove logs --------#

rm irun.*
rm iccr.*

if [[ -d waves.shm ]];
then rm -r ./waves.shm/
fi

#------ Remove cov_work -------#

if [[ -d cov_work ]];
then rm -r ./cov_work/
fi

#------ Required Variables -------#
# $1 --> Run mode
# $2 --> Verbosity
# $3 --> Test Name

#------- Create a Test List --------#
filenames=`ls ../tb/test/*.sv`

declare -a test_array
declare -a array1
declare -a array2
# insert un-interested test files in this array
array2=(i2c_m_base_test i2c_m_test_package)

for i in $filenames
do
  file="$(basename "$i" .sv )"
  array1+="$file "
done

for i in ${array2[@]}; 
do
  array1=( "${array1[@]/$i}" )
done

if [ $1 == "help" ]
then
  echo "========================================================================================================";
  echo "============================= run : GUI/BATCH - VERBOSITY - TESTNAME ===================================";
  echo "========================================================================================================";
elif [ $1 == "batch" ]
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
    cp ./irun.log ./log_files/$i.log
	done	
	
elif [ $1 == "single_cov" ]
then
	echo "========== Single Test with Coverage Mode Called ==========";
        irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$3 -coverage all -covtest $3
	iccr iccr_cov.cmd
	firefox html*/index.html &
	
elif [ $1 == "single_cov_exclude" ]
then
	echo "========== Single Test with Coverage Mode Called (Excluding Signals from given list) ==========";
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$3 -coverage all -covtest $3 -covfile cov_config.ccf
	iccr iccr_cov.cmd
	firefox html*/index.html &
	
elif [ $1 == "regress_cov" ]
then
	echo "========== Regression Test with Coverage Mode Called ==========";
	for i in $array1
	do   
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i
	cp ./irun.log ./log_files/$i.log	
	done	
	iccr iccr_merge_cov.cmd
	firefox html*/index.html &

elif [ $1 == "regress_cov_exclude" ]
then
	echo "========== Regression Test with Coverage Mode Called (Excluding Signals from given list) ==========";
	for i in $array1
	do   
    irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i -covfile cov_config.ccf
	cp ./irun.log ./log_files/$i.log
	done
	iccr iccr_merge_cov.cmd
	firefox html*/index.html &
	
elif [ $1 == "selected_cov_exclude" ]
then	
	echo "========== Selected Test with Coverage Mode Called (Excluding Signals from given list) ==========";	
	#------- Create a Test List --------#
	mapfile test_array < test_list.txt
	for i in $test_array
	do   
        irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i -covfile cov_config.ccf
	cp ./irun.log ./log_files/$i.log
	done
	iccr iccr_merge_cov.cmd
	firefox html*/index.html &
        
elif [ $1 == "selected_cov_merge_exclude" ]
then	
	echo "========== Selected Test with Coverage Merge Mode Called (Excluding Signals from given list) ==========";	
	#------- Copy the cov_work folder inside cov_file --------#	
	cp -R ./cov_work ./cov_files/
	#------- Remove the cov_work folder --------#	
        rm -r ./cov_work/
	#------- Create a Test List --------#
	mapfile test_array < test_list.txt
	for i in $test_array
	do   
        irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i -covfile cov_config.ccf
	cp ./irun.log ./log_files/$i.log
	done
	#------- Merge the previous cov_work with latest cov_work --------#	
	cp -R ./cov_files/cov_work/scope ./cov_work/		
	iccr iccr_merge_cov.cmd
	firefox html*/index.html &


elif [ $1 == "selected_cov_merge" ]
then
  echo "========== Selected Tests with Coverage Merge Mode Called ==========";	
  #------- Copy the cov_work folder inside cov_file --------#	
  cp -R ./cov_work ./cov_files/
  #------- Remove the cov_work folder --------#	
  rm -r ./cov_work/
  mapfile test_array < test_list.txt
  for i in $test_array
    do
      irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm -svseed random +UVM_VERBOSITY=$2 +UVM_TESTNAME=$i -coverage all -covtest $i
      cp ./irun.log ./log_files/$i.log
    done
    iccr iccr_merge_cov.cmd
    firefox html*/index.html &
fi







