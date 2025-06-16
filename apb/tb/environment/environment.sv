`include "uvm_macros.svh"
import uvm_pkg::*;

// The environment is a container object simply to hold all verification components together
// This environment can then be reused later and 
// all components in it would be automatically connected 

class env extends uvm_env;
  
	`uvm_component_utils(env)
  
	function new(string name="env", uvm_component parent= null);
		super.new(name, parent);
		`uvm_info(get_type_name(),"---- APB Environment Constructed ----", UVM_HIGH);
	endfunction

	// Agent and Scoreboard Instances
	agent apb_agnt;
  	scoreboard apb_scb;
  	environment_config env_config;
  
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	`uvm_info(get_type_name(),"APB Environment'Build Phase' Started", UVM_HIGH);
    	// Create the agent and scoreboard
    	apb_agnt = agent::type_id::create("apb_agnt", this);
    	
 	    if (!uvm_config_db#(environment_config)::get(this, "", "environ_config", env_config))
        	`uvm_fatal(get_type_name(), "Did not get Environment Config")
    	//if(env_config.has_scoreboard == 1) begin
        	//apb_scb = scoreboard::type_id::create("apb_scb", this);
       // end
          apb_scb = scoreboard::type_id::create("apb_scb", this); 		
  	endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	`uvm_info(get_type_name(),"APB Environment 'Connect Phase' Started", UVM_HIGH);
    	apb_agnt.apb_drvr.analysis_port_drvr.connect(apb_scb.analysis_imp_drvr);
    	apb_agnt.apb_mntr.analysis_port_mntr.connect(apb_scb.analysis_imp_mntr);   
 
  	endfunction
  	
  	virtual task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	`uvm_info(get_type_name(),"APB Environment 'Run Phase' Started", UVM_HIGH);
    endtask

  
endclass
