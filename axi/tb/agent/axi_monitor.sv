class axi_monitor extends uvm_monitor;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_monitor)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  virtual axi_interface axi_vif;
  axi_sequence_item axi_item, ar_item, r_item, axi_item2;
  uvm_analysis_port #(axi_sequence_item) analysis_port_mntr2pred;  // Monitor to Predictor
  uvm_analysis_port #(axi_sequence_item) analysis_port_mntr2scb;   // Monitor to Scoreboard
  uvm_analysis_port #(axi_sequence_item) analysis_port_mntr2cov;   // Monitor to Coverage
  
  uvm_analysis_port #(axi_sequence_item) analysis_port_mntr; // Monitor Analysis Port to broadcast Packet to Pred/SCB/Cov

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  axi_sequence_item aw_outstanding[MAX_OUTSTANDING][$];  // List of AW-channel outstandings
  axi_sequence_item  w_outstanding[MAX_OUTSTANDING][$];  // List of  W-channel outstandings
  axi_sequence_item  b_outstanding[MAX_OUTSTANDING][$];  // List of  W-channel outstandings
  axi_sequence_item ar_outstanding[MAX_OUTSTANDING][$];  // List of AR-channel outstandings
  axi_sequence_item  r_outstanding[MAX_OUTSTANDING][$];  // List of  R-channel outstandings

  axi_sequence_item ar_outstanding2[MAX_OUTSTANDING][$];  // List of AR-channel outstandings
  
  
  axi_sequence_item data_outstanding[$]; 

  mailbox #(logic [AWID_WIDTH-1:0]) aw_tags_mb;  // List (mailbox) of write-address tags that needs to be send 
  mailbox #(logic [AWID_WIDTH-1:0])  w_tags_mb;  // List (mailbox) of write-data tags that needs to be send 	
  mailbox #(logic [ BID_WIDTH-1:0])  b_tags_mb;  // List (mailbox) of write-response tags that needs to be received
  mailbox #(logic [ARID_WIDTH-1:0]) ar_tags_mb;  // List (mailbox) of read-address tags that needs to be send 
  mailbox #(logic [ RID_WIDTH-1:0])  r_tags_mb;  // List (mailbox) of read-data tags that needs to be received
  
  logic [AWID_WIDTH-1:0] awid_tag; // Store the AWID
  logic [AWID_WIDTH-1:0]  wid_tag; // Store the  WID   
  logic [ARID_WIDTH-1:0] arid_tag; // Store the ARID 
  logic [ RID_WIDTH-1:0]  rid_tag; // Store the  RID 

  // Nth Address Calculation
  bit [ADDR_WIDTH-1:0] addr, addr_n, start_addr, aligned_addr;
  bit [ADDR_WIDTH-1:0] awaddr_queue [$], araddr_queue [$], nth_addr_queue [$];
  bit [3:0] len;
  bit [3:0] size;
  bit [1:0] burst;
  bit w_mntr_flag;
  int burst_length, number_bytes;
  bit has_wrapped;  
  int wrap_boundary, wrap_limit, wrap_iter;
  int N, temp_val1, temp_val2, temp_val3, temp_val4;
  // STROBE Calculation & Filter
  bit [STRB_WIDTH-1:0] strb, generated_strb, provided_strb, effective_strb;
  bit [STRB_WIDTH-1:0] strb_queue [$], wstrb_queue [$], rstrb_queue [$], effective_strb_queue [$];
  int data_bus_bytes, length;
  int lower_byte_lane, upper_byte_lane;  
  int lower_index, upper_index;
  // READ-DATA Filter
  bit [DATA_WIDTH-1:0] provided_data;
  bit [DATA_WIDTH-1:0] filtered_data;

