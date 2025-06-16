class axi_agent extends uvm_agent;

	// -------------------------------- //
	// ----- Factory Registration ----- //
	// -------------------------------- //
        `uvm_component_utils(axi_agent)

	// -------------------------------- //
	// ------ Component Members  ------ //
	// -------------------------------- //
	virtual axi_interface axi_vif;
	axi_agent_config axi_agnt_cfg;
	axi_driver axi_drvr;
	axi_monitor axi_mntr;
	axi_sequencer axi_seqr;
	//axi_slave axi_bfm;

	// -------------------------------- //
	// ----- Methods of AXI Agent ----- //
	// -------------------------------- //
  extern function new(string name = "axi_agent", uvm_component parent=null);	
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

      function axi_agent::new(string name = "axi_agent", uvm_component parent=null);
  super.new(name, parent);
  `uvm_info(get_full_name(), "***** AXI Agent Constructed . . . . . . . . . . . . . . . . . . . . . . . *****", UVM_NONE);
endfunction


      
// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void axi_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "***** AXI Agent : Inside Build Phase *****", UVM_NONE);	      	
	
	// ------ Get AXI Interface ----//
	if (!uvm_config_db#(virtual axi_interface)::get(this, "", "axi_interface", axi_vif)) begin
		`uvm_fatal(get_type_name(), "***** Did not get the AXI Virtual Interface at AXI Agent *****")
	end
	else `uvm_info(get_type_name(), "***** Got the AXI Virtual Interface at AXI Agent *****", UVM_NONE)
	
	// ------ Get AXI Agent Config ------//
    if(!uvm_config_db#(axi_agent_config)::get(this, "", "axi_agnt_cfg", axi_agnt_cfg)) begin
        `uvm_fatal(get_type_name(), "***** Did not get the AXI Agent Config at AXI Agent *****")
    end
    else `uvm_info(get_type_name(), "***** Got the AXI Agent Config at AXI Agent *****", UVM_NONE);    

    
    //---- Construct driver2, Monitor
    if(axi_agnt_cfg.status == UVM_ACTIVE) begin
        `uvm_info(get_type_name(), "***** AXI Active Agent : Constructing driver2 & Monitor *****", UVM_NONE);
        axi_drvr = axi_driver::type_id::create("axi_drvr", this);
        axi_drvr.axi_vif = axi_vif;		
		
        axi_mntr = axi_monitor::type_id::create("axi_mntr", this);
        axi_mntr.axi_vif = axi_vif;
        //axi_bfm = axi_slave::type_id::create("axi_bfm", this);
        //axi_bfm.axi_intf = axi_vif;
    end
    else begin
		`uvm_info(get_type_name(), "***** AXI Passive Agent : Constructing Monitor *****", UVM_NONE); 
		axi_mntr = axi_monitor::type_id::create("axi_mntr", this);
		axi_mntr.axi_vif = axi_vif;
    end
    
    //--- Construct Sequencer
    axi_seqr = axi_sequencer::type_id::create("axi_seqr", this);
    
    // Printing the type of the object pointing to the "axi_drvr2" class handle
    `uvm_info(get_type_name(), $sformatf(" ----------------->> Factory Retured driver of type = %s , path = %s", axi_drvr.get_type_name(), axi_drvr.get_full_name()), UVM_MEDIUM)
    

endfunction
  
  
// -------------------------------- //
// -------- Connect Phase --------- //
// -------------------------------- //



function void axi_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info(get_type_name(), "***** AXI Agent : Inside Connect Phase *****", UVM_NONE);
	//---- Connect AXI driver & Sequencer
	axi_drvr.seq_item_port.connect(axi_seqr.seq_item_export);  

endfunction



