

//------ Defines ------//
+incdir+../defines/
../defines/tb_def.sv

//-------- RTL ---------//

// ----- axi-slave-arm -----//
+incdir+../rtl/axi_slave_arm/
../rtl/axi_slave_arm/rtl_filelist.sv


//-------- INTERFACE--------//
+incdir+../tb/agent/
../tb/agent/axi_interface.sv

//----------- AGENT ----------//
+incdir+../tb/agent/
../tb/agent/axi_agent_package.sv


//-------- ENVIRONMENT -------//
+incdir+../tb/environment/
../tb/environment/environment_package.sv

//-------- TEST --------//
+incdir+../tb/test/
../tb/test/axi_test_package.sv

//------ TOP -------//
+incdir+../tb/top/
../tb/top/tb_top.sv
../tb/top/axi4_assert.sv

