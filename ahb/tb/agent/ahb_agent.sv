class ahb_agent extends uvm_agent;

    `uvm_component_utils(ahb_agent)


    function new(string name = "ahb_agent", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "==== AHB Agent Constructed ====", UVM_MEDIUM);
    endfunction

    // Driver, Monitor, Sequencer, Agent Config, Coverage & Interface instances
    ahb_driver ahb_drvr;
    ahb_monitor ahb_mntr;
    ahb_agent_config ahb_agnt_cfg;
    ahb_sequencer ahb_seqr;
    ahb_coverage ahb_cov;
    virtual ahb_interface ahb_intf;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "AHB Agent Build Phase Constructed", UVM_MEDIUM);

      	if (!uvm_config_db#(virtual ahb_interface)::get(this, "", "ahb_interface", ahb_intf))
			`uvm_fatal(get_type_name(), "Did not get the virtual interface at AHB Agent")
        else `uvm_info(get_type_name(), "Got the virtual interface at AHB Agent", UVM_MEDIUM)

        if(!uvm_config_db#(ahb_agent_config)::get(this,"","ahb_agnt_cfg",ahb_agnt_cfg)) begin
            `uvm_fatal(get_type_name(), "Did not get the Agent Config")
        end
        else `uvm_info(get_type_name(), "Got the Agent Config", UVM_MEDIUM);


        // Active Agent: Constructing Driver and Monitor
        // Sending virtual interface instance to them
        if(ahb_agnt_cfg.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "AHB: Active Agent :: Constructing Driver & Monitor", UVM_MEDIUM);
            ahb_drvr = ahb_driver::type_id::create("ahb_drvr", this);
            ahb_mntr = ahb_monitor:: type_id::create("ahb_mntr", this);
            ahb_drvr.ahb_intf = ahb_intf;
            ahb_mntr.ahb_intf = ahb_intf;     
        end

        // Passive Agent: Constructing Monitor
        // Sending virtual interface instance to monitor
        else begin
            `uvm_info(get_type_name(), "AHB: Passive Agent:: Constructing Monitor", UVM_MEDIUM);
            ahb_mntr = ahb_monitor::type_id::create("ahb_mntr", this);
            ahb_mntr.ahb_intf = ahb_intf;
        end
        ahb_seqr = ahb_sequencer::type_id::create("ahb_seqr", this);
        ahb_cov  = ahb_coverage::type_id::create("ahb_cov", this);
    endfunction


    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "AHB Agent 'Connect Phase' Constructed", UVM_MEDIUM)
        ahb_drvr.seq_item_port.connect(ahb_seqr.seq_item_export);
    endfunction

endclass
