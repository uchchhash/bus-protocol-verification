`include "uvm_macros.svh"
import uvm_pkg::*;

// Intermediate container to hold driver, monitor and sequencer
class agent extends uvm_agent;
  
  `uvm_component_utils(agent)
  
  	function new(string name="agent", uvm_component parent= null);
    	super.new(name, parent);
    	`uvm_info(get_type_name(),"---- APB Agent Constructed ----", UVM_HIGH);
  	endfunction
  
  	// Driver , Monitor , Sequence_Item Instances  
  	driver apb_drvr;
  	monitor apb_mntr;
    apb_sequencer apb_seqr;
    agent_config agnt_config;
    apb_coverage apb_cov;
  
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	`uvm_info(get_type_name(), "APB Agent 'Build Phase' Started", UVM_HIGH);	
        	
        if (!uvm_config_db#(agent_config)::get(this,"","agent_cfg",agnt_config)) begin
        	`uvm_fatal(get_type_name(), "Did not get Agent Config")
        end
        else $display("Got Agent Config");
        
        
        if (agnt_config.status == UVM_ACTIVE ) begin
            $display("Active Agent");
    		apb_drvr = driver::type_id::create("apb_drvr", this);
    		apb_mntr = monitor::type_id::create("apb_mntr", this);
        end
        else begin
            $display("Passive Agent");
        	apb_mntr = monitor::type_id::create("apb_mntr", this);
        end
    	// Create sequencer
    	apb_seqr = apb_sequencer::type_id::create("apb_seqr", this);
    	apb_cov = apb_coverage::type_id::create("apb_cov", this);
    	
  	endfunction
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
	 	apb_drvr.seq_item_port.connect(apb_seqr.seq_item_export);
	    apb_mntr.analysis_port_cov.connect(apb_cov.analysis_imp_cov);
        `uvm_info(get_type_name(),"APB Agent 'Connect Phase' Started", UVM_HIGH);
	endfunction

endclass
