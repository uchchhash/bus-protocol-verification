
class axi_driver extends uvm_driver #(axi_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_driver)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  virtual axi_interface axi_vif;

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //	

  // Mailboxes of AW/W/B/AR/R channel TAGS that needs to be send or received
  // Item-tags are stored and transfered between channel-drive-tasks for synchronization
  // Item-tags are used to extract outstanding-transactions from outstanding arrays
  mailbox #(logic [AWID_WIDTH-1:0]) aw_tags_mb;  // List (mailbox) of write-address tags that needs to be send 
  mailbox #(logic [AWID_WIDTH-1:0])  w_tags_mb;  // List (mailbox) of write-data tags that needs to be send 	
  mailbox #(logic [ BID_WIDTH-1:0])  b_tags_mb;  // List (mailbox) of write-response tags that needs to be received
  mailbox #(logic [ARID_WIDTH-1:0]) ar_tags_mb;  // List (mailbox) of read-address tags that needs to be send 
  mailbox #(logic [ RID_WIDTH-1:0])  r_tags_mb;  // List (mailbox) of read-data tags that needs to be received

  axi_sequence_item aw_outstanding[MAX_OUTSTANDING][$];  // List of AW-channel outstandings
  axi_sequence_item  w_outstanding[MAX_OUTSTANDING][$];  // List of  W-channel outstandings
  axi_sequence_item  b_outstanding[MAX_OUTSTANDING][$];  // List of  W-channel outstandings
  axi_sequence_item ar_outstanding[MAX_OUTSTANDING][$];  // List of AR-channel outstandings
  axi_sequence_item  r_outstanding[MAX_OUTSTANDING][$];  // List of  R-channel outstandings

  logic [AWID_WIDTH-1:0] awid_tag; // Store the AWID
  logic [AWID_WIDTH-1:0]  wid_tag; // Store the  WID 
  logic [ BID_WIDTH-1:0]  bid_tag; // Store the  BID 
  logic [ARID_WIDTH-1:0] arid_tag; // Store the ARID
  logic [ RID_WIDTH-1:0]  rid_tag; // Store the  RID 

  // Nth Address Calculation
  bit [ADDR_WIDTH-1:0] addr, addr_n, start_addr, aligned_addr;
  bit [ADDR_WIDTH-1:0] awaddr_queue [$], araddr_queue [$], nth_addr_queue [$];
  bit [3:0] len;
  bit [3:0] size;
  bit [1:0] burst;
  int burst_length, number_bytes;
  int N, temp_val1, temp_val2, temp_val3, temp_val4;
  int wrap_boundary, wrap_limit, wrap_iter;
  bit has_wrapped;

  // STROBE Calculation & Filter
  bit [STRB_WIDTH-1:0] generated_strb, provided_strb, filtered_strb;
  bit [STRB_WIDTH-1:0] strb_queue [$], wstrb_queue [$], rstrb_queue [$], effective_strb_queue [$];
  int data_bus_bytes;
  int lower_byte_lane, upper_byte_lane;  
  int lower_index, upper_index;
  
  // --------------------------------- //
  // ----- Methods of AXI Driver ----- //
  // --------------------------------- //
  extern function new(string name = "axi_driver", uvm_component parent = null);	
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  // ----- Methods to Reset & Set Handshake delay ----- //
  extern task reset_axi_bus;
  extern task axi_reset(axi_sequence_item axi_item);
  extern task assert_handshake_delay(input int max_delay);
  // ----- Methods to Drive AXI Channels ----- //
  extern task aw_channel_drive;
  extern task w_channel_drive;    
  extern task b_channel_drive;
  extern task ar_channel_drive;
  extern task r_channel_drive;
  // ----- Helper Methods ----- //
  extern function void calc_nth_addr(input bit [ADDR_WIDTH-1:0] addr, input bit [3:0] len, input bit [3:0] size, input bit [1:0] burst, output bit [ADDR_WIDTH-1:0] nth_addr_queue [$]);
  extern function void calc_strb    (input bit [ADDR_WIDTH-1:0] addr, input bit [3:0] len, input bit [3:0] size, input bit [1:0] burst, input bit [ADDR_WIDTH-1:0] nth_addr_queue [$], output bit [STRB_WIDTH-1:0] strb_queue [$]);
  extern function void filter_strb  (input bit [STRB_WIDTH-1:0] generated_strb, input bit [STRB_WIDTH-1:0] provided_strb, output bit [STRB_WIDTH-1:0] filtered_strb);

