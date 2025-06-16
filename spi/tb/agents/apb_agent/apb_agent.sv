class apb_agent extends uvm_agent;
  
    // Factory Registration
    `uvm_component_utils(apb_agent)
    
    // Constructor Function
    function new(string name="apb_agent", uvm_component parent= null);
        super.new(name, parent);
    	`uvm_info(get_type_name(),"---- APB Agent Constructed ----", UVM_LOW);
    endfunction

    // Driver, Monitor, Sequencer, Agent Config, Coverage & Interface instances
    virtual apb_interface apb_intf;
    apb_driver  apb_drvr;
    apb_monitor apb_mntr;
    apb_agent_config apb_agnt_cfg;
    apb_sequencer apb_seqr;
  
  	// ------ Interrupt Handling ----------//
  	uvm_event apb_tx_done;

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "APB Agent 'Build Phase' Started", UVM_HIGH);

      	if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_interface", apb_intf)) begin
            `uvm_fatal(get_type_name(), "Did not get the virtual interface at APB Agent")
        end
        else `uvm_info(get_type_name(), "Got the virtual interface at APB Agent", UVM_MEDIUM)

        if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agnt_cfg",apb_agnt_cfg)) begin
            `uvm_fatal(get_type_name(), "Did not get the Agent Config")
        end
        else `uvm_info(get_type_name(), "Got the Agent Config", UVM_MEDIUM);
        
		//---------------- Interrupt Handling -------------------//
		if(!uvm_config_db#(uvm_event)::get(this,"","apb_tx_done",apb_tx_done)) begin
			`uvm_fatal(get_type_name(), "Did not get the APB Interrupt Event")
		end
		else `uvm_info(get_type_name(), "Got the APB Interrupt Event", UVM_MEDIUM);  
     
        if(apb_agnt_cfg.status == UVM_ACTIVE ) begin
            `uvm_info(get_type_name(), "APB: Active Agent :: Constructing Driver & Monitor", UVM_MEDIUM);
            apb_drvr = apb_driver::type_id::create("apb_drvr", this);
            apb_mntr = apb_monitor::type_id::create("apb_mntr", this);
            apb_drvr.apb_intf = apb_intf;
            apb_mntr.apb_intf = apb_intf;
          	apb_mntr.apb_tx_done = apb_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "APB: Passive Agent :: Constructing Monitor", UVM_MEDIUM);
            apb_mntr = apb_monitor::type_id::create("apb_mntr", this);
            apb_mntr.apb_intf = apb_intf;
        end
        apb_seqr = apb_sequencer::type_id::create("apb_seqr", this);
    endfunction
    
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
      	`uvm_info(get_type_name(),"APB Agent 'Connect Phase' Started", UVM_HIGH);
        apb_drvr.seq_item_port.connect(apb_seqr.seq_item_export);
    endfunction

   
endclass

