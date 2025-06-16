class ahb_reset_sequence extends ahb_base_sequence;
	`uvm_object_utils(ahb_reset_sequence)
  
  	function new(string name="ahb_reset_sequence");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- AHB Reset Sequence Constructed ----", UVM_LOW);
  	endfunction

	task body();
        ahb_sequence_item item;
        `uvm_info(get_type_name(), "====  AHB Reset Sequence Body Task Called  ====", UVM_MEDIUM)
      //  `uvm_info (get_type_name(), $sformatf("[Test2ResetSEQ] RST = %0d", rst), UVM_HIGH)
      //  `uvm_do_with(item, {item.hresetn  == 1'b0;})
      //  `uvm_info (get_type_name(), $sformatf("[ResetSEQ2DRV] HRESETn", item.hresetn), UVM_HIGH) 
        `uvm_info(get_type_name(), "==== AHB Reset Sequence Body Task Finished ====", UVM_MEDIUM)
    endtask

endclass
