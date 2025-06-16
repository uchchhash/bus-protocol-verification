

class axi_sequence_item extends uvm_sequence_item;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_object_utils(axi_sequence_item)

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //  
  
  function new(string name= "axi_sequence_item");
    super.new(name);
  endfunction
  
  // --------------------------------- //
  // ---------- AXI Signals ---------- //
  // --------------------------------- //
  // ---------- GLobal Signals ---------- //
  rand logic                  aresetn;
  // ---------- Write Address Channel (AW) ---------- //
  rand logic [AWID_WIDTH-1:0] awid;    
  rand logic [ADDR_WIDTH-1:0] awaddr;
  rand logic [3:0] 	      awlen;   
  rand logic [2:0] 	      awsize;
  rand logic [1:0] 	      awburst;
  rand logic [1:0]            awlock; 
  rand logic [3:0]            awcache; 
  rand logic [2:0]            awprot;	
  rand logic 		      awvalid;
  logic 		      awready;
  // ---------- Write Data Channel (W) ---------- //	
  rand logic [ WID_WIDTH-1:0] wid;      
  rand logic [DATA_WIDTH-1:0] wdata;  
  rand logic [STRB_WIDTH-1:0] wstrb;   
  rand logic 		      wlast;   
  rand logic 		      wvalid;  
  logic 		      wready;  
  // ---------- Write Response Channel (B) ---------- //
  logic [BID_WIDTH-1:0]       bid;   
  logic [1:0] 	              bresp;   
  logic 		      bvalid;  
  rand logic 		      bready;
  // ---------- Read Address Channel (AR) ---------- //
  rand logic [ARID_WIDTH-1:0] arid;    
  rand logic [ADDR_WIDTH-1:0] araddr;  
  rand logic [3:0] 	      arlen;   
  rand logic [2:0] 	      arsize;  
  rand logic [1:0] 	      arburst; 
  rand logic [1:0]            arlock;  
  rand logic [3:0]            arcache; 
  rand logic [2:0]            arprot;  
  rand logic 		      arvalid; 
  logic 		      arready; 
  // ---------- Read Data Channel (R) ---------- //
  logic [RID_WIDTH-1:0]       rid;     
  logic [DATA_WIDTH-1:0]      rdata;   
  logic [1:0] 	              rresp;   
  logic 		      rlast;   
  logic 		      rvalid;  
  rand logic 		      rready; 

    
  // ---------- Additional Signals ---------- //
  rand logic has_reset; // control the reset sequence
  rand logic has_delay; // control the handshake delay
  rand logic w_write, aw_write, ar_write; // control the channel sequences
  bit item_really_started_e; // Sync between driver & sequencer
  bit item_really_done_e;    // Sync between driver & sequencer

  // -------------------------------- //
  // --------- CONSTRAINTS ---------- //
  // -------------------------------- //

  // ----- Transaction ID (AWID-WID-BID-ARID) ----- //
  // ---- ALL ID should stay in between 0-15 --- //
  constraint awid_constraint { awid inside {[0:2**AWID_WIDTH-1]};}
  constraint arid_constraint { arid inside {[0:2**ARID_WIDTH-1]};}
  constraint  wid_constraint {  wid inside {[0:2**WID_WIDTH-1]};}

  // ----- Write & Read Address ----- //
  // ----- for WRAP burst :: aligned address 
  // ----- for other burst :: aligned/unaligned address

  constraint awaddr_constraint { if (awburst == WRAP) awaddr % (2**awsize) == 0;}
  constraint araddr_constraint { if (arburst == WRAP) araddr % (2**arsize) == 0;}
  
 
  	constraint awaddr_range{        if(awburst == 2) awaddr%(2**awsize)==0;
                                        (awaddr)/2048 == (awaddr+((2**awsize)*(awlen+1)))/2048;
                                        (awaddr/2048)%2 == 0;
                              }


  	constraint araddr_range{        if(arburst == 2) araddr%(2**arsize)==0;
                                        (araddr)/2048 == (araddr+((2**arsize)*(arlen+1)))/2048;
                                        (araddr/2048)%2 == 0;
                               }                              
  
  // ----- Write & Read Burst Type ----- //
  constraint awburst_constraint {awburst inside {  FIXED, INCR, WRAP };}
  constraint arburst_constraint {arburst inside {  FIXED, INCR, WRAP };}

  // ----- Write & Read Transfer Length ----- //
  constraint awlen_constraint { if(awburst == WRAP) awlen inside {1,3,7,15};
                             	else awlen inside {[0:15]};}
  constraint arlen_constraint { if(arburst == WRAP) arlen inside {1,3,7,15};
                             	else arlen inside {[0:15]};}

  // ----- Write & Read Transfer Size ----- //		
  constraint awsize_constraint {awsize inside { BYTE_4, BYTE_2, BYTE_1};}
  constraint arsize_constraint {arsize inside { BYTE_4, BYTE_2, BYTE_1};}

  // -------------------------------- //
  // ----- Methods of AXI Agent ----- //
  // -------------------------------- //
  extern function void item_really_started();
  extern function void item_really_done();
  extern function string convert2string();

