class environment extends uvm_env;

    // Factory Registration
    `uvm_component_utils(environment)   
     
    // Environment Config, Scoreboard instances
    environment_config env_cfg;
    scoreboard scb;
    
    // UVM RAL Block, Adapter, Predictor
    spi_reg_block spi_rb;
    apb2reg_adapter apb2reg_adptr;
    uvm_reg_predictor#(apb_sequence_item) apb2reg_pred;
    
    // APB & SPI Agent instances
    apb_agent apb_agnt;
    spi_agent0 spi_agnt0;
    spi_agent1 spi_agnt1;
    spi_agent2 spi_agnt2;
    spi_agent3 spi_agnt3;
    spi_agent4 spi_agnt4;
    spi_agent5 spi_agnt5;
    spi_agent6 spi_agnt6;    
    spi_agent7 spi_agnt7; 
    
    // Interrupt
    interrupt_agent intr_agnt;
    interrupt_predictor intr_pred;
    
    // events for interrupt handling
    uvm_event_pool interrupt_pool;
    uvm_event apb_tx_done; // indicate apb transfer finish
    uvm_event spi_tx_done; // indicate spi transfer finish
    
    // Coverage
    spi_coverage spi_cov;

    // Constructor Function
    function new(string name = "environment", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== APB-SPI Environment Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== APB-SPI Environment Build Phase Started =====", UVM_MEDIUM)    
        
        // Create the Agents
        intr_agnt = interrupt_agent::type_id::create("intr_agnt", this);
        apb_agnt = apb_agent::type_id::create("apb_agnt", this);
        spi_agnt0 = spi_agent0::type_id::create("spi_agnt0", this);
        spi_agnt1 = spi_agent1::type_id::create("spi_agnt1", this);
        spi_agnt2 = spi_agent2::type_id::create("spi_agnt2", this);      
        spi_agnt3 = spi_agent3::type_id::create("spi_agnt3", this);      
        spi_agnt4 = spi_agent4::type_id::create("spi_agnt4", this);
        spi_agnt5 = spi_agent5::type_id::create("spi_agnt5", this);       
        spi_agnt6 = spi_agent6::type_id::create("spi_agnt6", this);               
        spi_agnt7 = spi_agent7::type_id::create("spi_agnt7", this);
        
        // Receive the Environment config
        if(!uvm_config_db#(environment_config)::get(this,"","env_cfg",env_cfg)) begin
            `uvm_fatal(get_type_name(), "Did not get the Environment Config")
        end
        else `uvm_info(get_type_name(), "Got the Environment Config", UVM_MEDIUM) 
        
        // Create RAL Block/Adapter/Predictor
        uvm_reg::include_coverage("*", UVM_CVR_ALL);
        spi_rb = spi_reg_block::type_id::create("spi_rb");
        spi_rb.build();
        apb2reg_adptr = apb2reg_adapter::type_id::create("apb2reg_adptr");
        apb2reg_pred = uvm_reg_predictor#(apb_sequence_item)::type_id::create("apb2reg_pred", this);
		
		// Scoreboard
        if(env_cfg.has_scoreboard == 1) begin
          scb = scoreboard::type_id::create("scb", this);
          scb.spi_rb = spi_rb; // Send Reg Block handle to scb
        end
        
        // Interrupt Predictor
        intr_pred = interrupt_predictor::type_id::create("intr_pred", this);
        
		//---------------- Interrupt handling ----------------//
		apb_tx_done = new("apb_tx_done");
		spi_tx_done = new("spi_tx_done");

		// Send apb_tx_done & spi_tx_done events to apb agent and spi agent
		uvm_config_db#(uvm_event)::set(this, "apb_agnt", "apb_tx_done", apb_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt0", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt1", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt2", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt3", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt4", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt5", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt6", "spi_tx_done", spi_tx_done);
		uvm_config_db#(uvm_event)::set(this, "spi_agnt7", "spi_tx_done", spi_tx_done);


		// Send apb_tx_done & spi_tx_done events to interrupt predictor
		uvm_config_db#(uvm_event)::set(this, "intr_pred", "apb_tx_done", apb_tx_done);
		uvm_config_db#(uvm_event)::set(this, "intr_pred", "spi_tx_done", spi_tx_done);
		
		// Coverage
        if(env_cfg.has_functional_coverage == 1) begin
			spi_cov = spi_coverage::type_id::create("spi_cov", this);
			spi_cov.spi_rb = spi_rb;
        end		
		
      
    endfunction
    
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("get_type_name", "===== APB-SPI Environment Connect Phase Started =====", UVM_MEDIUM)
        if(spi_rb.get_parent() == null) begin
            //----- Set Register Sequence Layer -----//
            spi_rb.spi_reg_block_map.set_sequencer(apb_agnt.apb_seqr, apb2reg_adptr);
            //----- Set Predictor Map -----//
            apb2reg_pred.map = spi_rb.spi_reg_block_map;
            //----- Set Predictor Adapter -----//
            apb2reg_pred.adapter = apb2reg_adptr;
            //----- Set Predictor Type -----//
           spi_rb.spi_reg_block_map.set_auto_predict(0);
           //----- Connect Predictor to APB monitor analysis port -----//
           apb_agnt.apb_mntr.analysis_port_APBmntrAP.connect(apb2reg_pred.bus_in);
        end
 		
 		// Connect SPI Monitors with Scoreboard
 		spi_agnt0.spi_mntr0.analysis_port_SPImntrAP0.connect(scb.spi_fifo.analysis_export); 
		spi_agnt1.spi_mntr1.analysis_port_SPImntrAP1.connect(scb.spi_fifo.analysis_export); 
		spi_agnt2.spi_mntr2.analysis_port_SPImntrAP2.connect(scb.spi_fifo.analysis_export); 
		spi_agnt3.spi_mntr3.analysis_port_SPImntrAP3.connect(scb.spi_fifo.analysis_export); 
		spi_agnt4.spi_mntr4.analysis_port_SPImntrAP4.connect(scb.spi_fifo.analysis_export); 
		spi_agnt5.spi_mntr5.analysis_port_SPImntrAP5.connect(scb.spi_fifo.analysis_export); 		
		spi_agnt6.spi_mntr6.analysis_port_SPImntrAP6.connect(scb.spi_fifo.analysis_export); 
		spi_agnt7.spi_mntr7.analysis_port_SPImntrAP7.connect(scb.spi_fifo.analysis_export);   
        
 		// Connect Register Predictor with Scoreboard
        apb2reg_pred.reg_ap.connect(scb.analysis_imp_SPIregAP);
        
        // Connect APB Monitor with Interrupt Predictor
        apb_agnt.apb_mntr.analysis_port_APBmntrAP.connect(intr_pred.analysis_imp_APBmntrAP);
        
        // Connect Interrupt Predictor with Scoreboard
        intr_pred.analysis_port_INTRpredAP.connect(scb.analysis_imp_INTRpredAP);
        
        // Connect Interrupt Monitor with Scoreboard
        intr_agnt.intr_mntr.analysis_port_INTRmntrAP.connect(scb.analysis_imp_INTRmntrAP);
            
 		// Coverage
        if(env_cfg.has_functional_coverage == 1) begin
        	apb_agnt.apb_mntr.analysis_port_APBmntr2covAP.connect(spi_cov.analysis_export); // apb monitor to coverage
        	intr_agnt.intr_mntr.analysis_port_INTRmntrAP.connect(spi_cov.analysis_export);  // interrupt monitor to coverage
        end	           
            
            
    endfunction
    
endclass







