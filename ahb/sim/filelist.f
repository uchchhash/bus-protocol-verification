
//------ Defines ------//
../defines/tb_def.sv


//-------- RTL ---------//
+incdir+../rtl/
../rtl/def.sv
../rtl/ahbslv.sv

//-------- INTERFACE--------//
+incdir+../tb/agent/
../tb/agent/ahb_interface.sv


//----------- AGENT ----------//
+incdir+../tb/agent/
../tb/agent/ahb_agent_package.sv


//-------- ENVIRONMENT -------//
+incdir+../tb/environment/
../tb/environment/environment_package.sv

//-------- TEST --------//
+incdir+../tb/test/
../tb/test/ahb_test_package.sv


//------ TOP -------//
../tb/top/tb_top.sv
../defines/tb_def.sv