int data_counter, len_counter;
  
  
  // ---------------------------------- //
  // ----- Methods of AXI monitor ----- //
  // ---------------------------------- //
  extern function new(string name = "axi_monitor", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task axi_reset_mntr;
  extern task aw_channel_mntr;
  extern task w_channel_mntr;
  extern task b_channel_mntr;
  extern task ar_channel_mntr;
  extern task r_channel_mntr;
  extern task process_read_signals;

  extern function void calc_nth_addr(input bit [ADDR_WIDTH-1:0] addr, input bit [3:0] len, input bit [3:0] size, input bit [1:0] burst, output bit [ADDR_WIDTH-1:0] nth_addr_queue [$]);
  extern function void calc_strb    (input bit [ADDR_WIDTH-1:0] addr, input bit [3:0] len, input bit [3:0] size, input bit [1:0] burst, input  bit [ADDR_WIDTH-1:0] nth_addr_queue [$],  output bit [STRB_WIDTH-1:0] strb_queue [$]);
  extern function void filter_data  (input bit [STRB_WIDTH-1:0] strb, input bit [DATA_WIDTH-1:0] provided_data, output bit [DATA_WIDTH-1:0] filtered_data);


endclass : axi_monitor


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_monitor::new(string name = "axi_monitor", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Monitor Constructed *****", UVM_NONE);
endfunction


// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //

function void axi_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** AXI Monitor : Inside Build Phase *****", UVM_NONE);
  analysis_port_mntr2pred = new("analysis_port_mntr2pred", this);
  analysis_port_mntr2scb  = new("analysis_port_mntr1pred", this);
  analysis_port_mntr2cov  = new("analysis_port_mntr2cov", this);
  analysis_port_mntr = new("analysis_port_mntr", this);
  aw_tags_mb  = new();
  w_tags_mb   = new();
  ar_tags_mb  = new();
  r_tags_mb   = new();
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //


task axi_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  //`uvm_info(get_type_name(), "***** AXI Monitor : Run Phase Started  *****", UVM_MEDIUM);
  fork
    axi_reset_mntr();
    aw_channel_mntr();
    w_channel_mntr();
    b_channel_mntr();
    ar_channel_mntr();
    r_channel_mntr();
    process_read_signals();
  join_none;
  //`uvm_info(get_type_name(), "***** AXI Monitor : Run Phase Finished *****", UVM_MEDIUM);	
endtask

   
// -------------------------------------------------------------------- //
// ---------- Inidividual Tasks to Monitor various Scenarios ---------- //
// -------------------------------------------------------------------- //

//AWVALID; // Master2Slave ----> Write Address Valid
//WVALID;  // Master2Slave ----> Write Data Valid
//BREADY;  // Master2Slave ----> Write Response Ready
//ARVALID; // Master2Slave ----> Read Address Valid
//RREADY;  // Master2Slave ----> Read Data Ready



//----- Reset Monitor -----//
// --- a master interface must drive ARVALID, AWVALID, and WVALID LOW.
// --- a slave interface must drive RVALID and BVALID LOW.
// --- all other signals can be driven to any value.
// --- Send the RESET values to SCB



// ----- Outputs : AWREADY
// ----- Outputs : WREADY
// ----- Outputs : BVALID, BID, BRESP
// ----- Outputs : AWREADY
// ----- Outputs : RVALID, RID, RDATA, RRESP, RLAST


task axi_monitor::axi_reset_mntr;
  forever begin
    @(posedge axi_vif.ACLK);
    if(!axi_vif.ARESETn) begin
      axi_item = axi_sequence_item::type_id::create("axi_item");
      axi_item.aresetn = axi_vif.ARESETn;
      axi_item.awvalid = axi_vif.AWVALID;
      axi_item.awready = axi_vif.AWREADY;
      axi_item.wvalid  = axi_vif.WVALID;
      axi_item.wready  = axi_vif.WREADY;
      axi_item.bvalid  = axi_vif.BVALID;
      axi_item.bready  = axi_vif.BREADY;
      axi_item.arvalid = axi_vif.ARVALID;
      axi_item.arready = axi_vif.ARREADY;
      axi_item.rvalid  = axi_vif.RVALID;
      axi_item.rready  = axi_vif.RREADY;
      analysis_port_mntr2scb.write(axi_item);
      analysis_port_mntr2cov.write(axi_item);
   end
  end
endtask : axi_reset_mntr


// -------------------------------------------------------------------- //
// -------------------- Write Address Channel (AW) -------------------- //
// ----- Inputs : AWVALID, AWID, AWADDR, AWLEN, AWSIZE, AWBURST
// ----- Outputs : AWREADY
// ----- Handshake : AWVALID; // Master2Slave ----> Write Address Valid
// ----- Handshake : AWREADY; // Slave2Master ----> Write Address Ready
// ----- Send AW Channel Items to Predictor
// -------------------------------------------------------------------- //

task axi_monitor::aw_channel_mntr;
  forever begin
    @(posedge axi_vif.ACLK);
    if(axi_vif.AWVALID && axi_vif.AWREADY) begin
      axi_item = axi_sequence_item::type_id::create("axi_item");
      axi_item.aresetn = axi_vif.ARESETn;            
      axi_item.awvalid = axi_vif.AWVALID;
      axi_item.awready = axi_vif.AWREADY;
      axi_item.awid    = axi_vif.AWID;
      axi_item.awaddr  = axi_vif.AWADDR;
      axi_item.awlen   = axi_vif.AWLEN;
      axi_item.awsize  = axi_vif.AWSIZE;
      axi_item.awburst = axi_vif.AWBURST;
      analysis_port_mntr2pred.write(axi_item);
      analysis_port_mntr2cov.write(axi_item);      
      `uvm_info(get_type_name(), $sformatf("[AW] AWID = %0d || AWADDR = %0d || AWLEN = %0d || AWSIZE = %0d || AWBURST = %0d", axi_item.awid, axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst), UVM_HIGH)
    end
  end
endtask

// -------------------------------------------------------------------- //
// ---------------------- Write Data Channel (W) ---------------------- //
// ----- Inputs : WVALID, WID, WDATA, WSTRB, WLAST
// ----- Outputs : WREADY
// ----- Handshake : WVALID;  // Master2Slave ----> Write Data Valid
// ----- Handshake : WREADY;  // Slave2Master ----> Write Data Ready
// ----- Send W Channel Items to Predictor
// -------------------------------------------------------------------- //

task axi_monitor::w_channel_mntr;
  forever begin
    @(posedge axi_vif.ACLK);
    if(axi_vif.WVALID && axi_vif.WREADY) begin
      axi_item = axi_sequence_item::type_id::create("axi_item");
      axi_item.aresetn = axi_vif.ARESETn;
      axi_item.wvalid = axi_vif.WVALID;
      axi_item.wready = axi_vif.WREADY;
      axi_item.wdata  = axi_vif.WDATA;
      axi_item.wstrb  = axi_vif.WSTRB;
      analysis_port_mntr2pred.write(axi_item);
      analysis_port_mntr2cov.write(axi_item);      
      `uvm_info(get_type_name(), $sformatf("[W] WDATA = %0h || WSTRB = %4b ", axi_item.wdata, axi_item.wstrb), UVM_HIGH)
    end
  end
endtask


// -------------------------------------------------------------------- //
// -------------------- Write Response Channel (B) -------------------- //
// ----- Inputs : BREADY
// ----- Outputs : BVALID, BID, BRESP
// ----- Handshake : BVALID;  // Slave2Master ----> Write Response Valid
// ----- Handshake : BREADY;  // Master2Slave ----> Write Response Ready
// ----- Send B Channel Items to Predictor
// -------------------------------------------------------------------- //

task axi_monitor::b_channel_mntr;
  forever begin
    @(posedge axi_vif.ACLK);
    if(axi_vif.BVALID && axi_vif.BREADY) begin
      axi_item = axi_sequence_item::type_id::create("axi_item");
      axi_item.aresetn = axi_vif.ARESETn;            
      axi_item.bvalid = axi_vif.BVALID;
      axi_item.bready = axi_vif.BREADY;
      axi_item.bid    = axi_vif.BID;
      axi_item.bresp  = axi_vif.BRESP;
      analysis_port_mntr2pred.write(axi_item);
      analysis_port_mntr2cov.write(axi_item);
      `uvm_info(get_type_name(), $sformatf("[ B] BID = %0d || BRESP = %0d ", axi_item.bid, axi_item.bresp), UVM_HIGH)      
      //if(axi_item.bresp != OKAY) `uvm_info(get_type_name(), $sformatf("[NOT-OKAY-RESPONSE. . . . . . . . .][ B] BID = %0d || BRESP = %0d ", axi_item.bid, axi_item.bresp), UVM_MEDIUM)	             
    end
  end
endtask


// -------------------------------------------------------------------- //
// -------------------- Read Address Channel (AR) --------------------- //
// ----- Inputs : ARVALID, ARID, ARADDR, ARLEN, ARSIZE, ARBURST
// ----- Outputs : AWREADY
// ----- Handshake : ARVALID; // Master2Slave ----> Read Address Valid
// ----- Handshake : ARREADY; // Slave2Master ----> Read Address Ready
// ----- Send AR Channel Items to Predictor
// -------------------------------------------------------------------- //

task axi_monitor::ar_channel_mntr;
  forever begin
    @(posedge axi_vif.ACLK);
    if(axi_vif.ARVALID && axi_vif.ARREADY) begin 
      axi_item = axi_sequence_item::type_id::create("axi_item");
      axi_item.aresetn = axi_vif.ARESETn;            
      axi_item.arvalid = axi_vif.ARVALID;
      axi_item.arready = axi_vif.ARREADY;
      axi_item.arid    = axi_vif.ARID;
      axi_item.araddr  = axi_vif.ARADDR;
      axi_item.arlen   = axi_vif.ARLEN;
      axi_item.arsize  = axi_vif.ARSIZE;
      axi_item.arburst = axi_vif.ARBURST;
      ar_outstanding[axi_item.arid].push_back(axi_item);
      analysis_port_mntr2cov.write(axi_item);      
      `uvm_info(get_type_name(), $sformatf("[AR] ARID = %0d || ARADDR = %0d || ARLEN = %d || ARSIZE = %0d || ARBURST = %0d", axi_item.arid, axi_item.araddr, axi_item.arlen, axi_item.arsize, axi_item.arburst), UVM_HIGH)
   end
  end
endtask

// -------------------------------------------------------------------- //
// ---------------------- Read Data Channel (R) ----------------------- //
// ----- Inputs : RREADY
// ----- Outputs : RVALID, RID, RDATA, RRESP, RLAST
// ----- Handshake : RVALID;  // Slave2Master ----> Read Data Valid
// ----- Handshake : RREADY;  // Master2Slave ----> Read Data Ready
// ----- Send R Channel Items to Scoreboard
// -------------------------------------------------------------------- //

task axi_monitor::r_channel_mntr;
  forever begin
    @(negedge axi_vif.ACLK);
    if(axi_vif.RVALID && axi_vif.RREADY) begin
      axi_item = axi_sequence_item::type_id::create("axi_item");
      axi_item.aresetn = axi_vif.ARESETn;            
      axi_item.rvalid = axi_vif.RVALID;
      axi_item.rready = axi_vif.RREADY;
      axi_item.rid    = axi_vif.RID;
      axi_item.rdata  = axi_vif.RDATA;
      axi_item.rresp  = axi_vif.RRESP;
      axi_item.rlast  = axi_vif.RLAST;
      r_outstanding[axi_item.rid].push_back(axi_item);
      analysis_port_mntr2cov.write(axi_item);     
      if(axi_item.rlast) r_tags_mb.put(axi_item.rid);
      //  $display("==>> Counting-Data = %0d", data_counter);
      //  if(ar_outstanding2[axi_item.rid].size !=0) begin
      //     axi_item = ar_outstanding2[axi_item.rid].pop_front();
      //     len_counter = axi_item.arlen;
      //      $display("@[%0t] monitor-read-data-task :: RID = %0d || ARID = %0d || ARLEN = %0d || Data-Counter = %0d || Len-Counter = %0d", $realtime, axi_item.rid, axi_item.arid, axi_item.arlen, data_counter, len_counter);
      // end
      // `uvm_info(get_type_name(), $sformatf("[R] RID = %0d || RDATA = %0h || RRESP = %0d || RLAST = %0d", axi_item.rid, axi_item.rdata, axi_item.rresp, axi_item.rlast), UVM_HIGH)	      
      //  $display("==>> Data-Counter = %0d || Len-Counter = %0d", data_counter, len_counter);
      //  if (data_counter == len_counter) begin
      //    $display("==>> [same] Data-Counter = %0d || Len-Counter = %0d", data_counter, len_counter);
      //    data_counter = 0;
      //    r_tags_mb.put(axi_item.rid);
      //  end
      //  data_counter++;
    end
  end
endtask


// --------------------------------------------------------------------------------------------------------------- //
// ----------------------------------------- AXI Read Transaction Rules ------------------------------------------ //
// --->> R channel Handshakes must occur after the corresponding AR Channel handshake occurs
// --->> Transactions with different RID can complete in any order
// --->> Transactions with different RID can be interleaved & RID differentiats which transaction the data relates
// --->> Transactions with same RID must be performed & complete in same order
// --------------------------------------------------------------------------------------------------------------- //
// ----------------------------- Process the Read Channel (AR & R) Channel Signals ------------------------------- //
// --->> AR_Monitor :: Store the AR outstanding to queue-array with ARID as tags
// --->>  R_Monitor :: Store the  R outstanding to queue-array with  RID as tags
// --->> Put the RID to rid-mailbox whose read-last is done 
// --->> Get the RID from the mailbox and extract ARID items from AR outstanding with using RID as tag
// --->> Calculate Nth address & Strobe values from ARID items
// --->> Extract RID items from R outstanding with using RID as tag & filter the WDATA using the STROBEs
// --->> Send the ARADDR to Predictor & Send the ARADDR & RDATA to Scoreboard
//--------------------------------------------------------------------------------------------------------------- //


task axi_monitor::process_read_signals;
  forever begin
    r_tags_mb.get(rid_tag);
    axi_item = ar_outstanding[rid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No AR-outstanding Item Found **********")
    analysis_port_mntr2pred.write(axi_item); // Sending ARADDR to Predictor
    calc_nth_addr(axi_item.araddr, axi_item.arlen, axi_item.arsize, axi_item.arburst, araddr_queue);
    calc_strb(axi_item.araddr, axi_item.arlen, axi_item.arsize, axi_item.arburst, araddr_queue, rstrb_queue);
    length = axi_item.arlen;
    size = axi_item.arsize;
    burst = axi_item.arburst;
    arid_tag = axi_item.arid;
    for(int i = 0; i<= length; i++) begin
      axi_item = r_outstanding[rid_tag].pop_front();
      if(axi_item == null) `uvm_fatal(get_type_name(), "********** No R-outstanding Item Found **********")
      filter_data(rstrb_queue.pop_front(), axi_item.rdata, filtered_data);
      axi_item.araddr  = araddr_queue.pop_front();
      axi_item.rdata   = filtered_data;
       if (i==0) begin
         `uvm_info(get_type_name(), "===========================================================================================================", UVM_MEDIUM);	      
         `uvm_info(get_type_name(), $sformatf("[Initiating Read  Transfer] :: ARID = %0d || ARADDR = %0d || ARLEN = %0d || ARSIZE = %s || ARBURST = %s", arid_tag, axi_item.araddr, length, (size == BYTE_1) ? "BYTE_1" : (size == BYTE_2) ? "BYTE_2" : "BYTE_4", (burst == INCR) ? "INCR" : (burst == WRAP) ? "WRAP" : "FIXED"), UVM_MEDIUM)    
         `uvm_info(get_type_name(), "===========================================================================================================", UVM_MEDIUM);	
       end
      analysis_port_mntr2scb.write(axi_item); // Sending ARADDR/RDATA to Scoreboard
    end
  end
endtask


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------- Helper Methods --------------------------------------------------------------------------- //
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- //



//--------------------------------------- Calculate Aligned Address ----------------------------------------------------------- //
// ***** Aligned_Address = (INT(Start_Address / Number_Bytes) ) × Number_Bytes.
// ***** Inputs : awaddr : start_address 
// ***** Inputs : awsize : calculate number of bytes per transfer (2**awsize)
// --------------------------------------- Calculate Nth Addresses ------------------------------------------------------------- //
// ***** Calculate the Nth addresses : each address per transfer 
// ***** Address_N :: (Address of the Nth Transfer) :: N = transfer number
// ***** For FIXED Transfer =======================>>
// ***** address is same for each transfer :: Address_N :: Start_Address 
// ***** For INCR Transfer ========================>>
// ***** address increases :: Address_N = Aligned_Address + (N - 1) × Number_Bytes
// ***** For WRAP Transfer ========================>>
// ***** Wrap_Boundary = (INT(Start_Address / (Number_Bytes × Burst_Length))) × (Number_Bytes × Burst_Length)
// ***** Burst_Length = AxLEN + 1
// ***** Wrap_Limit =  Wrap_Boundary + (Number_Bytes × Burst_Length)
// ***** if WRAPPED :: (if Address_N = Wrap_Limit)
// ***** for the current transfer: Address_N = Wrap_Boundary
// ***** for any subsequent transfers: Address_N = Start_Address + ((N - 1) × Number_Bytes) - (Number_Bytes × Burst_Length)
// ***** if NOT WRAPPED :: Address_N = Aligned_Address + (N - 1) × Number_Bytes
// ***** Inputs :: awaddr, awsize, awlen, awburst, aligned_addr
// ---------------------------------------------------------------------------------------------------------------------------- //


function void axi_monitor::calc_nth_addr(
  input bit [ADDR_WIDTH-1:0] addr,
  input bit [3:0] len,
  input bit [3:0] size,
  input bit [1:0] burst,
  output bit [ADDR_WIDTH-1:0] nth_addr_queue [$]
);
  burst_length  = len + 1;
  number_bytes  = 1 << size;  // Equivalent to 2**size
  start_addr    = addr;
  aligned_addr  = (start_addr / number_bytes) * number_bytes;

  wrap_boundary = (start_addr / (number_bytes * burst_length)) * (number_bytes * burst_length);
  wrap_limit    = wrap_boundary + (number_bytes * burst_length);

  has_wrapped = 0;
  wrap_iter   = 0;

  for (int i = 0; i < burst_length; i++) begin
    case (burst)
      FIXED: addr_n = start_addr;

      INCR:  addr_n = aligned_addr + i * number_bytes;

      WRAP: begin
        addr_n = aligned_addr + i * number_bytes;
        if (addr_n == wrap_limit || has_wrapped) begin
          addr_n = (wrap_iter == 0) 
                    ? wrap_boundary 
                    : start_addr + i * number_bytes - number_bytes * burst_length;
          has_wrapped = 1;
          wrap_iter++;
        end
      end

      default: addr_n = start_addr;  // Fallback for unsupported burst
    endcase

    nth_addr_queue.push_back(addr_n);
  end
endfunction


// --------------------------------------- Calculate Active Byte Lanes ------------------------------------------------- //
// ***** For the Fisrt Transfer:
// ----- Lower_Byte_Lane = Start_Address-(INT(Start_Address/Data_Bus_Bytes))*Data_Bus_Bytes
// ----- Upper_Byte_Lane = Aligned_Address + (Number_Bytes -1)-(INT(Start_Address/Data_Bus_Bytes))*Data_Bus_Bytes
// ***** For the Rest of the Transfer:
// ----- Lower_Byte_Lane = Address_N - (INT(Address_N/Data_Bus_Bytes))*Data_Bus_Bytes
// ----- Upper_Byte_Lane = Lower_Byte_Lane + Number_Bytes -1
// --------------------------------------- Calculate Write STROBE ------------------------------------------------------ //
// ***** WSTRB[n] corresponds to WDATA[(8n)+7:(8n)] :: WDATA[(8*UBL)+7:(8*LBL)]
// ***** LBL : Lower Byte Lane ; UBL : Upper Byte Lane
// --------------------------------------------------------------------------------------------------------------------- //

function void axi_monitor::calc_strb(
  input  bit [ADDR_WIDTH-1:0] addr,
  input  bit [3:0] len,
  input  bit [3:0] size,
  input  bit [1:0] burst,
  input  bit [ADDR_WIDTH-1:0] nth_addr_queue [$],
  output bit [STRB_WIDTH-1:0] strb_queue [$]
);
  burst_length   = len + 1;
  number_bytes   = 1 << size;
  data_bus_bytes = BUS_WIDTH;
  start_addr     = addr;
  aligned_addr   = (start_addr / number_bytes) * number_bytes;
  temp_val3      = start_addr / data_bus_bytes;

  for (int i = 0; i < burst_length; i++) begin
    addr_n = nth_addr_queue.pop_front;
    temp_val4 = addr_n / data_bus_bytes;

    if (i == 0 || burst == FIXED) begin
      lower_byte_lane = start_addr % data_bus_bytes;
      upper_byte_lane = (aligned_addr + number_bytes - 1) % data_bus_bytes;
    end
    else begin
      lower_byte_lane = addr_n % data_bus_bytes;
      upper_byte_lane = lower_byte_lane + number_bytes - 1;
    end

    lower_index = lower_byte_lane * 8;
    upper_index = upper_byte_lane * 8 + 7;

    // Dynamically build strobe
    generated_strb = 0;
    for (int j = lower_byte_lane; j <= upper_byte_lane && j < STRB_WIDTH; j++) begin
      generated_strb[j] = 1'b1;
    end

    if (generated_strb == 0)
      `uvm_error(get_type_name(), "[STRB_Calculation] Invalid Active Byte Lane Range");

    strb_queue.push_back(generated_strb);
  end
endfunction

 

// ----------------------------------------------------------------------------------------------------------------- //
// --------------------------------------- Filter the WDATA/RDATA -------------------------------------------------- //
// ----------------------------------------------------------------------------------------------------------------- //

function void axi_monitor::filter_data(
  input  bit [STRB_WIDTH-1:0] strb,
  input  bit [DATA_WIDTH-1:0] provided_data,
  output bit [DATA_WIDTH-1:0] filtered_data
);
  filtered_data = '0; // Initialize entire data to zero

  // Loop over each byte lane
  for (int i = 0; i < STRB_WIDTH; i++) begin
    if (strb[i]) begin
      // Extract the i-th byte and place it back at the correct byte lane in filtered_data
      filtered_data[i*8 +: 8] = provided_data[i*8 +: 8];
    end
  end
endfunction