endclass : axi_driver



// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_driver::new(string name = "axi_driver", uvm_component parent = null);
   super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Driver-1 Constructed *****", UVM_NONE);
endfunction

// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //
function void axi_driver::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "***** AXI Driver-1 : Inside Build Phase *****", UVM_NONE);
  aw_tags_mb = new();
  w_tags_mb  = new();
  b_tags_mb  = new();	
  ar_tags_mb = new();
  r_tags_mb  = new();
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task axi_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  //`uvm_info(get_type_name(), "***** AXI Driver-1 : Run Phase Started  *****", UVM_MEDIUM);	
  
  reset_axi_bus();  // Resetting the AXI Bus at first before any transaction

  // All five channels running concurrently without waiting for another
  // Channel processes are mostly independent of each other 
  // Synchronization between the channels are done withing individual drive tasks
  fork
    aw_channel_drive();
    w_channel_drive();
    b_channel_drive();
    ar_channel_drive();
    r_channel_drive();
  join_none;
  

  // A structure represents a collection of data types that can be referenced as a whole, or the individual data types that make up the structure can be referenced by name. 
  // By default, structures are unpacked, meaning that there is an implementation-dependent packing of the data types. 
  // Unpacked structures can contain any data type.
  
  // Syntax for structure declarations in systemverilog : 
  // data_type ::=  | struct_union [ packed [ signing ] ] { struct_union_member { struct_union_member } } { packed_dimension }
  // Here , 
  	// struct_union ::= struct | union [ tagged ]
  	// packed ::= optional
	// signing ::= signed | unsigned
    // struct_union_member ::= { attribute_instance } [random_qualifier] data_type_or_void list_of_variable_decl_assignments ;
    // data_type_or_void ::= data_type | void
    // attribute_instance ::= (* attr_spec { , attr_spec } *) // from A.9.1
    // attr_spec ::= attr_name [ = constant_expression ]
    // attr_name ::= identifier
  
  
  // --------------------------------------------------------------------------------------------------------------- //
  // ------------------------------------ Driver-1 :: Write-Address-Sequence --------------------------------------- //
  // --->> AW_Write = 1 // W_Write = 0 // AR_Write = 0 // Has_Reset = 0 // Has_Delay = 0/1 
  // --->> AWID // AWADDR // AWLEN // AWSIZE // AWBURST 
  // --->> Put aw_items in aw_outstanding & w_outstanding queue-array with awid as tag of each queue of the array
  // --->> Put aw_items in aw_tags_mb & w_tags_mb mailbox and Send it to AW/W Channel Driver Task 
  // --->> Put aw_items in b_outstanding queue-array with awid as tag of each queue of the array
  // --->> Need of w_outstanding :: passing the aw_item instance (has_delay)
  // --->> Need of b_outstanding :: passing the aw_item instance (item_really_done) 
  // --->> if(aw_write or w_write)   :: start the AW & W Drive task at once :: by sending the tags through mailbox
  // --->> if(aw & w handshake done) :: start the B Drive task :: by sending the tag through mailbox
  // --------------------------------------------------------------------------------------------------------------- //

  forever begin
    axi_sequence_item axi_item;
    seq_item_port.get_next_item(axi_item);
   // `uvm_info(get_type_name(), "***** AXI Driver-1 : Get Next Item Called  *****", UVM_MEDIUM);	
    seq_item_port.item_done();
   // `uvm_info(get_type_name(), "***** AXI Driver-1 : Item Done Called  *****", UVM_MEDIUM);	
    // Resetting the Bus Before any transaction
    // Receiving items from sequence & calling "item-done" immidietly to receive another item
   // `uvm_info (get_type_name(), $sformatf("Got Items @Driver-1 :: [Has_Reset = %0d] [AW_Write = %0d] [W_Write = %0d] [AR_Write = %0d] [Has_Delay = %0d]", axi_item.has_reset, axi_item.aw_write, axi_item.w_write, axi_item.ar_write, axi_item.has_delay), UVM_MEDIUM)        
    //`uvm_info (get_type_name(), $sformatf("Got Items @Driver-1 :: %s", axi_item.convert2string), UVM_MEDIUM) 
    if(!axi_item.has_reset && (axi_item.aw_write || axi_item.w_write)) begin
      aw_outstanding[axi_item.awid].push_back(axi_item);
      w_outstanding[axi_item.awid].push_back(axi_item); 
      b_outstanding[axi_item.awid].push_back(axi_item);  
      //`uvm_info (get_type_name(), $sformatf("[===== AW & W MB Written =====][AW_Write = %0d] [W_Write = %0d]", axi_item.aw_write, axi_item.w_write), UVM_MEDIUM)        
      aw_tags_mb.put(axi_item.awid);
      w_tags_mb.put(axi_item.awid);
    end
    else if(!axi_item.has_reset && axi_item.ar_write) begin
      ar_outstanding[axi_item.arid].push_back(axi_item);
      r_outstanding[axi_item.arid].push_back(axi_item);
      ar_tags_mb.put(axi_item.arid);
    end
    else axi_reset(axi_item);
  end
