`include "uvm_macros.svh"
import uvm_pkg::*;


class agent extends uvm_agent;
  
  `uvm_component_utils(agent)
  
  	function new(string name="agent", uvm_component parent= null);
    	super.new(name, parent);
      	`uvm_info(get_type_name(),"---- AHB Agent Constructed ----", UVM_LOW);
  	endfunction
   
  	driver ahb_drvr;
  	monitor ahb_mntr;
    ahb_sequencer ahb_seqr;
  	agent_config agnt_config;
  	ahb_coverage ahb_cov;
  
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
        `uvm_info(get_type_name(), "AHB Agent 'Build Phase' Started", UVM_HIGH);
     // 	if(!uvm_config_db#(agent_config)::get(this,"","agent_cfg",agnt_config)) begin
        //	`uvm_fatal(get_type_name(), "Did not get Agent Config")
      //  end
     //   else $display("Got Agent Config");
      	
     // 	if(agnt_config.status == UVM_ACTIVE ) begin
     //       $display("Active Agent");
        	ahb_drvr = driver::type_id::create("ahb_drvr", this);
        	ahb_mntr = monitor::type_id::create("ahb_mntr", this);
      //  end
    //  	else begin
       //   $display("Passive Agent");
        //  ahb_mntr = monitor::type_id::create("ahb_mntr", this);
      //  end
        ahb_seqr = ahb_sequencer::type_id::create("ahb_seqr", this);
      	ahb_cov = ahb_coverage::type_id::create("ahb_cov", this);
  	endfunction

  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
        ahb_drvr.seq_item_port.connect(ahb_seqr.seq_item_export);
      ahb_mntr.analysis_port_cov.connect(ahb_cov.analysis_imp_cov);
      	
        `uvm_info(get_type_name(),"AHB Agent 'Connect Phase' Started", UVM_HIGH);
	endfunction

endclass
