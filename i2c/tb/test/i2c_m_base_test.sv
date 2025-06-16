class i2c_m_base_test extends uvm_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_base_test)
  
  
  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  bit ro_test;
  environment env;
  environment_config env_cfg;
  i2c_m_agent_config i2c_m_agnt_cfg;
  
  // --------- I2C Slave Sequences ---------//
  i2c_m_reset_sequence i2c_m_rst_seq;  
  i2c_m_write_sequence i2c_write_seq;
  i2c_m_read_sequence  i2c_read_seq;

  // -------------------------------- //
  // ----- Methods of Base Test ----- //
  // -------------------------------- //
  extern function new(string name = "i2c_m_base_test", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern function void configure_i2c_agent(input bit assert_write, input bit assert_read, input bit ro_test);
  extern task run_i2c_reset_sequence;
  extern task run_i2c_write_sequence(input int num_writes, input bit rand_num, input bit [7:0] reg_addr, input bit rand_addr, input bit [31:0] write_data, input bit rand_data);
  extern task run_i2c_read_sequence (input int num_reads,  input bit rand_num, input bit [7:0] reg_addr, input bit rand_addr, input bit assert_restart, input bit rand_type);
  extern task run_i2c_ro_sequence   (input int num_reads,  input bit rand_num, input bit [7:0] reg_addr, input bit rand_addr, input bit assert_restart, input bit rand_type);
  extern task run_i2c_single_write(input bit [7:0] reg_addr, input bit rand_addr, input bit [31:0] write_data, input bit rand_data);
  extern task run_i2c_single_read(input bit [7:0] reg_addr, input bit rand_addr);


endclass : i2c_m_base_test
  
  
// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //
  
function i2c_m_base_test::new(string name = "i2c_m_base_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C Master Base Test : Constructed *****", UVM_NONE);
endfunction

    
// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //
  
function void i2c_m_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** I2C Master Base Test : Inside Build Phase *****", UVM_NONE);
  // Construct the environment, environment-config & agent-config
  env = environment::type_id::create("env", this);
  env_cfg = environment_config::type_id::create("env_cfg", this);
  i2c_m_agnt_cfg = i2c_m_agent_config::type_id::create("i2c_m_agnt_cfg", this);
  // Send the configs to desired places using uvm_config_db
  uvm_config_db#(environment_config)::set(this, "env", "env_cfg", env_cfg);
  uvm_config_db#(i2c_m_agent_config)::set(this, "env.i2c_m_agnt", "i2c_m_agnt_cfg", i2c_m_agnt_cfg); 
endfunction
  
  
// ------------------------------------- //
// ----- End of Elaboration Phase ------ //
// ------------------------------------- //
  
function void i2c_m_base_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  `uvm_info(get_type_name(), "***** I2C Master Base Test : End of Elaboration Phase *****", UVM_NONE);		
  uvm_top.print_topology();
endfunction


// ------------------------------------------- //
// ----- Configure the I2C Master Agent ------ //
// ------------------------------------------- //

function void i2c_m_base_test::configure_i2c_agent(input bit assert_write, input bit assert_read, input bit ro_test);
  i2c_m_agnt_cfg.assert_write   = assert_write;
  i2c_m_agnt_cfg.assert_read    = assert_read;
  i2c_m_agnt_cfg.ro_test        = ro_test;
  //$display("config-agnt :: ro_test = %0d", i2c_m_agnt_cfg.ro_test);  
endfunction

// ------------------------------------------------------------ //
// ---------- Inidividual Tasks to Control Sequences ---------- //
// ------------------------------------------------------------ //



// --------- Global Reset Sequence ---------- //
task i2c_m_base_test::run_i2c_reset_sequence;
  //`uvm_info(get_type_name(), "***** I2C Master Base Test : Reset Sequence Initiated *****", UVM_NONE);
  i2c_m_rst_seq = i2c_m_reset_sequence::type_id::create("i2c_m_rst_seq");
  i2c_m_rst_seq.start(env.i2c_m_agnt.i2c_m_seqr);
endtask


// --------- I2C Master Write Sequence ---------- //
task i2c_m_base_test::run_i2c_write_sequence(input int num_writes, input bit rand_num, input bit [7:0] reg_addr, input bit rand_addr, input bit [31:0] write_data, input bit rand_data);
  //`uvm_info(get_type_name(), "***** I2C Master Base Test :: Write Sequence Initiated *****", UVM_NONE)
  // Update the I2C Agent Configs
  configure_i2c_agent(.assert_write(1), .assert_read(0), .ro_test(0));  
  // Update the I2C Write Sequence
  i2c_write_seq = i2c_m_write_sequence::type_id::create("i2c_write_seq");
  i2c_write_seq.num_writes    = num_writes;
  i2c_write_seq.rand_num      = rand_num;
  i2c_write_seq.reg_addr      = reg_addr;
  i2c_write_seq.rand_addr     = rand_addr;
  i2c_write_seq.write_data    = write_data;
  i2c_write_seq.rand_data     = rand_data;
  i2c_write_seq.start(env.i2c_m_agnt.i2c_m_seqr);  
endtask


// --------- I2C Master Single Write Sequence ---------- //
task i2c_m_base_test::run_i2c_single_write(input bit [7:0] reg_addr, input bit rand_addr, input bit [31:0] write_data, input bit rand_data);
  //`uvm_info(get_type_name(), "***** I2C Master Base Test :: Single Write Sequence Initiated *****", UVM_NONE)
  // Update the I2C Agent Configs
  configure_i2c_agent(.assert_write(1), .assert_read(0), .ro_test(0));  
  // Update the I2C Write Sequence
  run_i2c_write_sequence(.num_writes(1), .rand_num(0), .reg_addr(reg_addr), .rand_addr(rand_addr), .write_data(write_data), .rand_data(rand_data));
endtask

// --------- I2C Master Read Sequence ---------- //
task i2c_m_base_test::run_i2c_read_sequence (input int num_reads,  input bit rand_num, input bit [7:0] reg_addr, input bit rand_addr, input bit assert_restart, input bit rand_type);
  //`uvm_info(get_type_name(), "***** I2C Master Base Test :: Read Sequence Initiated *****", UVM_NONE) 
  $display(" %%%%%%%%%%%%%%%%%%%%%% rand-num = %0d // num_reads = %0d // rand_type = %0d %%%%%%%%%%%%%%%%%%%%%%", rand_num, num_reads, rand_type); 
 // Update the I2C Agent Configs
  configure_i2c_agent(.assert_write(0), .assert_read(1), .ro_test(0));
  // Update the I2C Read Sequence  
  i2c_read_seq = i2c_m_read_sequence::type_id::create("i2c_read_seq");
  i2c_read_seq.assert_reset   = 0;
  i2c_read_seq.assert_write   = 0;
  i2c_read_seq.assert_read    = 1;
  i2c_read_seq.num_reads      = num_reads;
  i2c_read_seq.rand_num       = rand_num;
  i2c_read_seq.reg_addr       = reg_addr;
  i2c_read_seq.rand_addr      = rand_addr;
  i2c_read_seq.assert_restart = assert_restart;
  i2c_read_seq.rand_type      = rand_type;
  i2c_read_seq.ro_test        = (!rand_num && num_reads < 5) ? 1'b0 : 1'b1;
  i2c_read_seq.start(env.i2c_m_agnt.i2c_m_seqr);    
endtask

// --------- I2C Master Single Read Sequence ---------- //
task i2c_m_base_test::run_i2c_single_read(input bit [7:0] reg_addr, input bit rand_addr);
  //`uvm_info(get_type_name(), "***** I2C Master Base Test :: Single Read Sequence Initiated *****", UVM_NONE)
  // Update the I2C Agent Configs
  configure_i2c_agent(.assert_write(0), .assert_read(1), .ro_test(0));  
  // Update the I2C Read Sequence  
  run_i2c_read_sequence(.num_reads(1), .rand_num(0), .reg_addr(reg_addr), .rand_addr(rand_addr), .assert_restart(0), .rand_type(1));
endtask


// --------- I2C Master Read-Only Sequence ---------- //
task i2c_m_base_test::run_i2c_ro_sequence (input int num_reads, input bit rand_num, input bit [7:0] reg_addr, input bit rand_addr, input bit assert_restart, input bit rand_type);
  //`uvm_info(get_type_name(), "***** I2C Master Base Test :: Read Only Sequence Initiated *****", UVM_NONE)
  // Update the I2C Agent Configs
  configure_i2c_agent(.assert_write(0), .assert_read(1), .ro_test(1));   
  // Update the I2C Read Sequence  
  i2c_read_seq = i2c_m_read_sequence::type_id::create("i2c_read_seq");
  i2c_read_seq.assert_reset   = 0;
  i2c_read_seq.assert_write   = 0;
  i2c_read_seq.assert_read    = 1;
  i2c_read_seq.ro_test        = ro_test; 
  i2c_read_seq.num_reads      = num_reads;
  i2c_read_seq.rand_num       = rand_num;
  i2c_read_seq.reg_addr       = reg_addr;
  i2c_read_seq.rand_addr      = rand_addr;
  i2c_read_seq.assert_restart = assert_restart;
  i2c_read_seq.rand_type      = rand_type;
  i2c_read_seq.start(env.i2c_m_agnt.i2c_m_seqr);  
endtask