endtask



// --------------------------------------------------------------------------------------------------------------- //
// ----------------------------------------- AXI Write Transaction Rules ----------------------------------------- //
// --->> AW & W Channel Handshakes can occur independent of each other 
// --->> B Channel Handshakes must occur after the corresponding AW & W Channel handshake occurs
// --->> B Channel Handshake must also wait for WLAST 
// --------------------------------------------------------------------------------------------------------------- //
// --->> WDATA on the W Channel must follow the same order as the AWADDR transfers on the AW channel
// --->> Transactions with different AWID can complete in any order
// --->> Transaction with same AWID must be performed & complete in same order
// --------------------------------------------------------------------------------------------------------------- //
// ----------------------------------------- AXI Read Transaction Rules ------------------------------------------ //
// --->> R channel Handshakes must occur after the corresponding AR Channel handshake occurs
// --->> Transactions with different RID can complete in any order
// --->> Transactions with different RID can be interleaved & RID differentiats which transaction the data relates
// --->> Transactions with same RID must be performed & complete in same order
// --------------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------------------------------------------- //


// -------------------------------------------------------------------------------------------------------------------- //
// ----------------------------------- Inidividual Tasks to Drive various Scenarios ----------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //


task axi_driver::axi_reset(axi_sequence_item axi_item);
    //`uvm_info(get_type_name(), "***** AXI Driver-1 : Reset Task Called *****", UVM_MEDIUM);
    axi_item.item_really_started();
    // ---------- GLobal Signals ---------- //
    axi_vif.ARESETn <= ACTIVATE;
    // ---------- Write Address Channel (AW) ---------- //
    axi_vif.AWID    <= 0;   
    axi_vif.AWADDR  <= 0; 
    axi_vif.AWLEN   <= 0;  
    axi_vif.AWSIZE  <= 0; 
    axi_vif.AWBURST <= 0;
    axi_vif.AWVALID <= 0; 
    // ---------- Write Data Channel (W) ---------- //	
    axi_vif.WDATA   <= 0; 
    axi_vif.WSTRB   <= 0;
    axi_vif.WLAST   <= 0; 
    axi_vif.WVALID  <= 0;
    // ---------- Write Response Channel (B) ---------- //
    axi_vif.BREADY  <= 0;
    // ---------- Read Address Channel (AW) ---------- //
    axi_vif.ARID    <= 0;
    axi_vif.ARADDR  <= 0;
    axi_vif.ARLEN   <= 0;
    axi_vif.ARSIZE  <= 0;
    axi_vif.ARBURST <= 0;
    axi_vif.ARVALID <= 0;
    //----- Read Data Channel (R) -----//
    axi_vif.RREADY  = 0; 
    repeat(2)@(negedge axi_vif.ACLK);	
    axi_vif.ARESETn <= DEACTIVATE;
    repeat(2)@(negedge axi_vif.ACLK);
    axi_item.item_really_done();
    //`uvm_info(get_type_name(), "***** AXI Driver-1 : Reset Task Done *****", UVM_MEDIUM);
endtask




