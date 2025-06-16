class environment extends uvm_env;
 
  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //  
    `uvm_component_utils(environment)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  environment_config env_cfg;
  axi_agent axi_agnt;
  axi_predictor axi_pred;
  axi_scoreboard axi_scb;
  axi_coverage axi_cov;

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
  `uvm_info(get_type_name(), "***** AXI Environment Constructed *****", UVM_NONE);	
endfunction

// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //
	
function void environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** AXI Environment : Inside Build Phase *****", UVM_NONE);
  axi_pred = axi_predictor::type_id::create("axi_pred", this);  
  axi_agnt = axi_agent::type_id::create("axi_agnt", this);
  axi_scb = axi_scoreboard::type_id::create("axi_scb", this);
  // Receive the Environment config
  if(!uvm_config_db#(environment_config)::get(this,"","env_cfg",env_cfg)) begin
    `uvm_fatal(get_type_name(), "***** Did not Get the Environment Config at Environment*****")
  end
  else `uvm_info(get_type_name(), "***** Got the Environment Config at Environment *****", UVM_NONE)
  if(env_cfg.has_functional_coverage) begin
    axi_cov = axi_coverage::type_id::create("axi_cov", this);
  end
endfunction

// -------------------------------- //
// -------- Connect Phase --------- //
// -------------------------------- //

function void environment::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "***** AXI Environment : Inside Connect Phase *****", UVM_NONE);
  axi_agnt.axi_mntr.analysis_port_mntr2pred.connect(axi_pred.mntr2pred_fifo.analysis_export); // Monitor to Predictor // Process Items
  axi_pred.analysis_port_pred2scb.connect(axi_scb.analysis_imp_pred2scb); // Predictor to Scoreboard // Expected Items
  axi_agnt.axi_mntr.analysis_port_mntr2scb.connect(axi_scb.analysis_imp_mntr2scb); // Monitor   to Scoreboard // Reset Items & Actual Items
  if(env_cfg.has_functional_coverage) begin
    axi_agnt.axi_mntr.analysis_port_mntr2cov.connect(axi_cov.analysis_export); // Monitor to Coverage // Reset/Actual/Expected Items
  end
endfunction 	



