class environment extends uvm_env;
  
    `uvm_component_utils(environment)


    function new(string name = "environment", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name, "==== Environment Constructed ====", UVM_MEDIUM)
    endfunction

    // Agent, Scoreboard, Environment Config instances
    ahb_agent ahb_agnt;
    
    scoreboard scb;
    environment_config env_cfg;
    ahb_predictor ahb_pred;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name, "Environment 'Build Phase' Started", UVM_MEDIUM)
        ahb_agnt= ahb_agent::type_id::create("ahb_agnt", this);
        ahb_pred = ahb_predictor::type_id::create("ahb_pred", this);
        if(!uvm_config_db#(environment_config)::get(this,"","env_cfg",env_cfg)) begin
            `uvm_fatal(get_type_name(), "Did not get the Environment Config")
        end
        else `uvm_info(get_type_name(), "Got the Environment Config", UVM_MEDIUM)
    	if(env_cfg.has_scoreboard == 1) begin
        	scb = scoreboard::type_id::create("scb", this);
       end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name, "Environment 'Connect Phase' Started", UVM_MEDIUM)
        ahb_agnt.ahb_mntr.analysis_port_mntr2pred.connect(ahb_pred.analysis_imp_mntr2pred); // Monitor to Predictor
        ahb_agnt.ahb_mntr.analysis_port_mntr2scb.connect(scb.analysis_imp_mntr2scb);        // Monitor to Scoreboard
        ahb_pred.analysis_port_pred2scb.connect(scb.analysis_imp_pred2scb);                 // Predictor to Scoreboard
        /*
        // monitor to scoreboard tlm interfaces
        ahb_agnt.ahb_mntr.mntr2scb_putport.connect(scb.mntr2scb_putimp);
        ahb_agnt.ahb_mntr.mntr2scb_putport_b.connect(scb.mntr2scb_putimp_b);
        ahb_agnt.ahb_mntr.mntr2scb_putport_nb.connect(scb.mntr2scb_putimp_nb);
        */
    endfunction


  
endclass
