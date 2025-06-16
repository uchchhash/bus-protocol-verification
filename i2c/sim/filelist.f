

//------ Defines ------//
+incdir+../defines/
../defines/tb_def.sv

//-------- RTL ---------//

// ----- i2c-slave-opencores -----//
+incdir+../rtl/
../rtl/rtl_filelist.sv

//-------- INTERFACE--------//
+incdir+../tb/agent/
../tb/agent/i2c_m_interface.sv

//----------- AGENT ----------//
//+incdir+../tb/agent/
../tb/agent/i2c_m_agent_package.sv

//-------- ENVIRONMENT -------//
+incdir+../tb/environment/
../tb/environment/environment_package.sv

//-------- TEST --------//
+incdir+../tb/test/
../tb/test/i2c_m_test_package.sv

//------ TOP -------//
+incdir+../tb/top/
../tb/top/tb_top.sv

