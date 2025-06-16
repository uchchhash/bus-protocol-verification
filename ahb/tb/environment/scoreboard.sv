`uvm_analysis_imp_decl(_port_mntr2scb)
`uvm_analysis_imp_decl(_port_pred2scb)


class scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(scoreboard)
    uvm_analysis_imp_port_pred2scb #(ahb_sequence_item, scoreboard) analysis_imp_pred2scb;
    uvm_analysis_imp_port_mntr2scb #(ahb_sequence_item, scoreboard) analysis_imp_mntr2scb;
    int pass_count, fail_count;
   
    ahb_sequence_item act_store;
    ahb_sequence_item exp_store;
    
    /*
    //------ uvm tlm declaration ------//
    // port type = imp
    // interface type = put
    uvm_put_imp #(ahb_sequence_item, scoreboard) mntr2scb_putimp;
    uvm_blocking_put_imp #(ahb_sequence_item, scoreboard) mntr2scb_putimp_b;
    uvm_nonblocking_put_imp #(ahb_sequence_item, scoreboard) mntr2scb_putimp_nb;
    */




    function new(string name="scoreboard", uvm_component parent= null);
        super.new(name, parent);
        `uvm_info(get_type_name(), "==== AHB Scoreboard Constructed ====", UVM_MEDIUM);	
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "AHB Scoreboard 'Build Phase' Started", UVM_MEDIUM);
        analysis_imp_pred2scb = new("analysis_imp_pred2scb", this); 
        analysis_imp_mntr2scb = new("analysis_imp_mntr2scb", this);  
        act_store = ahb_sequence_item::type_id::create("act_store", this);
        exp_store = ahb_sequence_item::type_id::create("exp_store", this);
        
        /*
        mntr2scb_putimp  = new("mntr2scb_putimp",this);
        mntr2scb_putimp_b = new("mntr2scb_putimp_b",this);
        mntr2scb_putimp_nb = new("mntr2scb_putimp_nb",this);
        */
    endfunction
    
    /*
    virtual task put(input ahb_sequence_item item);
        `uvm_info(get_type_name(), "PUT Task Called at Scoreboard", UVM_MEDIUM);
    endtask

    virtual function bit try_put(input ahb_sequence_item item);
        `uvm_info(get_type_name(), "TRY_PUT Function Called at Scoreboard", UVM_MEDIUM);
        return 1;
    endfunction

    virtual function bit can_put();
        `uvm_info(get_type_name(), "CAN_PUT Function Called at Scoreboard", UVM_MEDIUM);
        return 1;
    endfunction
    */


    virtual function void  write_port_mntr2scb (ahb_sequence_item act_item);
      //  act_store = ahb_sequence_item::type_id::create("act_store", this);
       // `uvm_info (get_type_name(), ">>>>> Scoreboard Got actual Transaction From Monitor <<<<<", UVM_HIGH)
       // `uvm_info (get_type_name(), $sformatf("[SCBfromMON][Actual] ADDR = %0d , WDATA = %0h, RDATA = %0h", act_item.start_address, act_item.write_data, act_item.read_data), UVM_HIGH)
        //`uvm_info (get_type_name(), $sformatf("[MNTR2SCB] Act_Address = %0h, Act_Data = %0h, Exp_Data = %0h",act_item.start_address, act_item.read_data, act_item.write_data), UVM_HIGH)
        act_store = act_item;
        //act_item.receiver("actual [ADDR, RDATA]","Scoreboard","Monitor");
        //act_item.print();
    endfunction


    virtual function void  write_port_pred2scb (ahb_sequence_item exp_item);
     //   `uvm_info (get_type_name(), ">>>>> Scoreboard Got expected Transaction From Predictor <<<<<", UVM_HIGH)
       // `uvm_info (get_type_name(), $sformatf("[SCBfromPRED][Expected] ADDR = %0d , WDATA = %0h, RDATA = %0h", exp_item.start_address, exp_item.write_data, exp_item.read_data), UVM_HIGH)
        //`uvm_info (get_type_name(), $sformatf("[PREDtoSCB] Exp_Address = %0h, Exp_Data = %0h, Act_Data = %0h", exp_item.start_address, exp_item.write_data, exp_item.read_data), UVM_HIGH)
      //  exp_store = ahb_sequence_item::type_id::create("exp_store", this);
        exp_store = exp_item;
        //exp_item.receiver("expected [ADDR, WDATA]","Scoreboard","Predictor");
        //exp_item.print();
        if(exp_store.write_data == act_store.read_data && exp_store.start_address == act_store.start_address) begin
            `uvm_info (get_type_name(), $sformatf("PASS :: Expected_Address = %0d | Expected_Data = %0h ||  Actual_Address = %0d | Actual_Data = %0h", exp_store.start_address, exp_store.write_data, act_store.start_address, act_store.read_data), UVM_HIGH);
            pass_count = pass_count+1;
        end
        else begin
            `uvm_error (get_type_name(), $sformatf("FAIL :: Expected_Address = %0d | Expected_Data = %0h ||  Actual_Address = %0d | Actual_Data = %0h", exp_store.start_address, exp_store.write_data, act_store.start_address, act_store.read_data));
            fail_count = fail_count+1;
        end
    endfunction



    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"AHB Scoreboard 'Report Phase' Started", UVM_MEDIUM)
        if(fail_count !=0)begin
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   ********      *        ********    **          ********    *******       |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   ******       * *          **       **          **          *      *      |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   **          *****         **       **          ********    *      *      |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   **         *     *        **       **          **          *      *      |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   **        *       *    ********    ********    ********    *******       |"), UVM_HIGH)  
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)      
        end
        else begin
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   ********       *       ********    ********    ********    *******       |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   **    **      * *      **          **          **          *      *      |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   ********     *****     ********    ********    ********    *      *      |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   **          *     *          **          **    **          *      *      |"), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("|   **         *       *   ********    ********    ********    *******       |"), UVM_HIGH) 
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)       
        end
        `uvm_info (get_type_name(), $sformatf("=============================== Report Summary ==============================="), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("======    Total Test: %0d   ||  Total Pass: %0d  ||  Total Fail: %0d    ======", pass_count+fail_count,pass_count, fail_count),UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)
        `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_HIGH)
    endfunction


endclass
