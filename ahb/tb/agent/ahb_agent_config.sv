class ahb_agent_config extends uvm_object;

    `uvm_object_utils( ahb_agent_config )
    function new(string name = "ahb_agent_config");
        super.new(name);
        `uvm_info(get_type_name(), "==== AHB 'Agent Config' Constructed ====", UVM_MEDIUM)
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;


endclass
