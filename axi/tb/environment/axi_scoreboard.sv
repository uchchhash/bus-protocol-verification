

// Declare imp for expected and actual items 
`uvm_analysis_imp_decl(_port_mntr2scb)
`uvm_analysis_imp_decl(_port_pred2scb)


class axi_scoreboard extends uvm_scoreboard;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_scoreboard)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  uvm_analysis_imp_port_mntr2scb#(axi_sequence_item, axi_scoreboard) analysis_imp_mntr2scb;
  uvm_analysis_imp_port_pred2scb#(axi_sequence_item, axi_scoreboard) analysis_imp_pred2scb;
       
  axi_sequence_item exp_item,  act_item;
  axi_sequence_item exp_store, act_store;

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  axi_sequence_item write_outstanding[$]; // List of AW/W-channel outstandings
  axi_sequence_item  read_outstanding[$]; // List of AR/R-channel outstandings	
  int pass_count, fail_count;
     
  // --------------------------------- //
  // ----- Methods of AXI Driver ----- //
  // --------------------------------- //
  extern function new(string name = "axi_scoreboard", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern function void write_port_mntr2scb (axi_sequence_item axi_item);
  extern function void write_port_pred2scb (axi_sequence_item axi_item);
  extern function void report_phase(uvm_phase phase);		

endclass

// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_scoreboard::new(string name="axi_scoreboard", uvm_component parent= null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "***** AXI Scoreboard Constructed *****", UVM_NONE);
endfunction


// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void axi_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "***** AXI Scoreboard : Inside Build Phase *****", UVM_NONE);
    analysis_imp_mntr2scb    = new("analysis_imp_mntr2scb", this);      
    analysis_imp_pred2scb    = new("analysis_imp_pred2scb", this);          
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //


// ----- Reset Scoreboard -----//
// --- a master interface must drive ARVALID, AWVALID, and WVALID LOW.
// --- a slave interface must drive RVALID and BVALID LOW.
// --- all other signals can be at any value

function void axi_scoreboard::write_port_mntr2scb(axi_sequence_item axi_item);
  // AXI-Reset-Condition
  if(axi_item.aresetn == 1'b0) begin
  `uvm_info(get_type_name(), "================================================", UVM_MEDIUM);
  `uvm_info(get_type_name(), $sformatf("[Initiating Reset Transfer] ARESETn = %0s", (axi_item.aresetn == 0) ? "ACTIVATED" : "DEACTIVATED" ), UVM_MEDIUM)    
  `uvm_info(get_type_name(), "================================================", UVM_MEDIUM);	
    if(axi_item.awvalid == 1'b0 && axi_item.wvalid == 1'b0 && axi_item.bvalid == 1'b0 && axi_item.arvalid == 1'b0 && axi_item.rvalid == 1'b0) begin
      `uvm_info (get_type_name(), $sformatf("PASS :: Expected :: AWVALID = 0, WVALID = 0, BVALID = 0, ARVALID = 0, RVALID = 0 || Actual :: AWVALID = %0d || WVALID = %0d || BVALID = %0d || ARVALID = %0d || RVALID = %0d", axi_item.awvalid, axi_item.wvalid, axi_item.bvalid, axi_item.arvalid, axi_item.rvalid), UVM_MEDIUM)
    end
    else begin
      `uvm_info (get_type_name(), $sformatf("FAIL :: Expected :: AWVALID = 0, WVALID = 0, BVALID = 0, ARVALID = 0, RVALID = 0 || Actual :: AWVALID = %0d || WVALID = %0d || BVALID = %0d || ARVALID = %0d || RVALID = %0d", axi_item.awvalid, axi_item.wvalid, axi_item.bvalid, axi_item.arvalid, axi_item.rvalid), UVM_MEDIUM)
    end
    repeat(2) $display();    
  end
  else if (axi_item.aresetn) begin
    read_outstanding.push_back(axi_item);
  end
endfunction


function void axi_scoreboard::write_port_pred2scb(axi_sequence_item axi_item);
  exp_item = axi_sequence_item::type_id::create("exp_item");
  exp_item = axi_item;
  act_item = axi_sequence_item::type_id::create("act_item");
  act_item = read_outstanding.pop_front();
  
  if(exp_item.awaddr == act_item.araddr && exp_item.wdata === act_item.rdata) begin
    `uvm_info (get_type_name(), $sformatf("  PASS :: Expected_Address = %0d | Expected_Data = %0h ||  Actual_Address = %0d | Actual_Data = %0h", exp_item.awaddr, exp_item.wdata, act_item.araddr, act_item.rdata), UVM_MEDIUM);
    pass_count++;
  end
  else begin
    `uvm_error (get_type_name(), $sformatf("FAIL :: Expected_Address = %0d | Expected_Data = %0h ||  Actual_Address = %0d | Actual_Data = %0h", exp_item.awaddr, exp_item.wdata, act_item.araddr, act_item.rdata));
    fail_count++;
  end
endfunction


function void axi_scoreboard::report_phase(uvm_phase phase);
  // `uvm_info(get_type_name(),"AXI Scoreboard 'Report Phase' Started", UVM_MEDIUM)
  if(fail_count !=0)begin
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ********      *        ********    **          ********    *******       |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ******       * *          **       **          **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **          *****         **       **          ********    *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **         *     *        **       **          **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **        *       *    ********    ********    ********    *******       |"), UVM_MEDIUM)  
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)      
  end
  else begin
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ********       *       ********    ********    ********    *******       |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **    **      * *      **          **          **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   ********     *****     ********    ********    ********    *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **          *     *          **          **    **          *      *      |"), UVM_MEDIUM)
    `uvm_info (get_type_name(), $sformatf("|   **         *       *   ********    ********    ********    *******       |"), UVM_MEDIUM) 
    `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)       
  end
  `uvm_info (get_type_name(), $sformatf("=============================== Report Summary ==============================="), UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("======    Total Test: %0d   ||  Total Pass: %0d  ||  Total Fail: %0d    ======", pass_count+fail_count,pass_count, fail_count),UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
  `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_MEDIUM)
endfunction




