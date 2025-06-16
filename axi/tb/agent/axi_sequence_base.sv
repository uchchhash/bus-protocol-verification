

class axi_sequence_base #(type T = int) extends uvm_sequence#(T);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_param_utils(axi_sequence_base#(T))

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  axi_sequence_item axi_item;

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // ----- Write Address Channel (AW) ----- //
  bit [AWID_WIDTH-1:0] awid;    
  bit [ADDR_WIDTH-1:0] awaddr;  
  bit [3:0] 	       awlen;   
  bit [2:0] 	       awsize;  
  bit [1:0] 	       awburst;  	
  bit		       awvalid;
  // ----- Write Data Channel (W) ----- //	
  bit [WID_WIDTH-1:0] wid;
  bit [DATA_WIDTH-1:0] wdata;  
  bit [STRB_WIDTH-1:0] wstrb; 
  bit		       wvalid; 
  // ----- Write Response Channel (B) ----- //
  bit 		       bready;  
  // ----- Read Address Channel (AW) ----- //
  bit [ARID_WIDTH-1:0] arid;   
  bit [ADDR_WIDTH-1:0] araddr; 
  bit [3:0] 	       arlen;  
  bit [2:0] 	       arsize; 
  bit [1:0] 	       arburst; 
  bit 		       arvalid;
  // ----- Read Data Channel (R) ----- //
  bit 		       rready; 

  // ----- Additional Signals ------ //
  bit has_delay;

  // ---- Item Struct Instances ------//
  aw_struct aw_pkt;
  w_struct w_pkt;
  ar_struct ar_pkt;

  bit [31:0] feedback_addr;


  // ---------------------------------------- //
  // ----- Methods of AXI Base Sequence ----- //
  // ---------------------------------------- //
  extern function new(string name = "axi_sequence_base");	
  extern task finish_item(uvm_sequence_item item, int set_priority = -1);
  extern task body;

endclass


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_sequence_base::new(string name = "axi_sequence_base");
  super.new(name);
 // `uvm_info(get_type_name(), "***** AXI Base Sequence : Constructed *****", UVM_NONE);	
endfunction	


// -------------------------------- //
// ----- Sequence : Body Task ----- //
// -------------------------------- //
task axi_sequence_base::body();
  `uvm_info(get_type_name(), "***** AXI Base Sequence : Body Task Started  *****", UVM_MEDIUM);
  `uvm_info(get_type_name(), "***** AXI Base Sequence : Body Task Finished *****", UVM_MEDIUM);		
endtask	


task axi_sequence_base::finish_item(uvm_sequence_item item, int set_priority = -1);
  T trans_t;
  super.finish_item(item);
  if ($cast(trans_t, item)) begin			
    wait(trans_t.item_really_started_e == 1); //`uvm_info(get_type_name(), "***** Waiting for Item Really Started *****", UVM_MEDIUM);
    wait(trans_t.item_really_done_e == 1);    // `uvm_info(get_type_name(), "***** Waiting for Item Really Done *****", UVM_MEDIUM);
  end
endtask





