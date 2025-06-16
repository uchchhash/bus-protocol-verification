//----------------------- SPI Agent for SS line 0 ------------------------------//
class spi_agent0 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent0)
  	
    // Constructor Function
    function new(string name="spi_agent0", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-0 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif0;
    spi_monitor0 spi_mntr0;
    spi_driver0 spi_drvr0;
    spi_agent_config0 spi_agnt_cfg0;
    spi_sequencer0 spi_seqr0;
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-0 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif0)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-0 at SPI Agent-0", UVM_LOW)


		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config0)::get(this, "", "spi_agnt_cfg0", spi_agnt_cfg0)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config0")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config0", UVM_MEDIUM);
        
        
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
           
        if(spi_agnt_cfg0.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-0 :: Constructing Driver-0 & Monitor-0", UVM_MEDIUM)
            spi_drvr0 = spi_driver0::type_id::create("spi_drvr0", this);
            spi_mntr0  = spi_monitor0::type_id::create("spi_mntr0", this);
            spi_drvr0.spi_vif0 = spi_vif0;  
            spi_mntr0.spi_vif0 = spi_vif0;
            spi_drvr0.spi_agnt_cfg0 = spi_agnt_cfg0;         
            spi_mntr0.spi_agnt_cfg0 = spi_agnt_cfg0;
          	spi_mntr0.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-0 :: Constructing Monitor-0", UVM_MEDIUM);
            spi_mntr0 = spi_monitor0::type_id::create("spi_mntr0", this);
            spi_mntr0.spi_vif0 = spi_vif0;
            spi_mntr0.spi_agnt_cfg0 = spi_agnt_cfg0;
          	spi_mntr0.spi_tx_done = spi_tx_done;
        end
        spi_seqr0 = spi_sequencer0::type_id::create("spi_seqr0", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr0.seq_item_port.connect(spi_seqr0.seq_item_export); 
    endfunction
  
endclass



//----------------------- SPI Agent for SS line 1 ------------------------------//
class spi_agent1 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent1)
  	
    // Constructor Function
    function new(string name="spi_agent1", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-1 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif1;
    spi_monitor1 spi_mntr1;
    spi_driver1 spi_drvr1;
    spi_agent_config1 spi_agnt_cfg1;
    spi_sequencer1 spi_seqr1;
   	// interrupt
  	uvm_event spi_tx_done; 
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-1 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif1)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-1 at SPI Agent-1", UVM_LOW)

		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config1)::get(this, "", "spi_agnt_cfg1", spi_agnt_cfg1)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config1")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config1", UVM_MEDIUM);
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
          
        if(spi_agnt_cfg1.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-1 :: Constructing Driver-1 & Monitor-1", UVM_MEDIUM)
            spi_drvr1 = spi_driver1::type_id::create("spi_drvr1", this);
            spi_mntr1  = spi_monitor1::type_id::create("spi_mntr1", this);
            spi_drvr1.spi_vif1 = spi_vif1;
            spi_drvr1.spi_agnt_cfg1 = spi_agnt_cfg1;       
            spi_mntr1.spi_vif1 = spi_vif1;
            spi_mntr1.spi_agnt_cfg1 = spi_agnt_cfg1;
          	spi_mntr1.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-1 :: Constructing Monitor-1", UVM_MEDIUM);
            spi_mntr1 = spi_monitor1::type_id::create("spi_mntr1", this);
            spi_mntr1.spi_vif1 = spi_vif1;
            spi_mntr1.spi_agnt_cfg1 = spi_agnt_cfg1;
          	spi_mntr1.spi_tx_done = spi_tx_done;
        end
        spi_seqr1 = spi_sequencer1::type_id::create("spi_seqr1", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr1.seq_item_port.connect(spi_seqr1.seq_item_export); 
    endfunction
  
endclass




//----------------------- SPI Agent for SS line 2 ------------------------------//
class spi_agent2 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent2)
  	
    // Constructor Function
    function new(string name="spi_agent2", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-2 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif2;
    spi_monitor2 spi_mntr2;
    spi_driver2 spi_drvr2;
    spi_agent_config2 spi_agnt_cfg2;
    spi_sequencer2 spi_seqr2;
   	// interrupt
  	uvm_event spi_tx_done; 
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-2 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif2)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-2 at SPI Agent-2", UVM_LOW)

		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config2)::get(this, "", "spi_agnt_cfg2", spi_agnt_cfg2)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config2")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config2", UVM_MEDIUM);
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
         
        if(spi_agnt_cfg2.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-2 :: Constructing Driver-2 & Monitor-2", UVM_MEDIUM)
            spi_drvr2 = spi_driver2::type_id::create("spi_drvr2", this);
            spi_mntr2  = spi_monitor2::type_id::create("spi_mntr2", this);
            spi_drvr2.spi_vif2 = spi_vif2;
            spi_drvr2.spi_agnt_cfg2 = spi_agnt_cfg2;        
            spi_mntr2.spi_vif2 = spi_vif2;
            spi_mntr2.spi_agnt_cfg2 = spi_agnt_cfg2;
          	spi_mntr2.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-2 :: Constructing Monitor-2", UVM_MEDIUM);
            spi_mntr2 = spi_monitor2::type_id::create("spi_mntr2", this);
            spi_mntr2.spi_vif2 = spi_vif2;
            spi_mntr2.spi_agnt_cfg2 = spi_agnt_cfg2;
          	spi_mntr2.spi_tx_done = spi_tx_done;
        end
        spi_seqr2 = spi_sequencer2::type_id::create("spi_seqr2", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr2.seq_item_port.connect(spi_seqr2.seq_item_export); 
    endfunction
  
endclass




//----------------------- SPI Agent for SS line 3 ------------------------------//
class spi_agent3 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent3)
  	
    // Constructor Function
    function new(string name="spi_agent3", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-3 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif3;
    spi_monitor3 spi_mntr3;
    spi_driver3 spi_drvr3;
    spi_agent_config3 spi_agnt_cfg3;
    spi_sequencer3 spi_seqr3;
  	// interrupt
  	uvm_event spi_tx_done;  
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-3 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif3)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-3 at SPI Agent-3", UVM_LOW)
      
		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config3)::get(this, "", "spi_agnt_cfg3", spi_agnt_cfg3)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config3")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config3", UVM_MEDIUM);
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
         
        if(spi_agnt_cfg3.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-3 :: Constructing Driver-3 & Monitor-3", UVM_MEDIUM)
            spi_drvr3 = spi_driver3::type_id::create("spi_drvr3", this);
            spi_mntr3  = spi_monitor3::type_id::create("spi_mntr3", this);
            spi_drvr3.spi_vif3 = spi_vif3;
            spi_drvr3.spi_agnt_cfg3 = spi_agnt_cfg3;       
            spi_mntr3.spi_vif3 = spi_vif3;
            spi_mntr3.spi_agnt_cfg3 = spi_agnt_cfg3;
          	spi_mntr3.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-3 :: Constructing Monitor-3", UVM_MEDIUM);
            spi_mntr3 = spi_monitor3::type_id::create("spi_mntr3", this);
            spi_mntr3.spi_vif3 = spi_vif3;
            spi_mntr3.spi_agnt_cfg3 = spi_agnt_cfg3;
          	spi_mntr3.spi_tx_done = spi_tx_done;
        end
        spi_seqr3 = spi_sequencer3::type_id::create("spi_seqr3", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr3.seq_item_port.connect(spi_seqr3.seq_item_export); 
    endfunction
  
endclass



//----------------------- SPI Agent for SS line 4 ------------------------------//
class spi_agent4 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent4)
  	
    // Constructor Function
    function new(string name="spi_agent4", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-4 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif4;
    spi_monitor4 spi_mntr4;
    spi_driver4 spi_drvr4;
    spi_agent_config4 spi_agnt_cfg4;
    spi_sequencer4 spi_seqr4;
  	// interrupt
  	uvm_event spi_tx_done;  
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-4 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif4)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-4 at SPI Agent-4", UVM_LOW)
      	

		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config4)::get(this, "", "spi_agnt_cfg4", spi_agnt_cfg4)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config4")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config4", UVM_MEDIUM);
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
         
        if(spi_agnt_cfg4.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-4 :: Constructing Driver-4 & Monitor-4", UVM_MEDIUM)
            spi_drvr4 = spi_driver4::type_id::create("spi_drvr4", this);
            spi_mntr4  = spi_monitor4::type_id::create("spi_mntr4", this);
            spi_drvr4.spi_vif4 = spi_vif4;  
            spi_drvr4.spi_agnt_cfg4 = spi_agnt_cfg4;         
            spi_mntr4.spi_vif4 = spi_vif4;
            spi_mntr4.spi_agnt_cfg4 = spi_agnt_cfg4;
          	spi_mntr4.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-4 :: Constructing Monitor-4", UVM_MEDIUM);
            spi_mntr4 = spi_monitor4::type_id::create("spi_mntr4", this);
            spi_mntr4.spi_vif4 = spi_vif4;
            spi_mntr4.spi_agnt_cfg4 = spi_agnt_cfg4;
          	spi_mntr4.spi_tx_done = spi_tx_done;
        end
        spi_seqr4 = spi_sequencer4::type_id::create("spi_seqr4", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr4.seq_item_port.connect(spi_seqr4.seq_item_export); 
    endfunction
  
endclass


//----------------------- SPI Agent for SS line 5 ------------------------------//
class spi_agent5 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent5)
  	
    // Constructor Function
    function new(string name="spi_agent5", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-5 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif5;
    spi_monitor5 spi_mntr5;
    spi_driver5 spi_drvr5;
    spi_agent_config5 spi_agnt_cfg5;
    spi_sequencer5 spi_seqr5;
   	// interrupt
  	uvm_event spi_tx_done; 
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-5 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif5)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-5 at SPI Agent-5", UVM_LOW)
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
 

		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config5)::get(this, "", "spi_agnt_cfg5", spi_agnt_cfg5)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config5")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config5", UVM_MEDIUM);
        
        if(spi_agnt_cfg5.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-5 :: Constructing Driver-5 & Monitor-5", UVM_MEDIUM)
            spi_drvr5 = spi_driver5::type_id::create("spi_drvr5", this);
            spi_mntr5  = spi_monitor5::type_id::create("spi_mntr5", this);
            spi_drvr5.spi_vif5 = spi_vif5;
            spi_drvr5.spi_agnt_cfg5 = spi_agnt_cfg5;           
            spi_mntr5.spi_vif5 = spi_vif5;
            spi_mntr5.spi_agnt_cfg5 = spi_agnt_cfg5;
          	spi_mntr5.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-5 :: Constructing Monitor-5", UVM_MEDIUM);
            spi_mntr5 = spi_monitor5::type_id::create("spi_mntr5", this);
            spi_mntr5.spi_vif5 = spi_vif5;
            spi_mntr5.spi_agnt_cfg5 = spi_agnt_cfg5;
          	spi_mntr5.spi_tx_done = spi_tx_done;
        end
        spi_seqr5 = spi_sequencer5::type_id::create("spi_seqr5", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr5.seq_item_port.connect(spi_seqr5.seq_item_export); 
    endfunction
  
endclass


//----------------------- SPI Agent for SS line 6 ------------------------------//
class spi_agent6 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent6)
  	
    // Constructor Function
    function new(string name="spi_agent6", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-6 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif6;
    spi_monitor6 spi_mntr6;
    spi_driver6 spi_drvr6;
    spi_agent_config6 spi_agnt_cfg6;
    spi_sequencer6 spi_seqr6;
   	// interrupt
  	uvm_event spi_tx_done; 
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-6 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif6)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-6 at SPI Agent-6", UVM_LOW)

		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config6)::get(this, "", "spi_agnt_cfg6", spi_agnt_cfg6)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config6")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config6", UVM_MEDIUM);
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
         
        if(spi_agnt_cfg6.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-6 :: Constructing Driver-6 & Monitor-6", UVM_MEDIUM)
            spi_drvr6 = spi_driver6::type_id::create("spi_drvr6", this);
            spi_mntr6  = spi_monitor6::type_id::create("spi_mntr6", this);
            spi_drvr6.spi_vif6 = spi_vif6;
            spi_drvr6.spi_agnt_cfg6 = spi_agnt_cfg6;           
            spi_mntr6.spi_vif6 = spi_vif6;
            spi_mntr6.spi_agnt_cfg6 = spi_agnt_cfg6;
          	spi_mntr6.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-6 :: Constructing Monitor-6", UVM_MEDIUM);
            spi_mntr6 = spi_monitor6::type_id::create("spi_mntr6", this);
            spi_mntr6.spi_vif6 = spi_vif6;
            spi_mntr6.spi_agnt_cfg6 = spi_agnt_cfg6;
          	spi_mntr6.spi_tx_done = spi_tx_done;
        end
        spi_seqr6 = spi_sequencer6::type_id::create("spi_seqr6", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr6.seq_item_port.connect(spi_seqr6.seq_item_export); 
    endfunction
  
endclass



//----------------------- SPI Agent for SS line 7 ------------------------------//
class spi_agent7 extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(spi_agent7)
  	
    // Constructor Function
    function new(string name="spi_agent7", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"---- SPI Agent-7 Constructed ----", UVM_LOW);
    endfunction

	// Required Instances
  	virtual spi_interface spi_vif7;
    spi_monitor7 spi_mntr7;
    spi_driver7 spi_drvr7;
    spi_agent_config7 spi_agnt_cfg7;
    spi_sequencer7 spi_seqr7;
   	// interrupt
  	uvm_event spi_tx_done; 
  
    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	`uvm_info(get_type_name(), "SPI Agent-7 'Build Phase' Started", UVM_MEDIUM)
      	
      	// ------ Get SPI Interface ----//
      	if (!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif7)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI virtual interface")
        end
        else `uvm_info(get_type_name(), "Got the SPI virtual interface-7 at SPI Agent-7", UVM_LOW)

		// ------ Get Agent Config ------//
        if(!uvm_config_db#(spi_agent_config7)::get(this, "", "spi_agnt_cfg7", spi_agnt_cfg7)) begin
            `uvm_fatal(get_type_name(), "Did not get SPI Agent config7")
        end
        else `uvm_info(get_type_name(), "Got the SPI Agent Config7", UVM_MEDIUM);
      
   		//---------------- Interrupt Handling -------------------//
      	if(!uvm_config_db#(uvm_event)::get(this,"","spi_tx_done", spi_tx_done)) begin
        	`uvm_fatal(get_type_name(), "Did not get the SPI interrupt event")
		end
      	else `uvm_info(get_type_name(), "Got the SPI interrupt event", UVM_MEDIUM)
          
         
        if(spi_agnt_cfg7.status == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "SPI: Active Agent-7 :: Constructing Driver-7 & Monitor-7", UVM_MEDIUM)
            spi_drvr7 = spi_driver7::type_id::create("spi_drvr7", this);
            spi_mntr7  = spi_monitor7::type_id::create("spi_mntr7", this);
            spi_drvr7.spi_vif7 = spi_vif7;
            spi_drvr7.spi_agnt_cfg7 = spi_agnt_cfg7;          
            spi_mntr7.spi_vif7 = spi_vif7;
            spi_mntr7.spi_agnt_cfg7 = spi_agnt_cfg7;
          	spi_mntr7.spi_tx_done = spi_tx_done;
        end
        else begin
            `uvm_info(get_type_name(), "SPI: Passive Agent-7 :: Constructing Monitor-7", UVM_MEDIUM);
            spi_mntr7 = spi_monitor7::type_id::create("spi_mntr7", this);
            spi_mntr7.spi_vif7 = spi_vif7;
            spi_mntr7.spi_agnt_cfg7 = spi_agnt_cfg7;
          	spi_mntr7.spi_tx_done = spi_tx_done;
        end
        spi_seqr7 = spi_sequencer7::type_id::create("spi_seqr7", this);
    endfunction
  
    // ---------- Connect Phase ----------//
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "SPI Agent 'Connect Phase' Started", UVM_HIGH);
        spi_drvr7.seq_item_port.connect(spi_seqr7.seq_item_export); 
    endfunction
  
endclass

