class interrupt_agent extends uvm_agent;

    // Factory Registration
    `uvm_component_utils(interrupt_agent)
  	
    // Constructor Function
    function new(string name="interrupt_agent", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== Interrupt Agent Constructed =====", UVM_LOW)
    endfunction

	// Required Instances
	virtual interrupt_interface intr_intf;
	interrupt_agent_config intr_agnt_cfg;
	interrupt_monitor intr_mntr;

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== Interrupt Agent Build Phase Started =====", UVM_MEDIUM)
        
        // Get Virtual Interface from Config Database
        if (!uvm_config_db#(virtual interrupt_interface)::get(this, "", "interrupt_interface", intr_intf)) begin
            `uvm_fatal(get_type_name(), "Did not get the virtual interface at Interrupt Agent")
        end
        else `uvm_info(get_type_name(), "Got the virtual interface at Interrupt Agent", UVM_MEDIUM)

        if(!uvm_config_db#(interrupt_agent_config)::get(this,"","intr_agnt_cfg", intr_agnt_cfg)) begin
            `uvm_fatal(get_type_name(), "Did not get the Interrupt Agent Config")
        end
        else `uvm_info(get_type_name(), "Got the Interrupt Agent Config", UVM_MEDIUM);

		// Create Interrupt Monitor and send the interface
		intr_mntr = interrupt_monitor::type_id::create("intr_mntr", this);
		intr_mntr.intr_intf = intr_intf;
    endfunction

  
endclass