endclass


function void axi_sequence_item::item_really_started();
  item_really_started_e = 1;
  //`uvm_info(get_type_name(), "*** Item Really Started ***", UVM_NONE);
endfunction

function void axi_sequence_item::item_really_done();
  item_really_done_e = 1;
 // `uvm_info(get_type_name(), "*** Item Really Done ***", UVM_NONE);
endfunction


function string axi_sequence_item::convert2string();
  string string_item;
  string_item = super.convert2string();
  $sformat(string_item, "%s\n[G] aresetn = %4d  ||", string_item, aresetn);
  $sformat(string_item, "%s has_reset = %3d ||", string_item, has_reset);
  $sformat(string_item, "%s has_delay = %3d ||", string_item, has_delay);
  $sformat(string_item, "%s w_write   = %3d ||", string_item, w_write);
  $sformat(string_item, "%s aw_write  = %3d ||", string_item, aw_write);
  $sformat(string_item, "%s ar_write  = %4d\n", string_item, ar_write);
  $sformat(string_item, "%s[AW] awid   = %4d  ||", string_item, awid);
  $sformat(string_item, "%s awvalid = %4d  ||", string_item, awvalid);
  $sformat(string_item, "%s aweady  = %4d  ||", string_item, awready);
  $sformat(string_item, "%s awlen   = %4d  ||", string_item, awlen);
  $sformat(string_item, "%s awsize  = %4d  ||", string_item, awsize);
  $sformat(string_item, "%s awburst = %4d  ||", string_item, awburst);
  $sformat(string_item, "%s awlock  = %4d  ||", string_item, awlock);
  $sformat(string_item, "%s awcache = %4d  ||", string_item, awcache);
  $sformat(string_item, "%s awprot  = %4d  ||", string_item, awprot);
  $sformat(string_item, "%s awaddr  = %0d \n", string_item, awaddr);
  $sformat(string_item, "%s[ W] wvalid = %4d  ||", string_item, wvalid);
  $sformat(string_item, "%s wready  = %4d  ||", string_item, wready);
  $sformat(string_item, "%s wstrb  = %4b   ||", string_item, wstrb);
  $sformat(string_item, "%s wlast  = %4d   ||", string_item, wlast);
  $sformat(string_item, "%s wdata  = %0h \n", string_item, wdata);
  $sformat(string_item, "%s[ B] bid  = %4d    ||", string_item, bid);
  $sformat(string_item, "%s bvalid  = %4d  ||", string_item, bvalid);
  $sformat(string_item, "%s bready  = %4d  ||", string_item, bready);
  $sformat(string_item, "%s bresp = %0d \n", string_item, bresp);
  $sformat(string_item, "%s[AR] arid  = %4d   ||", string_item, arid);
  $sformat(string_item, "%s aralid  = %4d  ||", string_item, arvalid);
  $sformat(string_item, "%s aready  = %4d  ||", string_item, arready);
  $sformat(string_item, "%s arlen   = %4d  ||", string_item, arlen);
  $sformat(string_item, "%s arsize  = %4d  ||", string_item, arsize);
  $sformat(string_item, "%s arburst = %4d  ||", string_item, arburst);
  $sformat(string_item, "%s arlock  = %4d  ||", string_item, arlock);
  $sformat(string_item, "%s arcache = %4d  ||", string_item, arcache);
  $sformat(string_item, "%s arprot  = %4d  ||", string_item, arprot);
  $sformat(string_item, "%s araddr  = %0d \n", string_item, araddr);
  $sformat(string_item, "%s[ R] rid   =  %4d  ||", string_item, rid);
  $sformat(string_item, "%s rvalid = %4d   ||", string_item, rvalid);
  $sformat(string_item, "%s rready = %4d   ||", string_item, rready);
  $sformat(string_item, "%s rresp  = %4d   ||", string_item, rresp);
  $sformat(string_item, "%s rlast  = %4d   ||", string_item, rlast);
  $sformat(string_item, "%s rdata  = %0h \n", string_item, rdata);
return string_item;
  
endfunction



    
