class ahb_sequence_item extends uvm_sequence_item;
  
 // `uvm_object_utils(ahb_sequence_item)
  
  	function new(string name = "ahb_sequence_item");
      super.new(name);
    //  `uvm_info(get_type_name(), "AHB Sequence Item Constructed", UVM_MEDIUM)
    endfunction

  
    //---- Data and Address ----//
    rand bit [`addrWidth-1:0] start_address;
  	rand bit [`dataWidth-1:0] write_data; 
  	bit [`dataWidth-1:0] read_data;
    bit [31:0] RDATA;


    //--- Read and Write Data Captured ---//
  	bit [7:0]  capture_byte;
    bit [15:0] capture_halfword;
    bit [31:0] capture_word;
    bit [31:0] capture_data;
 
  	//---- Control Signals ----//
  	rand bit [1:0] htrans;
  	rand bit [2:0] hsize;
  	rand bit [2:0] hburst;
  	rand bit hselx;
  	rand bit hwrite;
  	rand bit hresetn;
  	
    bit hresp;
  	bit hready;

    //----- External Controls ---//
    bit has_reset;
    rand bit trdone;
    rand bit rnd_test;
    rand bit rnd;
    rand bit bsy;

    //----- Alligned Address Generation -----//
    rand bit [`addrWidth-1:0] allignedAddr;
    constraint addrWord_range { allignedAddr inside {[0:1000000000]} && allignedAddr % 4 == 0; }

    `uvm_object_utils_begin(ahb_sequence_item)
        `uvm_field_int  (start_address, UVM_ALL_ON)
        `uvm_field_int  (write_data,    UVM_ALL_ON)
        `uvm_field_int  (read_data,     UVM_ALL_ON)
        `uvm_field_int  (hselx,   UVM_BIN)
        `uvm_field_int  (hresetn, UVM_BIN)
        `uvm_field_int  (hwrite,  UVM_BIN)
        `uvm_field_int  (hsize,   UVM_BIN)
        `uvm_field_int  (hburst,  UVM_DEC)
        `uvm_field_int  (htrans,  UVM_DEC)
    `uvm_object_utils_end

    function void sender(input string itemType, input string sender, input string receiver); 
         $display("-----------------------------------------------------------------------");   
         $display("@[%0t] ---- %s Sending %s item to %s ||-->>", $time, sender, itemType, receiver);
         $display("-----------------------------------------------------------------------");
    endfunction

    function void receiver(input string itemType, input string receiver, input string sender); 
         $display("-----------------------------------------------------------------------");   
         $display("@[%0t] ---- %s Receiving %s item from %s ||-->>", $time, receiver, itemType, sender);
         $display("-----------------------------------------------------------------------");
    endfunction



endclass
