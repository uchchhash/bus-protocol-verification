class ahb_base_sequence extends uvm_sequence#(ahb_sequence_item);
	`uvm_object_utils(ahb_base_sequence)
  
  	function new(string name="ahb_sequence");
    	super.new(name);
    	`uvm_info(get_type_name(), "---- AHB Base Sequence Constructed ----", UVM_LOW);
  	endfunction
  
  	//---- Data and Address ----//
    rand bit [`addrWidth-1:0] start_address;
    rand bit [`addrWidth-1:0] store_address;
    rand bit [`dataWidth-1:0] store_data;

    //---- Control Signals ----//
    rand bit hwrite;
    rand bit [2:0] hsize;
    rand bit [2:0] hburst;
    bit [1:0] htrans;

    //----- External Controls ---//
    rand bit rst;            // Reset test
    rand bit bsy;            // Busy State
    rand bit rnd;            // Randomize Data
    rand bit rnd_test;       // Random Test
    rand int total_rtest;    // Total Random Test
    int i,j;

    //------Wrap Info Calculation------//
    int burst_length;   // #burst from hburst
    int transfer_size;  // #Bytes from hsize
	int wrap_boundary;  // Lower address to WRAP to
	int upper_limit;    // Upper address limit to make WRAP

    //---- Constraints -----//
    constraint hsize_range { hsize inside {[0:2]}; }

	task body();
        ahb_sequence_item item;
        `uvm_info(get_type_name(), "====  AHB Base Sequence Body Task Called  ====", UVM_MEDIUM)
        `uvm_info(get_type_name(), "==== AHB Base Sequence Body Task Finished ====", UVM_MEDIUM)
    endtask

    task generate_addr_ctrl;
       // `uvm_info(get_type_name(),"********** Generating ADDRESS & CONTROL**********", UVM_HIGH);
        //-------- Generating Control Signals ---------//
        htrans = (j == 0 ||  hburst == `SINGLE) ? 2'b10 : 2'b11;
        //-------- Generating Address ---------//
        if(hburst ==`SINGLE)store_address = start_address; // SINGLE Burst      
        else begin  // INCR/WRAP 
            if(hburst== `WRAP4 || hburst == `WRAP8 || hburst == `WRAP16) begin // WRAP Burst
                if(start_address < upper_limit) store_address = start_address;
                if(start_address >= upper_limit) begin
                    store_address   = wrap_boundary;
                    start_address   = store_address;
                end
            end
            else begin 
                store_address = start_address; // INCR Burst       
            end
        end
        start_address = start_address + transfer_size;
        //`uvm_info (get_type_name(), $sformatf("[SEQ][ADDR_GEN] ADDR = %0d", store_address), UVM_HIGH)
    endtask

   task allignedAddrGen(ahb_sequence_item item);
        //`uvm_info(get_type_name(),"********** Alligned Address Generation **********", UVM_HIGH);
        item.randomize();
        start_address = item.allignedAddr;
        //`uvm_info(get_type_name(), $sformatf("[SEQ][Alligned_ADDR] SADDR = %0d ", start_address), UVM_MEDIUM)
    endtask

    task generate_data;
        //`uvm_info(get_type_name(),"********** Generating Data**********", UVM_HIGH);
        if(rnd) store_data = $random;//$urandom_range(32'h10000000, 32'hFFFFFFFF);
        else if(!rnd) begin 
            if(i==0) store_data = 32'h10000000;
            store_data = store_data + 32'd10000;
        end
      //  `uvm_info (get_type_name(), $sformatf("[SEQ][DATA_GEN][rnd = %0d] WDATA = %0h",rnd, store_data), UVM_HIGH)
    endtask


    //------------ CALCULATE WRAP INFO ----------//
    task calc_wrap_info;
        //`uvm_info(get_type_name(),"********** WRAP INFO CALCULATION **********", UVM_HIGH);
        if(hburst== `WRAP8 || hburst == `INCR8) burst_length = 8;
        else if (hburst == `WRAP4 || hburst == `INCR4) burst_length = 4;
        else if (hburst == `WRAP16 || hburst == `INCR16) burst_length = 16;
        else if (hburst == `INCR) burst_length = 16; //Incremental
        else burst_length = 16; //Single
        transfer_size = 2**(hsize);
        wrap_boundary = (start_address/(burst_length*transfer_size))*(burst_length*transfer_size);
        upper_limit = wrap_boundary+(burst_length*transfer_size);
       // `uvm_info (get_type_name(), $sformatf("[SEQ][WRAP_INFO] HBURST = %0d, BURST_LENGTH = %0d, HSIZE = %0d, TRANSFER_SIZE = %0d, WRAP_BOUNDARY = %0d, UPPER_LIMIT = %0d", hburst, burst_length, hsize, transfer_size, wrap_boundary, upper_limit), UVM_HIGH);
    endtask 






endclass
