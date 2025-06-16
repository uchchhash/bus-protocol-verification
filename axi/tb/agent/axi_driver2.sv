
class axi_driver2 extends axi_driver;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_driver2)
  
  // --------------------------------- //
  // ----- Methods of AXI Driver ----- //
  // --------------------------------- //
  extern function new(string name = "axi_driver2", uvm_component parent = null);
  extern task run_phase(uvm_phase phase);
  extern task w_channel_drive;
  extern task aw_channel_drive;

endclass : axi_driver2


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_driver2::new(string name = "axi_driver2", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Driver-2 Constructed *****", UVM_NONE);
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task axi_driver2::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "***** AXI Driver-2 : Run Phase Started  *****", UVM_MEDIUM);
  
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

   // --------------------------------------------------------------------------------------------------------------- //
   // --------------------------------- Driver-2 :: Write-Address & Data-Sequence ----------------------------------- //
   // --->> AW_Write = 1 // W_Write = 0 // AR_Write = 0 // Has_Reset = 0 // Has_Delay = 0/1 
   // --->> AWID // AWADDR // AWLEN // AWSIZE // AWBURST 
   // --->> Put aw_items in aw_outstanding & b_outstanding queue-array with awid as tag of each queue of the array
   // --->> Put aw_items in aw_tags_mb and Send it to AW Channel Driver Task 
   // --->> Need of b_outstanding :: passing the aw_item instance (item_really_done) 
   // --->> if(aw_write) :: start the AW Drive task :: by sending the awid tags through mailbox
   // --->> Store the awid_tag as wid_tag :: no WID in AXI4 :: WDATA follows AWID tags
   // --->> Put w_items in w_outstanding queue-array with the wid (awid) as tag of each queue of the array
   // --->> if(w_write)  :: start the W Drive task :: by sending the wid_tags through mailbox
   // --->> if(aw & w handshake done) :: start the B Drive task :: by sending the tag through mailbox
   // --------------------------------------------------------------------------------------------------------------- //
   forever begin
     axi_sequence_item axi_item;
     seq_item_port.get_next_item(axi_item);
     seq_item_port.item_done();
     // Receiving items from sequence & calling "item-done" immidietly to receive another item
     //`uvm_info (get_type_name(), $sformatf("Got Items @Driver-2 :: [AW_Write = %0d] [W_Write = %0d] [AR_Write = %0d] [Has_Delay = %0d]", axi_item.aw_write, axi_item.w_write, axi_item.ar_write, axi_item.has_delay), UVM_MEDIUM)        
     //`uvm_info(get_type_name(), $sformatf("[DRV-2] Got item from Sequence : %s", axi_item.convert2string), UVM_MEDIUM)        
     if(!axi_item.has_reset && (axi_item.aw_write && !axi_item.w_write)) begin
       aw_outstanding[axi_item.awid].push_back(axi_item);
       b_outstanding[axi_item.awid].push_back(axi_item);
       aw_tags_mb.put(axi_item.awid);
       wid_tag = axi_item.awid;
     end
     else if(!axi_item.has_reset && (axi_item.w_write && !axi_item.aw_write)) begin
       w_outstanding[wid_tag].push_back(axi_item);
       w_tags_mb.put(wid_tag);
     end        
     else if(!axi_item.has_reset && axi_item.ar_write) begin
       ar_outstanding[axi_item.arid].push_back(axi_item);
       r_outstanding[axi_item.arid].push_back(axi_item);
       ar_tags_mb.put(axi_item.arid);
     end
     else axi_reset(axi_item);
   end    
    
endtask


// -------------------------------------------------------------------------------------------------------------------- //
// ----------------------------------- Inidividual Tasks to Drive various Scenarios ----------------------------------- //
// -------------------------------------------------------------------------------------------------------------------- //



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


task axi_driver2::aw_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    aw_tags_mb.get(awid_tag);        
    axi_item = aw_outstanding[awid_tag].pop_front();
    if(axi_item == null) `uvm_fatal(get_type_name(), "********** No AW-outstanding Item Found **********")
    calc_nth_addr(axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst, awaddr_queue);  // Returns Nth AW-Address queue
    calc_strb(axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst, awaddr_queue, wstrb_queue); // Returns Calculated WSTRB queue
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
      `uvm_info(get_type_name(), "***** AXI Driver-2 : Waiting for AWREADY *****", UVM_DEBUG)
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
// ----- Valid inputs are driven and waits for ready
// ----- Transfer ends with WLAST signal being HIGH
// ----- Transfer ends with WVALID/WREADY handshake for AWLEN times
// ----- Put item-id to B mailbox to indicate W transfer is done, proceed to B transfer
// -------------------------------------------------------------------------------------------------- //


task axi_driver2::w_channel_drive;
  forever begin
    axi_sequence_item axi_item;
    // Get the WDATA Tag from W mailbox & Extract the Item using the WID
    for(int i=0; i<=axi_vif.AWLEN; i++) begin
      w_tags_mb.get(wid_tag);
      axi_item = w_outstanding[wid_tag].pop_front();
      if(axi_item == null) `uvm_fatal(get_type_name(), "********** No W-outstanding Item Found **********")     
      filter_strb(wstrb_queue.pop_front(), axi_item.wstrb, filtered_strb); // Returns the Effective Stobe (driven STRB vs calculated STRB)     
      axi_vif.WVALID <= 1'b1;
      axi_vif.WDATA  <= axi_item.wdata;
      axi_vif.WSTRB  <= filtered_strb;
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
    axi_vif.WVALID   <= 1'b0;
    b_tags_mb.put(wid_tag);	
  end
endtask



