
// -------------------------------------------------------------------------------------------------------- //
// ------------------------------------------ AXI Reset Sequence ------------------------------------------ //
// ----- This sequence resets the AXI Bus
// ----- Inputs : has_reset flag to control the RESET DRIVE task
// -------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------- //

class axi_reset_sequence extends axi_sequence_base #(axi_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(axi_reset_sequence)


 // -------------------------------- //
 // ----- Constructor Function ----- //
 // -------------------------------- //
  
  function new(string name= "axi_reset_sequence");
    super.new(name);
  endfunction

  
  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    //`uvm_info(get_type_name(), "***** AXI Reset Sequence : Body Task Started  *****", UVM_MEDIUM);
    
    `uvm_do_with(axi_item, {axi_item.has_reset  == 1'b1;})
 
    //`uvm_info(get_type_name(), "***** AXI Reset Sequence : Body Task Finished *****", UVM_MEDIUM);
  endtask
    
endclass


// -------------------------------------------------------------------------------------------------------- //
// ------------------------------------- AXI Write Adderess Sequence -------------------------------------- //
// ----- This sequence does write address transfers
// ----- Inputs : AWID = address ID
// ----- Inputs : AWADDR = Allign/Unallign 
// ----- Inputs : AWLEN, AWSIZE, AWBURST
// -------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------- //

class axi_write_addr_sequence extends axi_sequence_base #(axi_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(axi_write_addr_sequence)
  
 // -------------------------------- //
 // ----- Constructor Function ----- //
 // -------------------------------- //

  function new(string name= "axi_write_addr_sequence");
    super.new(name);
  endfunction  

  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    //`uvm_info(get_type_name(), "***** AXI Write Address Sequence : Body Task Started  *****", UVM_MEDIUM);
    
    
    `uvm_do_with(axi_item, {axi_item.has_reset      == 1'b0;
                            axi_item.aw_write       == 1'b1;
                            axi_item.w_write        == 1'b0;
                            axi_item.ar_write       == 1'b0;
                            axi_item.has_delay      == aw_pkt.has_delay;                            
                           (aw_pkt.rand_id    == 0) -> axi_item.awid    == aw_pkt.awid;
                           (aw_pkt.rand_addr  == 0) -> axi_item.awaddr  == aw_pkt.awaddr; 
                           (aw_pkt.rand_len   == 0) -> axi_item.awlen   == aw_pkt.awlen; 
                           (aw_pkt.rand_size  == 0) -> axi_item.awsize  == aw_pkt.awsize;
                           (aw_pkt.rand_burst == 0) -> axi_item.awburst == aw_pkt.awburst;
                          })                  
       //feedback_addr = axi_item.awaddr;
       // #1; 
    //`uvm_info(get_type_name(), "***** AXI Write Address Sequence : Body Task Finished *****", UVM_MEDIUM);		
  endtask	

endclass


// -------------------------------------------------------------------------------------------------------- //
// ----------------------------------------- AXI Write Data Sequence -------------------------------------- //
// ----- This sequence does write data transfers
// ----- Inputs : WID = data ID : should be same as corresponding address ID
// ----- Inputs : WDATA = random
// ----- Inputs : WSTRB = depends on address and control signals
// ----- Inputs : WLAST = assert high for the last transfer
// -------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------- //


class axi_write_data_sequence extends axi_sequence_base #(axi_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(axi_write_data_sequence)

 // -------------------------------- //
 // ----- Constructor Function ----- //
 // -------------------------------- //

  function new(string name= "axi_write_data_sequence");
    super.new(name);
  endfunction
  
  
  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    //`uvm_info(get_type_name(), "***** AXI Write Data Sequence : Body Task Started  *****", UVM_MEDIUM);
  
    
    `uvm_do_with(axi_item, {axi_item.has_reset      == 1'b0;
                            axi_item.aw_write       == 1'b0;
                            axi_item.w_write        == 1'b1;
                            axi_item.ar_write       == 1'b0;
                            axi_item.has_delay      == w_pkt.has_delay;                            
                           (w_pkt.rand_data  == 0) -> axi_item.wdata == w_pkt.wdata;
                           (w_pkt.rand_wstrb == 0) -> axi_item.wstrb == w_pkt.wstrb;
                          })
    //`uvm_info(get_type_name(), "***** AXI Write Data Sequence : Body Task Finished *****", UVM_MEDIUM);		
  endtask	 


endclass


// -------------------------------------------------------------------------------------------------------- //
// ------------------------------------- AXI Read Adderess Sequence -------------------------------------- //
// ----- This sequence does read address transfers
// ----- Inputs : ARID = address ID
// ----- Inputs : ARADDR = Allign/Unallign 
// ----- Inputs : ARLEN, ARSIZE, ARBURST
// -------------------------------------------------------------------------------------------------------- //
// -------------------------------------------------------------------------------------------------------- //

class axi_read_addr_sequence extends axi_sequence_base #(axi_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(axi_read_addr_sequence)

 // -------------------------------- //
 // ----- Constructor Function ----- //
 // -------------------------------- //

  function new(string name= "axi_read_addr_sequence");
    super.new(name);
  endfunction
  
  
  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    //`uvm_info(get_type_name(), "***** AXI Read Address Sequence : Body Task Started  *****", UVM_MEDIUM);
     
    
    `uvm_do_with(axi_item, {axi_item.has_reset      == 1'b0;
                            axi_item.aw_write       == 1'b0;
                            axi_item.w_write        == 1'b0;
                            axi_item.ar_write       == 1'b1;
                            axi_item.has_delay      == ar_pkt.has_delay;                            
                           (ar_pkt.rand_id    == 0) -> axi_item.arid    == ar_pkt.arid;
                           (ar_pkt.rand_addr  == 0) -> axi_item.araddr  == ar_pkt.araddr; 
                           (ar_pkt.rand_len   == 0) -> axi_item.arlen   == ar_pkt.arlen; 
                           (ar_pkt.rand_size  == 0) -> axi_item.arsize  == ar_pkt.arsize;
                           (ar_pkt.rand_burst == 0) -> axi_item.arburst == ar_pkt.arburst;
                          })
     //`uvm_info(get_type_name(), "***** AXI Read Address Sequence : Body Task Finished *****", UVM_MEDIUM);		
  endtask	


endclass



