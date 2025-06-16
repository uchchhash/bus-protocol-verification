
class apb_monitor extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(apb_monitor)
  
    // Sequence Item and Interface Instance
    apb_sequence_item apb_item;
    virtual apb_interface apb_intf;
     
  	uvm_event apb_tx_done;
  
    // Declare Analysis ports
    // APB monitor to Scoreboard
    // APB monitor to Adapter
    // APB monitor to Coverage
     uvm_analysis_port #(apb_sequence_item) analysis_port_APBmntrAP;
     uvm_analysis_port #(apb_sequence_item) analysis_port_APBmntr2covAP;
  
    function new(string name="apb_monitor", uvm_component parent = null);
        super.new(name, parent);
    	`uvm_info(get_type_name(), "---- APB Monitor Constructed ----", UVM_LOW);
    endfunction
  
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
 		`uvm_info(get_type_name(), "APB Monitor 'Build Phase' Started", UVM_HIGH);
        analysis_port_APBmntrAP = new("analysis_port_APBmntrAP", this);
        analysis_port_APBmntr2covAP = new("analysis_port_APBmntr2covAP", this);
    endfunction
 
  
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== APB Monitor Run Phase Started =====", UVM_HIGH);
         forever begin
            @(negedge apb_intf.PCLK);
            apb_item = apb_sequence_item::type_id::create("apb_item", this);            	
              if(apb_intf.PRESETn == 1 && apb_intf.PSEL == 1  && apb_intf.PENABLE == 1 && apb_intf.PREADY == 1 && apb_intf.PSLVERR == 0) begin
                if(apb_intf.PWRITE) begin
                  apb_item.write_data = apb_intf.PWDATA;
                  apb_item.write_addr = apb_intf.PADDR;
                  apb_item.pwrite = 1'b1;
                  apb_tx_done.trigger;
                  //`uvm_info (get_type_name(), $sformatf("[WRITE] WADDR = %0h, WDATA = %0h", apb_item.write_addr, apb_item.write_data), UVM_LOW)
                end
                else if (!apb_intf.PWRITE) begin
                  apb_item.read_data = apb_intf.PRDATA;
                  apb_item.read_addr = apb_intf.PADDR;
                  apb_item.pwrite = 1'b0;
                  apb_tx_done.trigger;
                  //`uvm_info (get_type_name(), $sformatf("[READ] RADDR = %0h, RDATA = %0h", apb_item.read_addr, apb_item.read_data), UVM_LOW)
                end
                analysis_port_APBmntrAP.write(apb_item);
              end
              // Sampling for Coverage 
              if(apb_intf.PWRITE) apb_item.write_addr = apb_intf.PADDR;
              else if(!apb_intf.PWRITE) apb_item.read_addr = apb_intf.PADDR;
              apb_item.write_data = apb_intf.PWDATA;              
              apb_item.read_data  = apb_intf.PRDATA;      
              apb_item.pwrite  = apb_intf.PWRITE;
			  apb_item.pready  = apb_intf.PREADY;
			  apb_item.presetn = apb_intf.PRESETn;
		  	  apb_item.psel    = apb_intf.PSEL;
			  apb_item.penable = apb_intf.PENABLE;
			  apb_item.pslverr = apb_intf.PSLVERR;
			  analysis_port_APBmntr2covAP.write(apb_item);
          end
     endtask

endclass

