class interrupt_agent_config extends uvm_object;

	// Factory Registration
	`uvm_object_utils(interrupt_agent_config)

	// Constructor Function
    function new(string name = "interrupt_agent_config");
        super.new(name);
        `uvm_info(get_type_name(), "==== Interrupt 'Agent Config' Constructed ====", UVM_MEDIUM)
    endfunction

    uvm_active_passive_enum status = UVM_PASSIVE;  
    
    event tx_done; // Identify SPI transfer done

    
    
    
endclass
