`uvm_analysis_imp_decl(_port_mntr2pred)

class ahb_predictor extends uvm_component;
  
    `uvm_component_utils(ahb_predictor)
    uvm_analysis_imp_port_mntr2pred #(ahb_sequence_item, ahb_predictor) analysis_imp_mntr2pred;
	uvm_analysis_port #(ahb_sequence_item) analysis_port_pred2scb;
    ahb_sequence_item item;

    function new(string name = "ahb_predictor", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name, "==== AHB_Predictor Constructed ====", UVM_MEDIUM)
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "AHB_Predictor 'Build Phase' Started", UVM_MEDIUM);
        analysis_imp_mntr2pred = new("analysis_imp_mntr2pred", this);
        analysis_port_pred2scb = new("analysis_port_pred2scb", this);
        item = ahb_sequence_item::type_id::create("item", this); 
    endfunction

    // Associative array
    bit [7:0] ahb_memory [int];

    virtual function void write_port_mntr2pred (ahb_sequence_item predItem);
        //`uvm_info (get_type_name(), ">>>>> Predictor Got Expected Transaction From Monitor <<<<<", UVM_HIGH)
        //`uvm_info (get_type_name(), $sformatf("[PREDfromMon][Expected] ADDR = %0d , WDATA = %0h, RDATA = %0h", item.start_address, item.write_data, item.read_data), UVM_HIGH);       
       // item = new predItem;        
        item.copy(predItem);
        //item.receiver("expected [ADDR, WDATA]","Predictor","Monitor");
        //item.print();
         //---------- Write Expected Data to the Predictor Memory ----------// 
        if(item.hwrite && item.htrans[1] == 1) begin
            if(item.hsize == `WORD) begin
                ahb_memory[item.start_address]     = item.write_data[7:0];
                ahb_memory[item.start_address + 1] = item.write_data[15:8];
                ahb_memory[item.start_address + 2] = item.write_data[23:16];
                ahb_memory[item.start_address + 3] = item.write_data[31:24];
                //`uvm_info (get_type_name(), $sformatf("[word write to PRED] mem[%0d] = %0h ", item.start_address, ahb_memory[item.start_address]), UVM_HIGH);
               //`uvm_info (get_type_name(), $sformatf("[word write to PRED] mem[%0d] = %0h ", item.start_address+1, ahb_memory[item.start_address+1]), UVM_HIGH);
                //`uvm_info (get_type_name(), $sformatf("[word write to PRED] mem[%0d] = %0h ", item.start_address+2, ahb_memory[item.start_address+2]), UVM_HIGH);
               // `uvm_info (get_type_name(), $sformatf("[word write to PRED] mem[%0d] = %0h ", item.start_address+3, ahb_memory[item.start_address+3]), UVM_HIGH);
            end
            else if(item.hsize == `HALFWORD) begin
               // `uvm_info (get_type_name(), $sformatf("[halfword write to PRED] mem[] = %0h ", item.write_data), UVM_HIGH);
                ahb_memory[item.start_address]     = item.write_data[7:0];
                ahb_memory[item.start_address + 1] = item.write_data[15:8];
               // `uvm_info (get_type_name(), $sformatf("[halfword write to PRED] mem[%0d] = %0h ", item.start_address, ahb_memory[item.start_address]), UVM_HIGH);
               // `uvm_info (get_type_name(), $sformatf("[halfword write to PRED] mem[%0d] = %0h ", item.start_address+1, ahb_memory[item.start_address+1]), UVM_HIGH);
            end
            else if(item.hsize == `BYTE) begin
                ahb_memory[item.start_address] = item.write_data[7:0];
            end        
        end

        //---------- Read Expected Data from the Predictor Memory ----------//
        else if(!item.hwrite && item.htrans[1] == 1) begin
           // `uvm_info (get_type_name(), $sformatf("[Read the Expected from PRED] WADDR = %0h, WDATA = %0h ", item.start_address, item.write_data), UVM_HIGH);
            if(item.hsize == `WORD) begin
                item.write_data[7:0]   = ahb_memory[item.start_address];     
                item.write_data[15:8]  = ahb_memory[item.start_address + 1];
                item.write_data[23:16] = ahb_memory[item.start_address + 2];
                item.write_data[31:24] = ahb_memory[item.start_address + 3];  
               // `uvm_info (get_type_name(), $sformatf("[word read from PRED] mem[%0d] = %0h ", item.start_address, ahb_memory[item.start_address]), UVM_HIGH);
              // `uvm_info (get_type_name(), $sformatf("[word read from PRED] mem[%0d] = %0h ", item.start_address+1, ahb_memory[item.start_address+1]), UVM_HIGH);
              //  `uvm_info (get_type_name(), $sformatf("[word read from PRED] mem[%0d] = %0h ", item.start_address+2, ahb_memory[item.start_address+2]), UVM_HIGH);
              //  `uvm_info (get_type_name(), $sformatf("[word read from PRED] mem[%0d] = %0h ", item.start_address+3, ahb_memory[item.start_address+3]), UVM_HIGH);       
            end
            else if(item.hsize == `HALFWORD) begin
                item.write_data[7:0]   = ahb_memory[item.start_address];     
                item.write_data[15:8]  = ahb_memory[item.start_address + 1]; 
               // `uvm_info (get_type_name(), $sformatf("[halfword read from PRED] mem[%0d] = %0h ", item.start_address, item.write_data[7:0]), UVM_HIGH);
               // `uvm_info (get_type_name(), $sformatf("[halfword read from PRED] mem[%0d] = %0h ", item.start_address+1, item.write_data[15:8]), UVM_HIGH);             
            end
            else if(item.hsize == `BYTE) begin
                item.write_data[7:0] = ahb_memory[item.start_address];
            end
            //---------- Send Expected Data to Scoreboard ----------//
           // `uvm_info (get_type_name(), $sformatf("[Send the Expected to SCB] WADDR = %0h, WDATA = %0h ", item.start_address, item.write_data), UVM_HIGH)
            item.read_data = 32'h10000000;            
           // item.sender("expected [ADDR, WDATA]","Predictor","Scoreboard");
            //item.print();
            analysis_port_pred2scb.write(item);
        end

    endfunction



endclass
