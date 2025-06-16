class ahb_read_sequence extends ahb_base_sequence;
	`uvm_object_utils(ahb_read_sequence)
  
  	function new(string name="ahb_read_sequence");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- AHB Read Sequence Constructed ----", UVM_LOW);
  	endfunction
  

	task body();
        ahb_sequence_item item;
        `uvm_info(get_type_name(), "==============  AHB Read Sequence Body Task Called  ==============", UVM_MEDIUM)
        //`uvm_info (get_type_name(), $sformatf("[Test2ReadSEQ] SADDR = %0d, HSIZE = %0d, HBURST = %0d, RND = %0d, RND_TEST = %0d, TOTAL_RTEST = %0d, BSY = %0d, RST = %0d", start_address, hsize, hburst, rnd, rnd_test, total_rtest, bsy, rst), UVM_HIGH);
        `uvm_create(item)
        calc_wrap_info;
        for(j=0; j<burst_length; j=j+1) begin
            generate_addr_ctrl;
            `uvm_do_with(item, {item.hwrite  == 1'b0;
                                item.hsize   == local::hsize;
                                item.hburst  == local::hburst;
                                item.htrans  == local::htrans;
                                item.start_address == store_address;
                                })
           // `uvm_info (get_type_name(), $sformatf("[ReadSEQ_Drive] ADDR = %0d, HSIZE = %0d, HBURST = %0d, HTRANS = %0d", item.start_address, item.hsize, item.hburst, item.htrans), UVM_HIGH); 
        end
        `uvm_info(get_type_name(), "============== AHB Read Sequence Body Task Finished ==============", UVM_MEDIUM)
    endtask

endclass
