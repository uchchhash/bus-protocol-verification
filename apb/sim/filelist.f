//-------- RTL ---------//
../rtl/apb_slave.sv


//-------- INTERFACE--------//
../tb/agent/apb_interface.sv


//----------- AGENT ----------//
//+incdir+../TB/agent/
//../tb/agent/apb_agent_package.sv
../tb/agent/apb_sequence_item.sv
../tb/agent/apb_sequence.sv
../tb/agent/apb_sequencer.sv
../tb/agent/apb_monitor.sv
../tb/agent/apb_driver.sv
../tb/agent/apb_agent_config.sv
../tb/environment/apb_coverage.sv
../tb/agent/apb_agent.sv



//-------- ENVIRONMENT -------//
//+incdir+../TB/environment/
../tb/environment/scoreboard.sv
../tb/environment/environment_config.sv
../tb/environment/environment.sv



//-------- TEST --------//
//+incdir+../TB/test
//../tb/test/apb_test_package.sv
../tb/test/apb_base_test.sv
../tb/test/apb_write_read_test.sv
../tb/test/apb_reset_test.sv

//------ TOP -------//
../tb/top/tb_top.sv











