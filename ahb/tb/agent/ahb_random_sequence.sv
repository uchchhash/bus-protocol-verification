class ahb_random_sequence extends ahb_base_sequence;
	`uvm_object_utils(ahb_random_sequence)
  
  	function new(string name="ahb_random_sequence");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- AHB Random Sequence Constructed ----", UVM_LOW);
  	endfunction

    ahb_write_sequence w_seq;
    ahb_read_sequence r_seq;

	task body();    
        ahb_sequence_item item;
        `uvm_info(get_type_name(), "====  AHB Random Sequence Body Task Called  ====", UVM_MEDIUM)
        //`uvm_info (get_type_name(), $sformatf("[Test2RandSEQ] RND = %0d, RND_TEST = %0d, TOTAL_RTEST = %0d, BSY = %0d", rnd, rnd_test, total_rtest, bsy), UVM_HIGH)
        for(i = 0; i <total_rtest; i = i +1) begin
            `uvm_create(item)
            allignedAddrGen(item);
            `uvm_do_with(w_seq, { w_seq.start_address == local::start_address;
                                  w_seq.bsy == local::bsy;
                                  w_seq.rnd == local::rnd;
                                })
             //`uvm_info (get_type_name(), $sformatf("[RandSEQ_Wdrive] ADDR = %0h, HSIZE = %0d", start_address, hsize), UVM_HIGH)
        end
        for(i = 0; i <total_rtest; i = i +1) begin
            allignedAddrGen(item);
            `uvm_do_with(r_seq, { r_seq.start_address == local::start_address;
                                  r_seq.bsy == local::bsy;
                                  r_seq.rnd == local::rnd;
                                })
             //`uvm_info (get_type_name(), $sformatf("[RandSEQ_Rdrive] ADDR = %0h, HSIZE = %0d", start_address, hsize), UVM_HIGH)
        end
        `uvm_info(get_type_name(), "==== AHB Random Sequence Body Task Finished ====", UVM_MEDIUM)
    endtask

endclass
