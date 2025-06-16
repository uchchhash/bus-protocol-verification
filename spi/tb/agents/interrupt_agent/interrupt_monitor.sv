class interrupt_monitor extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(interrupt_monitor)

    // Required Instances
    virtual interrupt_interface intr_intf;
    apb_sequence_item intr_item;
    uvm_analysis_port #(apb_sequence_item) analysis_port_INTRmntrAP; 
   
    // Constructor
    function new(string name = "interrupt_monitor", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "===== Interrupt Monitor Constructed =====", UVM_LOW)
    endfunction


    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "===== Interrupt Monitor Build Phase Started =====", UVM_LOW)
         analysis_port_INTRmntrAP = new("analysis_port_INTRmntrAP", this);
    endfunction
 

     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            `uvm_info(get_type_name(), "===== Interrupt Monitor Run Phalse Started  =====", UVM_HIGH)
        	@(negedge intr_intf.PCLK);
        	intr_item = apb_sequence_item::type_id::create("intr_item", this);
        	intr_item.IRQ = intr_intf.IRQ;
        	analysis_port_INTRmntrAP.write(intr_item);
        	`uvm_info(get_type_name(), "===== Interrupt Monitor Run Phase Finished =====", UVM_HIGH)      
        end
    endtask



endclass