// -------------------------------------------------------------------------------------------------- //
// ----------------------------------- Write Address Channel (AW) ----------------------------------- //
// ----- Inputs : AWVALID, AWID, AWADDR, AWLEN, AWSIZE, AWBURST
// ----- Outputs : AWREADY
// ----- Handshake : AWVALID; // Master2Slave ----> Write Address Valid
// ----- Handshake : AWREADY; // Slave2Master ----> Write Address Ready
// ----- Get item-id from AW mailbox and extract the item from AW outstanding
// ----- Call the item-really-started base sequence method to REALLY start the transaction
// ----- All inputs are driven at negedge 
// ----- Valid inputs are driven and waits for ready
// ----- Transfer ends with AWVALID/AWREADY handshake
// ----- Put item-id to W mailbox to indicate AW transfer is done, proceed to W transfer
// -------------------------------------------------------------------------------------------------- //

//HANDSHAKE :: at a rising clock edge at which VALID and READY are both asserted.

//-> AWVALID can't wait for AWREADY -> Once AWVALID is asserted; it remains asserted until handshake occurs
//-> AWREADY can wait for AWVALID -> Once AWREADY is asserted; it can be deasserted before handshake occurs


task axi_driver::aw_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    aw_tags_mb.get(awid_tag);   
    //`uvm_info (get_type_name(), $sformatf("[===== Got AWID :: AW Channel Started =====][AWID = %0d]", awid_tag), UVM_MEDIUM)        
    axi_item = aw_outstanding[awid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No AW-outstanding Item Found **********")
    // Call the Item Really Started when AW phase starts running
    axi_item.item_really_started();
    // Drive the AW-Channel Signals
    axi_vif.AWVALID <= 1'b1;
    axi_vif.AWID    <= axi_item.awid;
    axi_vif.AWADDR  <= axi_item.awaddr;
    axi_vif.AWLEN   <= axi_item.awlen;
    axi_vif.AWSIZE  <= axi_item.awsize;
    axi_vif.AWBURST <= axi_item.awburst;
    // Wait for AWREADY
    while(!axi_vif.AWREADY) begin
      `uvm_info(get_type_name(), "***** AXI Driver-1 : Waiting for AWREADY *****", UVM_DEBUG)
      @(negedge axi_vif.ACLK);
    end
    @(negedge axi_vif.ACLK);
    if(axi_item.has_delay) begin
      axi_vif.AWVALID  <= 1'b0;
      assert_handshake_delay(3);
    end
    axi_vif.AWVALID <= 1'b0;
    end
endtask

// -------------------------------------------------------------------------------------------------- //
// ------------------------------------- Write Data Channel (W) ------------------------------------- //
// ----- Inputs : WVALID, WID, WDATA, WSTRB, WLAST
// ----- Outputs : WREADY
// ----- Handshake : WVALID;  // Master2Slave ----> Write Data Valid
// ----- Handshake : WREADY;  // Slave2Master ----> Write Data Ready
// ----- Get item-id from W mailbox
// ----- Extract the W items from outstandings : Single AWID corresponds to AWLEN times WID items
// ----- All inputs are driven at negedge 
// ----- Valid inputs are driven and waits for ready !!A
// ----- Transfer ends with WLAST signal being HIGH
// ----- Transfer ends with WVALID/WREADY handshake for AWLEN times
// ----- Put item-id to B mailbox to indicate W transfer is done, proceed to B transfer
// -------------------------------------------------------------------------------------------------- //

task axi_driver::w_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    // Get the WDATA Tag from W mailbox & Extract the Item using the WID
    w_tags_mb.get(wid_tag);
    //`uvm_info (get_type_name(), $sformatf("[===== Got WID :: W Channel Started =====][WID = %0d]", wid_tag), UVM_MEDIUM)            
    axi_item = w_outstanding[wid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No  W-outstanding Item Found **********")
    calc_nth_addr(axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst, awaddr_queue);  // Returns Nth AW-Address queue
    calc_strb(axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst, awaddr_queue, wstrb_queue); // Returns Calculated WSTRB queue
    for(int j=0; j<=axi_item.awlen; j++) begin
      axi_vif.WVALID	<= 1'b1;
      axi_vif.WDATA 	<= $urandom;
      axi_vif.WSTRB 	<= wstrb_queue.pop_front();
      while(!axi_vif.WREADY) begin
        `uvm_info(get_type_name(), "***** AXI Driver-1 : Waiting for WREADY *****", UVM_DEBUG)
        @(negedge axi_vif.ACLK);
      end
      @(negedge axi_vif.ACLK);	
      if(axi_item.has_delay) begin
        axi_vif.WVALID <= 1'b0;
        assert_handshake_delay(3);
      end
    end
    axi_vif.WVALID	<= 1'b0;	
    b_tags_mb.put(wid_tag);
end
endtask

// -------------------------------------------------------------------------------------------------- //
// ----------------------------------- Write Response Channel (B) ----------------------------------- //
// ----- Inputs : BREADY
// ----- Outputs : BVALID, BID, BRESP
// ----- Handshake : BVALID;  // Slave2Master ----> Write Response Valid
// ----- Handshake : BREADY;  // Master2Slave ----> Write Response Ready
// ----- Get item-id from B mailbox & Extract the B item from outstanding
// ----- There is no B-item to drive : doing this to transfer the item instance containg the "done-task"
// ----- All inputs are driven at negedge 
// ----- Ready is driven at waits for VALID
// ----- Transfer ends with BVALID/BREADY handshake
// ----- Item really Done task call indicates the end of Transfer
// -------------------------------------------------------------------------------------------------- //

// ----- BREADY can be high before BVALID 
// ----- BREADY	can be high after BVALID
// ----- BREADY can be high then low before BVALID

task axi_driver::b_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    b_tags_mb.get(bid_tag);
    axi_item = b_outstanding[bid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No B-outstanding Item Found **********")
    axi_vif.BREADY <= 1'b1;
    /*
    if(axi_item.has_delay) begin
      @(negedge axi_vif.ACLK);
      axi_vif.BREADY <= 1'b0;      
      assert_handshake_delay(3);
      axi_vif.BREADY <= 1'b1;
    end
    */
    while(!axi_vif.BVALID) begin
      `uvm_info(get_type_name(), "***** AXI Driver-1 : Waiting for BVALID *****", UVM_DEBUG)
      @(negedge axi_vif.ACLK);
    end
    @(negedge axi_vif.ACLK);
    axi_vif.BREADY <= 1'b0;
    axi_item.item_really_done();
end	
endtask


// -------------------------------------------------------------------------------------------------- //
// ----------------------------------- Read Address Channel (AR) ------------------------------------ //
// ----- Inputs : ARVALID, ARID, ARADDR, ARLEN, ARSIZE, ARBURST
// ----- Outputs : AWREADY
// ----- Handshake : ARVALID; // Master2Slave ----> Read Address Valid
// ----- Handshake : ARREADY; // Slave2Master ----> Read Address Ready
// ----- Get item-id from AR mailbox and extract the item from AR outstanding
// ----- Call the item-really-started base sequence method to REALLY start the transaction
// ----- All inputs are driven at negedge 
// ----- Valid inputs are driven and waits for ready
// ----- Transfer ends with ARVALID/ARREADY handshake
// ----- Put item-id to R mailbox to indicate AR transfer is done, proceed to R transfer
// -------------------------------------------------------------------------------------------------- //
 

task axi_driver::ar_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    ar_tags_mb.get(arid_tag);
    axi_item = ar_outstanding[arid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No AR-outstanding Item Found **********")
    // Call the Item Really Started when AW phase starts running
    axi_item.item_really_started();
    axi_vif.ARVALID <= 1'b1;
    axi_vif.ARID    <= axi_item.arid;
    axi_vif.ARADDR  <= axi_item.araddr;
    axi_vif.ARLEN   <= axi_item.arlen;
    axi_vif.ARSIZE  <= axi_item.arsize;
    axi_vif.ARBURST <= axi_item.arburst;
    while(!axi_vif.ARREADY) begin
      `uvm_info(get_type_name(), "***** AXI Driver-1 : Waiting for ARREADY *****", UVM_DEBUG)
      @(negedge axi_vif.ACLK);
    end
    @(negedge axi_vif.ACLK);
    if(axi_item.has_delay) begin
      axi_vif.ARVALID  <= 1'b0;
      assert_handshake_delay(3);
    end        
    axi_vif.ARVALID <= 0;							
    r_tags_mb.put(arid_tag);
  end
endtask


// ---------------------------------------------------------------------------------------------- //
// ----------------------------------- Read Data Channel (R) ------------------------------------ //
// ----- Inputs : RREADY
// ----- Outputs : RVALID, RID, RRESP, RDATA, RLAST
// ----- Handshake : RVALID; // Slave2Master ----> Read Data Valid
// ----- Handshake : RREADY; // Master2Slave ----> Read Data Ready
// ----- Get item-id from R mailbox and extract the item from R outstanding
// ----- There is no R-item to drive : doing this to transfer the item instance containg the "done-task"
// ----- Ready is driven high and waits for valid
// ----- Transfer ends with RVALID/RREADY handshake for ARLEN times
// ----- Item really Done task call indicates the end of Transfer
// ---------------------------------------------------------------------------------------------- //

task axi_driver::r_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    r_tags_mb.get(rid_tag);
    axi_item = r_outstanding[rid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No R-outstanding Item Found **********")     				
    for(int i=0; i<=axi_item.arlen; i++) begin
      axi_vif.RREADY <= 1'b1;
      /*
      if(axi_item.has_delay) begin
        @(negedge axi_vif.ACLK);
        axi_vif.RREADY <= 1'b0;
        assert_handshake_delay(1);
        axi_vif.RREADY <= 1'b1;
      end
      */
      while(!axi_vif.RVALID) begin
        `uvm_info(get_type_name(), "***** AXI Driver-1 : Waiting for RVALID *****", UVM_DEBUG)
        @(negedge axi_vif.ACLK);
      end
      @(negedge axi_vif.ACLK);
    end
    axi_vif.RREADY = 1'b0;
    axi_item.item_really_done();
end
endtask


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------- Helper Methods --------------------------------------------------------------------------- //
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- //

task axi_driver::assert_handshake_delay(input int max_delay);
  begin
    int total_delay;  
    total_delay = $urandom_range(0, max_delay);
    repeat(total_delay) @(negedge axi_vif.ACLK); 
  end
endtask

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

function void axi_driver::calc_nth_addr(
  input  bit [ADDR_WIDTH-1:0] addr,
  input  bit [3:0] len,
  input  bit [3:0] size,
  input  bit [1:0] burst,
  output bit [ADDR_WIDTH-1:0] nth_addr_queue[$]
);
  // Initial computations
  bit [ADDR_WIDTH-1:0] aligned_addr;
  int burst_length    = len + 1;
  int number_bytes    = 2 ** size;
  int wrap_boundary   = (addr / (number_bytes * burst_length)) * (number_bytes * burst_length);
  int wrap_limit      = wrap_boundary + (number_bytes * burst_length);
  int wrap_iter       = 0;
  bit has_wrapped     = 0;

  for (int i = 0; i < burst_length; i++) begin
    bit [ADDR_WIDTH-1:0] addr_n;

    case (burst)
      FIXED: begin
        // Same address every cycle
        addr_n = addr;
      end
      INCR: begin
        // Aligned start + offset
        aligned_addr = (addr / number_bytes) * number_bytes;
        addr_n = aligned_addr + i * number_bytes;
      end
      WRAP: begin
        aligned_addr = (addr / number_bytes) * number_bytes;
        addr_n = aligned_addr + i * number_bytes;

        if (addr_n >= wrap_limit || has_wrapped) begin
          if (wrap_iter == 0) begin
            addr_n = wrap_boundary;
          end else begin
            addr_n = addr + (i * number_bytes) - (number_bytes * burst_length);
          end
          has_wrapped = 1'b1;
          wrap_iter++;
        end
      end
      default: addr_n = addr; // Fallback for undefined burst
    endcase

    nth_addr_queue.push_back(addr_n);
    // `uvm_info(get_type_name(), $sformatf("[Nth-ADDR] i=%0d Addr=%0d", i, addr_n), UVM_MEDIUM)
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

function void axi_driver::calc_strb(
  input  bit [ADDR_WIDTH-1:0] addr,
  input  bit [3:0] len,
  input  bit [3:0] size,
  input  bit [1:0] burst,
  input  bit [ADDR_WIDTH-1:0] nth_addr_queue[$],
  output bit [STRB_WIDTH-1:0] strb_queue[$]
);

  // Constants and local variables
  start_addr      = addr;
  data_bus_bytes  = BUS_WIDTH;            // Typically 4 bytes for 32-bit bus
  number_bytes    = 2 ** size;            // Number of bytes per transfer
  burst_length    = len + 1;
  temp_val3       = start_addr / data_bus_bytes;
  aligned_addr    = (start_addr / number_bytes) * number_bytes;

  for (int i = 0; i < burst_length; i++) begin
    addr_n = nth_addr_queue.pop_front();               // Pop nth transfer address
    temp_val4 = addr_n / data_bus_bytes;

    // Determine byte lane positions
    if (i == 0 || burst == FIXED) begin
      lower_byte_lane = start_addr - (temp_val3 * data_bus_bytes);
      upper_byte_lane = aligned_addr + number_bytes - 1 - (temp_val3 * data_bus_bytes);
    end
    else begin
      lower_byte_lane = addr_n - (temp_val4 * data_bus_bytes);
      upper_byte_lane = lower_byte_lane + number_bytes - 1;
    end

    // Safety clamp
    if (lower_byte_lane < 0 || upper_byte_lane >= STRB_WIDTH)
      `uvm_error(get_type_name(), $sformatf("[STRB_Calc] Invalid byte lane indices: L=%0d U=%0d", lower_byte_lane, upper_byte_lane))

    // Generate WSTRB using bit shifts instead of hardcoded patterns
    generated_strb = '0;
    for (int b = lower_byte_lane; b <= upper_byte_lane; b++) begin
      generated_strb[b] = 1'b1;
    end

    strb_queue.push_back(generated_strb);

    // Uncomment for debugging
    // `uvm_info(get_type_name(), $sformatf("[STRB] i=%0d Addr=%0d STRB=%b", i, addr_n, generated_strb), UVM_MEDIUM)
  end

endfunction



// --------------------------------------- Filter Write STROBE ------------------------------------------------- //
// ********** Filter the Input WSTRB with expected WSTRB 
// ********** Determine the actual WSTRB to be driven 
// ********** Bitwise AND Operation of Generated (Actual) WSTRB and provided WSTRB from sequence
// ---------------------------------------------------------------------------------------------------------------- //

function void axi_driver::filter_strb(input bit [STRB_WIDTH-1:0] generated_strb, input bit [STRB_WIDTH-1:0] provided_strb, output bit [STRB_WIDTH-1:0] filtered_strb);
  filtered_strb = generated_strb & provided_strb;
  //`uvm_info(get_type_name(), $sformatf("[STRB-Calculation] Start_Addr = %0d || Length = %0d || Size = %0d || strb_queue = %p", provided_strb, generated_strb, filtered_strb), UVM_MEDIUM)  
endfunction


task axi_driver::reset_axi_bus();
    axi_vif.ARESETn <= ACTIVATE;
    axi_vif.AWID    <= 0;   
    axi_vif.AWADDR  <= 0; 
    axi_vif.AWLEN   <= 0;  
    axi_vif.AWSIZE  <= 0; 
    axi_vif.AWBURST <= 0;
    axi_vif.AWVALID <= 0;
    axi_vif.AWLOCK  <= 0;
    axi_vif.AWCACHE <= 0;
    axi_vif.AWPROT  <= 0; 
    axi_vif.WID     <= 0;
    axi_vif.WDATA   <= 0; 
    axi_vif.WSTRB   <= 0;
    axi_vif.WLAST   <= 0; 
    axi_vif.WVALID  <= 0;
    axi_vif.BREADY  <= 0;
    axi_vif.ARID    <= 0;
    axi_vif.ARADDR  <= 0;
    axi_vif.ARLEN   <= 0;
    axi_vif.ARSIZE  <= 0;
    axi_vif.ARBURST <= 0;
    axi_vif.ARVALID <= 0;
    axi_vif.ARLOCK  <= 0;
    axi_vif.ARCACHE <= 0;
    axi_vif.ARPROT  <= 0;
    axi_vif.RREADY  <= 0; 
    repeat(2)@(negedge axi_vif.ACLK);	
    axi_vif.ARESETn <= DEACTIVATE;
    repeat(2)@(negedge axi_vif.ACLK);
endtask


