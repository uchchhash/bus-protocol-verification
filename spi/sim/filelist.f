//------------------ Defines ------------------//
+incdir+../defines/
../defines/tb_def.sv

//------------------ RTL ------------------//
+incdir+../rtl/
../rtl/rtl_filelist.sv


//------------------ Interfaces ------------------//
+incdir+../tb/agents/apb_agent
../tb/agents/apb_agent/apb_interface.sv

+incdir+../tb/agents/spi_agent
../tb/agents/spi_agent/spi_interface.sv

+incdir+../tb/agents/interrupt_agent
../tb/agents/interrupt_agent/interrupt_interface.sv


//------------------ Agents ------------------//
+incdir+../tb/agents/apb_agent
../tb/agents/apb_agent/apb_agent_package.sv

+incdir+../tb/agents/spi_agent
../tb/agents/spi_agent/spi_agent_package.sv

+incdir+../tb/agents/interrupt_agent
../tb/agents/interrupt_agent/interrupt_agent_package.sv


//---------- REGISTER MODEL ----------//
+incdir+../tb/register_model/
../tb/register_model/spi_reg_package.sv


//-------- ENVIRONMENT -------//
+incdir+../tb/environment/
../tb/environment/environment_package.sv


//------- SEQUENCES ------//
+incdir+../tb/sequences/
../tb/sequences/apb_spi_reg_seq_package.sv
../tb/sequences/apb_spi_test_seq_package.sv

//-------- TEST --------//
+incdir+../tb/test/
../tb/test/apb_spi_test_package.sv

//------ TOP -------//
../tb/top/tb_top.sv









