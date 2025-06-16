class environment extends uvm_env;
 
  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //  
    `uvm_component_utils(environment)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  environment_config env_cfg;
  i2c_m_agent i2c_m_agnt;
  i2c_m_scoreboard i2c_m_scb;
  i2c_m_coverage i2c_m_cov;

  // -------------------------------- //
  // ---- Methods of Environment ---- //
  // -------------------------------- //
  extern function new(string name = "environment", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //
function environment::new(string name = "environment", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C Environment Constructed *****", UVM_NONE);	
endfunction

// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //
	
function void environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** I2C Environment : Inside Build Phase *****", UVM_NONE);
  i2c_m_agnt = i2c_m_agent::type_id::create("i2c_m_agnt", this);  
  // Receive the Environment config
  if(!uvm_config_db#(environment_config)::get(this,"","env_cfg",env_cfg)) begin
    `uvm_fatal(get_type_name(), "***** Did not Get the Environment Config at Environment*****")
  end
  else `uvm_info(get_type_name(), "***** Got the Environment Config at Environment *****", UVM_NONE)
  i2c_m_scb = i2c_m_scoreboard::type_id::create("i2c_m_scb", this);
  if(env_cfg.has_functional_coverage) begin
    i2c_m_cov = i2c_m_coverage::type_id::create("i2c_m_cov", this);
  end
endfunction

// -------------------------------- //
// -------- Connect Phase --------- //
// -------------------------------- //

function void environment::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "***** I2C Environment : Inside Connect Phase *****", UVM_NONE);
  i2c_m_agnt.i2c_m_mntr.analysis_port_mntr2scb.connect(i2c_m_scb.analysis_imp_mntr2scb);
  if(env_cfg.has_functional_coverage) begin
    i2c_m_agnt.i2c_m_mntr.analysis_port_mntr2cov.connect(i2c_m_cov.analysis_export);
  end
endfunction 	




