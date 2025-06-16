class ahb_monitor extends uvm_monitor;  

	`uvm_component_utils(ahb_monitor)
	ahb_sequence_item item, item1;
	virtual ahb_interface ahb_intf;

    // analysis port to broadcast packet
    uvm_analysis_port #(ahb_sequence_item) analysis_port_mntr2scb;   // Monitor to Scoreboard 
    uvm_analysis_port #(ahb_sequence_item) analysis_port_mntr2pred;  // Monitor to Predictor 

    /*
    //------ uvm tlm declaration ------//
    // port type = port
    // interface type = put
    uvm_put_port #(ahb_sequence_item) mntr2scb_putport;
    uvm_blocking_put_port #(ahb_sequence_item) mntr2scb_putport_b;
    uvm_nonblocking_put_port #(ahb_sequence_item) mntr2scb_putport_nb;
    */

  
  
	function new(string name="ahb_monitor", uvm_component parent = null);
		super.new(name, parent);
      	`uvm_info(get_type_name(), "AHB Monitor Constructed", UVM_MEDIUM)
	endfunction
  
    
	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
      	`uvm_info(get_type_name(), "AHB Monitor 'Build Phase' Started", UVM_MEDIUM)
        analysis_port_mntr2scb = new("analysis_port_mntr2scb", this);
        analysis_port_mntr2pred = new("analysis_port_mntr2pred", this);

        /*
        mntr2scb_putport  = new("mntr2scb_putport",this);
        mntr2scb_putport_b = new("mntr2scb_putport_b",this);
        mntr2scb_putport_nb = new("mntr2scb_putport_nb",this);
        */
  	endfunction


	virtual task run_phase(uvm_phase phase);
    	super.run_phase(phase);
      	`uvm_info(get_type_name(), "AHB Monitor 'Run Phase' Started", UVM_MEDIUM)
		forever begin
        	@(posedge ahb_intf.HCLK);
            if(ahb_intf.HSEL == 1 && ahb_intf.HTRANS[1] == 1 && ahb_intf.HREADY_I == 1 && ahb_intf.HRESETN == 1) begin
               // $display("@[%0t][MON] ==== Creating Item ====", $time);
		        item = ahb_sequence_item::type_id::create("item", this);
		        fork
			        capture_addr_ctrl(item);
                    capture_data(item);
		        join_any
            end
		end
    endtask


    integer lsb_b = 0;
    integer lsb_h = 0;


	task capture_addr_ctrl(ahb_sequence_item item);
        //`uvm_info(get_type_name(),"********** Address/Control Capturing Started **********", UVM_HIGH);
        item.start_address = ahb_intf.HADDR;
        item.hsize = ahb_intf.HSIZE;
        item.hwrite = ahb_intf.HWRITE;
        item.htrans = ahb_intf.HTRANS;
	endtask

     bit[31:0] tempData1;
     bit[31:0] tempData2;
     bit[31:0] tempData3;
     bit[31:0] tempData4;
     bit[31:0] tempData5;


  	task capture_data(ahb_sequence_item item);
        //`uvm_info(get_type_name(),"********** Data Capturing Started **********", UVM_HIGH);
        //---- capturing expected values (write condition) ---//
        //---- sending expected data & address to predictor ---//
        if(item.hwrite && ahb_intf.HSEL == 1 && ahb_intf.HTRANS[1] == 1 && ahb_intf.HREADY_I == 1 && ahb_intf.HRESETN == 1) begin
            @(posedge ahb_intf.HCLK);
            //-------------------------------
            tempData1 = $random;
            tempData2 = tempData1[0 +:8];
            tempData3 = tempData1[8 +:8];
            tempData4 = tempData1[16 +:8];
            tempData5 = tempData1[24 +:8];
            $display("@[%0t][MONITOR] temp_DATA = %0h, sDATA1 = %0h, sDATA2 = %0h, sDATA3 = %0h, sDATA4 = %0h", $time, tempData1, tempData2, tempData3, tempData4, tempData5);
            //-------------------------------
            item.write_data = ahb_intf.HWDATA;
            if(item.hsize == `BYTE) begin
               // $display("@[%0t][MONITOR][Byte Before Slice] WDATA = %0h", $time, item.write_data);
                item.write_data = item.write_data[lsb_b +:8];
               // $display("@[%0t][MONITOR][Byte After Slice] WDATA = %0h, LSB_B = %0d", $time, item.write_data, lsb_b);            
            end
            else if(item.hsize == `HALFWORD) begin
               // $display("@[%0t][MONITOR][HWord Before Slice] WDATA = %0h", $time, item.write_data);
                item.write_data = item.write_data[lsb_h +:15];
              //  $display("@[%0t][MONITOR][HWord After Slice] WDATA = %0h, LSB_H = %0d", $time, item.write_data, lsb_h);            
            end
            else if(item.hsize == `WORD) begin
               // $display("@[%0t][MONITOR][Word Before Slice] WDATA = %0h", $time, item.write_data);
                item.write_data = item.write_data[0 +:31];
              //  $display("@[%0t][MONITOR][Word After Slice] WDATA = %0h", $time, item.write_data);            
            end
          //  item.write_data = (item.hsize == `BYTE) ? item.write_data[lsb_b +:8] : (item.hsize == `HALFWORD) ? item.write_data[lsb_h +:15] : item.write_data[0 +:31];
          //  $display("@[%0t][MONITOR][After Slice]  WDATA = %0h", $time, item.write_data);
            //item.sender("expected [ADDR, WDATA]","Monitor","Predictor");
            //item.print();
            analysis_port_mntr2pred.write(item);
            //--- Calculate appropriate LSB's according to bus widths----//
            lsb_b = (lsb_b >=24) ? 0 : (lsb_b + 8);	
            lsb_h = (lsb_h >=16) ? 0 : (lsb_h + 16);
        end
        //---- capturing actual values (read condition) ---//
        //---- sending actual data to scoreboard & actual address to predictor ---//        
       else if(!item.hwrite && ahb_intf.HSEL == 1 && ahb_intf.HTRANS[1] == 1 && ahb_intf.HREADY_I == 1 && ahb_intf.HRESETN == 1) begin
            @(negedge ahb_intf.HCLK);
            item.read_data = ahb_intf.HRDATA;
            //$display("@[%0t][MONITOR][Before Slice] RDATA = %0h", $time, item.read_data);
            item.read_data = (item.hsize == `BYTE) ? item.read_data[lsb_b +:8] : (item.hsize == `HALFWORD) ? item.read_data[lsb_h +:15] : item.read_data[0 +:31];
            //$display("@[%0t][MONITOR][After Slice] RDATA = %0h", $time, item.read_data);
           // item.sender("actual [ADDR, RDATA]","Monitor","Predictor & Scoreboard");
           // item.print();
            analysis_port_mntr2scb.write(item);
            analysis_port_mntr2pred.write(item);

            //--------------------
           /* 
            mntr2scb_putport.put(item); 
            mntr2scb_putport.try_put(item); 
            mntr2scb_putport.can_put(); 

            mntr2scb_putport_b.put(item); 
            mntr2scb_putport_b.try_put(item); 
            mntr2scb_putport_b.can_put(); 

            mntr2scb_putport_nb.put(item); 
            mntr2scb_putport_nb.try_put(item); 
            mntr2scb_putport_nb.can_put(); 
            */
            //-----------------------

            //--- Calculate appropriate LSB's according to bus widths----//
            lsb_b = (lsb_b >=24) ? 0 : (lsb_b + 8);	
            lsb_h = (lsb_h >=16) ? 0 : (lsb_h + 16);
        end
    endtask


endclass
