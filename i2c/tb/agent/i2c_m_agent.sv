class i2c_m_agent extends uvm_agent;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_agent)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  virtual i2c_m_interface i2c_vif;
  i2c_m_agent_config i2c_m_agnt_cfg;
  i2c_m_driver i2c_m_drvr;
  i2c_m_monitor i2c_m_mntr;
  i2c_m_sequencer i2c_m_seqr;

  // -------------------------------- //
  // ----- Methods of AXI Agent ----- //
  // -------------------------------- //
  extern function new(string name = "i2c_m_agent", uvm_component parent=null);	
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_agent::new(string name = "i2c_m_agent", uvm_component parent=null);
  super.new(name, parent);
  `uvm_info(get_full_name(), "***** I2C Slave Agent Constructed *****", UVM_NONE);
endfunction


// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void i2c_m_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** I2C Slave Agent : Inside Build Phase *****", UVM_NONE);	      		
  // ------ Get I2C Slave Interface ----//
  if (!uvm_config_db#(virtual i2c_m_interface)::get(this, "", "i2c_m_interface", i2c_vif)) begin
    `uvm_fatal(get_type_name(), "***** Did not get the I2C Slave Virtual Interface at AXI Agent *****")
  end
  else `uvm_info(get_type_name(), "***** Got the I2C Slave Virtual Interface at AXI Agent *****", UVM_NONE)
	
  // ------ Get I2C Slave Agent Config ------//
  if(!uvm_config_db#(i2c_m_agent_config)::get(this, "", "i2c_m_agnt_cfg", i2c_m_agnt_cfg)) begin
    `uvm_fatal(get_type_name(), "***** Did not get the I2C Slave Agent Config at I2C Slave Agent *****")
  end
  else `uvm_info(get_type_name(), "***** Got the I2C Slave Agent Config at I2C Slave Agent *****", UVM_NONE);
    
  //---- Construct driver, Monitor ---//
  if(i2c_m_agnt_cfg.status == UVM_ACTIVE) begin
    `uvm_info(get_type_name(), "***** I2C Slave Active Agent : Constructing driver & Monitor *****", UVM_NONE);
    i2c_m_drvr = i2c_m_driver::type_id::create("i2c_m_drvr", this);
    i2c_m_drvr.i2c_vif = i2c_vif;
    i2c_m_drvr.i2c_m_agnt_cfg = i2c_m_agnt_cfg;
    i2c_m_mntr = i2c_m_monitor::type_id::create("i2c_m_mntr", this);
    i2c_m_mntr.i2c_vif = i2c_vif;
    i2c_m_mntr.i2c_m_agnt_cfg = i2c_m_agnt_cfg;    
  end
  else begin
    `uvm_info(get_type_name(), "***** I2C Slave Passive Agent : Constructing Monitor *****", UVM_NONE); 
    i2c_m_mntr = i2c_m_monitor::type_id::create("i2c_m_mntr", this);
    i2c_m_mntr.i2c_vif = i2c_vif;
  end
    
  //--- Construct Sequencer
  i2c_m_seqr = i2c_m_sequencer::type_id::create("i2c_m_seqr", this);
    
endfunction
  
  
// -------------------------------- //
// -------- Connect Phase --------- //
// -------------------------------- //

function void i2c_m_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info(get_type_name(), "***** AXI Agent : Inside Connect Phase *****", UVM_NONE);
  //---- Connect AXI driver & Sequencer ----//
  i2c_m_drvr.seq_item_port.connect(i2c_m_seqr.seq_item_export);  
endfunction




