class apb_agent_config extends uvm_object;

    `uvm_object_utils(apb_agent_config)
    uvm_active_passive_enum status = UVM_ACTIVE;

    
    function new(string name = "apb_agent_config");
        super.new(name);
        `uvm_info(get_type_name(), "==== APB 'Agent Config' Constructed ====", UVM_MEDIUM)
    endfunction

    event rw_done; // Identify APB transfer done

endclass
