module axi4_assert 
  (
  // Global Signals
   ACLK,
   ARESETn,

   // Write Address Channel
   AWID,
   AWADDR,
   AWLEN,
   AWSIZE,
   AWBURST,
   AWVALID,
   AWREADY,
   			    			
   // Write Data Channel
   WDATA,
   WSTRB,
   WVALID,
   WREADY, 

   // Write Response Channel
   BID,
   BRESP,
   BVALID,
   BREADY,

   // Read Address Channel
   ARID,
   ARADDR,
   ARLEN,
   ARSIZE,
   ARBURST,
   ARVALID,
   ARREADY,

   // Read Channel
   RID,
   RLAST,
   RDATA,
   RRESP,
   RVALID,
   RREADY,

 );


  // ---------- GLobal Signals ---------- //
  input wire                  ARESETn; // Input  : Active-Low-Reset
  input wire                  ACLK;    // Input : AXI Clock
  // ---------- Write Address Channel (AW) ---------- //
  input wire [AWID_WIDTH-1:0] AWID;    // Input  : Write-Address-ID 
  input wire [ADDR_WIDTH-1:0] AWADDR;  // Input  : Write-Address-Bus
  input wire [3:0] 	      AWLEN;   // Input  : Write-Burst-Length
  input wire [2:0] 	      AWSIZE;  // Input  : Write-Burst-Size
  input wire [1:0] 	      AWBURST; // Input  : Write-Burst-Type
  input wire 		      AWVALID; // Input  : Write-Address-Valid
  input wire 	    	      AWREADY; // Output : Write-Address-Ready

  // ---------- Write Data Channel (W) ---------- //	
  input wire [DATA_WIDTH-1:0] WDATA;   // Input  : Write-Data-Bus
  input wire [STRB_WIDTH-1:0] WSTRB;   // Input  : Write-Data-Strobe
  input wire                  WVALID;  // Input  : Write-Data-Valid
  input wire                  WREADY;  // Output : Write-Data-Ready

  // ---------- Write Response Channel (B) ---------- //
  input wire [BID_WIDTH-1:0]  BID;     // Output : Write-Response-ID
  input wire [1:0] 	      BRESP;   // Output : Write-Response-Type
  input wire 		      BVALID;  // Output : Write-Response-Valid
  input wire 		      BREADY;  // Input  : Write-Response-Ready

  // ---------- Read Address Channel (AW) ---------- //
  input wire [ARID_WIDTH-1:0] ARID;    // Input  : Read-Address-ID
  input wire [ADDR_WIDTH-1:0] ARADDR;  // Input  : Read-Address-Bus
  input wire [3:0]            ARLEN;   // Input  : Read-Burst-Length 
  input wire [2:0]            ARSIZE;  // Input  : Read-Burst-Size 
  input wire [1:0]            ARBURST; // Input  : Read-Burst-Type
  input wire 	              ARVALID; // Input  : Read-Address-Valid
  input wire 	              ARREADY; // Output : Read-Address-Ready

  //----- Read Data Channel (R) -----//
  input wire [RID_WIDTH-1:0]  RID;     // Output : Read-Data-ID
  input wire [DATA_WIDTH-1:0] RDATA;   // Output : Read-Data-Bus
  input wire [1:0] 	      RRESP;   // Output : Read-Response-Type
  input wire		      RLAST;   // Output : Read-Data-Last
  input wire		      RVALID;  // Output : Read-Data-Valid
  input wire		      RREADY;  // Input  : Read-Data-Ready


 // initial begin
   // $assertcontrol(4, 1, 1);
 // end






  // ------------------------------------------------------------------------------------------------------------------------------------------------ //
  // ------------------------------------------------------- Write-Address-Channel-Assertions ------------------------------------------------------- //
  // ------------------------------------------------------------------------------------------------------------------------------------------------ //

  // ==================================================================================================== //
  // ========================================= Functional Rules ========================================= //
  // ==================================================================================================== //
  
  // ==================================================================================================== //
  // ==> CHK :: AXI4_ERRM_AWVALID_RESET :: AWVALID is LOW for the first cycle after ARESETn goes HIGH
  // ==================================================================================================== //

  property AXI4_ERRM_AWVALID_RESET;
    @(posedge ACLK) 
    !(ARESETn) & !($isunknown(ARESETn))
    ##1 ARESETn |-> !AWVALID;     
  endproperty

  //axi4_errm_awvalid_reset: assert property (AXI4_ERRM_AWVALID_RESET) 
   //`uvm_info("AXI4_ASSERT", " ######## Passed ###### :: AWVALID is low for the first cycle after ARESETn goes High", UVM_MEDIUM)
   //else `uvm_error("AXI4_ASSERT", " ######## Failed ######## :: AWVALID is not low for the first cycle after ARESETn goes High" )


  // ========= ASSERT :: AXI4_ERRM_AWADDR_BOUNDARY ========= //
  // 4kbyte boundary: only bottom twelve bits (11 to 0) can change
  // Only need to check INCR bursts since:
  // -> FIXED bursts cannot violate the 4kB boundary by definition
  // -> WRAP bursts always stay within a <4kB region because of the wrap address boundary.  
  // -> The biggest WRAP burst possible has length 16, size 128 bytes (1024 bits), so it can transfer 2048 bytes. 
  // -> The individual transfer addresses wrap at a 2048 byte address boundary,
  // -> and the max data transferred in also 2048 bytes, so a 4kB boundary can never be broken.
  // ======================================================== //


  // ========= ASSERT :: AXI4_ERRM_AWADDR_WRAP_ALIGN ======== //
  // ==> A write transaction with burst type WRAP has an aligned address
  // ======================================================== //

  property AXI4_ERRM_AWADDR_WRAP_ALIGN;
    @(posedge ACLK) disable iff (!ARESETn)
    !($isunknown({AWVALID,AWBURST,AWADDR})) & AWVALID & AWREADY & (AWBURST == WRAP)
    |-> (AWADDR % (2**AWSIZE) == 0);
  endproperty


    //axi4_errm_awaddr_wrap_align: assert property (AXI4_ERRM_AWADDR_WRAP_ALIGN)
      //`uvm_info("AXI4_ASSERT", " ######## Passed ###### :: AWADDR is aligned during WRAP write transfer", UVM_MEDIUM)
     // else `uvm_error("AXI4_ASSERT", " ######## Failed ######## :: AWADDR is not aligned during WRAP write transfer" )


  // ========= ASSERT :: AXI4_ERRM_AWBURST ================== //
  // ==> A value of 2'b11 on AWBURST is not permitted when AWVALID is HIGH
  // ======================================================== //
  
  property AXI4_ERRM_AWBURST;
    @(posedge ACLK) disable iff (!ARESETn)
      !($isunknown({AWVALID,AWBURST})) & AWVALID & AWREADY
      |-> ##0 (AWBURST != 2'b11);
  endproperty


  // axi4_errm_awburst: assert property (AXI4_ERRM_AWBURST)
    //`uvm_info("AXI4_ASSERT", " ######## Passed ######  :: AWBURST is not 2'b11 during write transfer", UVM_MEDIUM)
  //   else `uvm_error("AXI4_ASSERT", "  ######## Failed ########  :: AWBURST is 2'b11 during write transfer" )


  // ========= ASSERT :: AXI4_ERRM_AWLEN_FIXED ============== //
  // ==> Transactions of burst type FIXED cannot have a length greater than 16 beats
  // ======================================================== //

  property AXI4_ERRM_AWLEN_FIXED;
    @(posedge ACLK) disable iff (!ARESETn)
      !($isunknown({AWVALID,AWLEN,AWBURST})) & AWVALID & AWREADY & (AWBURST == FIXED)
      |-> ##0 (AWLEN < 16);
  endproperty

 //  axi4_errm_awlen_fixed: assert property (AXI4_ERRM_AWLEN_FIXED)	
   //  `uvm_info("AXI4_ASSERT", " Passed ## :: AWLEN is less than 16 during FIXED write transfer", UVM_MEDIUM)
   //  else `uvm_error("AXI4_ASSERT", " Failed ## :: AWLEN is not less than 16 during FIXED write transfer" )


  // ========= ASSERT :: AXI4_ERRM_AWLEN_WRAP =============== //
  // ==> A write transaction with burst type WRAP has a length of 2, 4, 8, or 16
  // ======================================================== //

  property AXI4_ERRM_AWLEN_WRAP;
    @(posedge ACLK) disable iff (!ARESETn)
      !($isunknown({AWVALID,AWLEN,AWBURST})) & AWVALID & AWREADY & (AWBURST == WRAP)
      |-> ##0 (AWLEN == 1 || AWLEN == 3 || AWLEN == 7 || AWLEN == 15);
  endproperty


 //   axi4_errm_awlen_wrap: assert property (AXI4_ERRM_AWLEN_WRAP)
  //   `uvm_info("AXI4_ASSERT", " Passed ## :: AWLEN is in valid range during WRAP write transfer", UVM_MEDIUM)
//     else `uvm_error("AXI4_ASSERT", " Failed ## :: AWLEN is not in valid range during WRAP write transfer" )


  // ========= ASSERT :: AXI4_ERRM_AWSIZE =================== //
  // ==> The size of a write transfer does not exceed the width of the data interface
  // ======================================================== //
  property AXI4_ERRM_AWSIZE;
    @(posedge ACLK) disable iff (!ARESETn)
      !($isunknown({AWVALID,AWSIZE})) & AWVALID & AWREADY
      |-> ##0 (2**(AWSIZE+2) <= DATA_WIDTH);
  endproperty

  //  axi4_errm_awsize: assert property (AXI4_ERRM_AWSIZE)
   //   `uvm_info("AXI4_ASSERT", " Passed ## :: Write Transfer Size does not exceed the DATA width", UVM_MEDIUM)
   //   else `uvm_error("AXI4_ASSERT", " Failed ## :: Write Transfer Size exceeds the DATA width" )


  // ========= ASSERT :: AXI4_ERRM_AWLEN_LOCK =================== //
  // ==> Exclusive access transactions cannot have a length greater than 16 beats
  // ======================================================== //

  // ========= ASSERT :: AXI4_ERRM_AWCACHE =================== //
  // ==> When AWVALID is HIGH and AWCACHE[1] is LOW, then AWCACHE[3:2] are also LOW
  // ======================================================== //


  // ==================================================================================================== //
  // ========================================= Handshake Rules  ========================================= //
  // ==================================================================================================== //

  // =========  ASSERT :: AXI4_ERRM_AWVALID_STABLE   =================== //
  // ==> When AWVALID is asserted, then it remains asserted until AWREADY is HIGH
  // ============================================================================== //

  // =========  ASSERT :: AXI4_ERRM_AWID_STABLE      =================== //
  // ==> AWID must remain stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //

  property AXI4_ERRM_AWID_STABLE;
    @(posedge ACLK)
      !($isunknown({AWVALID,AWREADY,AWBURST})) &
      ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWID);
  endproperty
  //axi4_errm_awid_stable: assert property (AXI4_ERRM_AWID_STABLE)
  // `uvm_info("AXI4_ASSERT", " Passed ## :: AWID is stable while AWVALID is asserted and AWREADY is Low", UVM_MEDIUM)
  // else `uvm_error("AXI4_ASSERT", " Failed ## :: AWID is not stable while AWVALID is asserted and AWREADY is Low" )


  // =========  ASSERT :: AXI4_ERRM_AWADDR_STABLE    =================== //
  // ==> AWADDR remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //
  property AXI4_ERRM_AWADDR_STABLE;
    @(posedge ACLK)
      !($isunknown({AWVALID,AWREADY,AWADDR})) &
      ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWADDR);
  endproperty
  //axi4_errm_awaddr_stable: assert property (AXI4_ERRM_AWADDR_STABLE)
  // `uvm_info("AXI4_ASSERT", " Passed ## :: AWADDR is stable while AWVALID is asserted and AWREADY is Low", UVM_MEDIUM)
  // else `uvm_error("AXI4_ASSERT", " Failed ## :: AWADDR is not stable while AWVALID is asserted and AWREADY is Low" )


  // =========  ASSERT :: AXI4_ERRM_AWLEN_STABLE     =================== //
  // ==> AWLEN remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //

  property AXI4_ERRM_AWLEN_STABLE;
    @(posedge ACLK)
      !($isunknown({AWVALID,AWREADY,AWBURST})) &
      ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWLEN);
  endproperty
  //axi4_errm_awlen_stable: assert property (AXI4_ERRM_AWLEN_STABLE)
  // `uvm_info("AXI4_ASSERT", " Passed ## :: AWLEN is stable while AWVALID is asserted and AWREADY is Low", UVM_MEDIUM)
  // else `uvm_error("AXI4_ASSERT", " Failed ## :: AWLEN is not stable while AWVALID is asserted and AWREADY is Low" )




  // =========  ASSERT :: AXI4_ERRM_AWSIZE_STABLE    =================== //
  // ==> AWSIZE remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //
  property AXI4_ERRM_AWSIZE_STABLE;
    @(posedge ACLK)
      !($isunknown({AWVALID,AWREADY,AWBURST})) &
      ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWSIZE);
  endproperty
  // axi4_errm_awsize_stable: assert property (AXI4_ERRM_AWSIZE_STABLE)
  // `uvm_info("AXI4_ASSERT", " Passed ## :: AWSIZE is stable while AWVALID is asserted and AWREADY is Low", UVM_MEDIUM)
  // else `uvm_error("AXI4_ASSERT", " Failed ## :: AWSIZE is not stable while AWVALID is asserted and AWREADY is Low" )


  // =========  ASSERT :: AXI4_ERRM_AWBURST_STABLE   =================== //
  // ==> AWBURST remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //
  property AXI4_ERRM_AWBURST_STABLE;
    @(posedge ACLK)
      !($isunknown({AWVALID,AWREADY,AWBURST})) &
      ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWBURST);
  endproperty
 //  axi4_errm_awburst_stable: assert property (AXI4_ERRM_AWBURST_STABLE)
   // `uvm_info("AXI4_ASSERT", " Passed ## :: AWBURST is stable while AWVALID is asserted and AWREADY is Low", UVM_MEDIUM)
   // else `uvm_error("AXI4_ASSERT", " Failed ## :: AWBURST is not stable while AWVALID is asserted and AWREADY is Low" )


  // =========  ASSERT :: AXI4_ERRM_AWLOCK_STABLE    =================== //
  // ==> AWLOCK remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWCACHE_STABLE   =================== //
  // ==> AWCACHE remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWPROT_STABLE    =================== //
  // ==> AWPROT remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWUSER_STABLE    =================== //
  // ==> AWUSER remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWQOS_STABLE     =================== //
  // ==> AWQOS remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWREGION_STABLE  =================== //
  // ==> AWREGION remains stable when AWVALID is asserted and AWREADY is LOW
  // ============================================================================== //


  // =========  ASSERT :: AXI4_RECS_AWREADY_MAX_WAIT =================== //
  // ==> Recommended that AWREADY is asserted within MAXWAITS cycles of AWVALID being asserted
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWUSER_TIEOFF    =================== //
  // ==> AWUSER must be stable when AWUSER_WIDTH has been set to zero
  // ============================================================================== //


  // =========  ASSERT :: AXI4_ERRM_AWID_TIEOFF      =================== //
  // ==> AWID must be stable when ID_WIDTH has been set to zero
  // ============================================================================== //




  // -------------------------------------------------------------------------------------------------------------------------------------------- //
  // ------------------------------------------------------- Read-Address-Channel-Assertions ---------------------------------------------------- //
  // -------------------------------------------------------------------------------------------------------------------------------------------- //



  // ==> AXI4_ERRM_ARID_STABLE 
  // ==> ARID remains stable when ARVALID is asserted, and ARREADY is LOW
  property AXI4_ERRM_ARID_STABLE;
    @(posedge ACLK) disable iff(!ARESETn)
    !($isunknown({ARVALID, ARREADY, ARID})) & ARVALID & !ARREADY
    ##1 ARESETn |-> $stable(RID);
  endproperty
  //axi_errm_arid_stable : assert property (AXI4_ERRM_ARID_STABLE)
    //`uvm_info("AXI4_ASSERT", "#### Passed #### :: ARID remains stable when ARVALID is asserted, and ARREADY is LOW", UVM_MEDIUM)
    //else `uvm_error("AXI4_ASSERT", "#### Failed #### :: ARID remains stable when ARVALID is asserted, and ARREADY is LOW" )


  // ==> AXI4_ERRM_ARADDR_STABLE 
  // ==> ARADDR remains stable when ARVALID is asserted and ARREADY is LOW
  property AXI4_ERRM_ARADDR_STABLE;
    @(posedge ACLK) disable iff (!ARESETn)
    !($isunknown({ARVALID, ARREADY, ARADDR})) & ARVALID & !ARREADY
    ##1 ARESETn |-> $stable(ARADDR);
  endproperty
  //axi_errm_araddr_stable : assert property (AXI4_ERRM_ARADDR_STABLE)
    //`uvm_info("AXI4_ASSERT", "#### Passed #### :: ARADDR remains stable when ARVALID is asserted, and ARREADY is LOW", UVM_MEDIUM)
    //else `uvm_error("AXI4_ASSERT", "#### Failed #### :: ARADDR remains stable when ARVALID is asserted, and ARREADY is LOW" )


  // ==> AXI4_ERRM_ARLEN_STABLE 
  // ==> ARLEN remains stable when ARVALID is asserted and ARREADY is LOW
  property AXI4_ERRM_ARLEN_STABLE;
    @(posedge ACLK) disable iff(!ARESETn)
    !($isunknown({ARVALID, ARREADY, ARLEN})) & ARVALID & !ARREADY
    ##1 ARESETn |-> $stable(ARLEN);
  endproperty
  //axi_errm_arlen_stable : assert property (AXI4_ERRM_ARLEN_STABLE)
    //`uvm_info("AXI4_ASSERT", "#### Passed #### :: ARLEN remains stable when ARVALID is asserted, and ARREADY is LOW", UVM_MEDIUM)
    //else `uvm_error("AXI4_ASSERT", "#### Failed #### :: ARLEN remains stable when ARVALID is asserted, and ARREADY is LOW" )

  // ==> AXI4_ERRM_ARSIZE_STABLE 
  // ==> ARSIZE remains stable when ARVALID is asserted, and ARREADY is LOW Section A3.2.1 -
  property AXI4_ERRM_ARSIZE_STABLE;
    @(posedge ACLK) disable iff(!ARESETn)
    !($isunknown({ARVALID, ARREADY, ARLEN})) & ARVALID & !ARREADY
    ##1 ARESETn |-> $stable(ARSIZE);
  endproperty
  axi_errm_arsize_stable : assert property (AXI4_ERRM_ARSIZE_STABLE)
    `uvm_info("AXI4_ASSERT", "#### Passed #### :: ARSIZE remains stable when ARVALID is asserted, and ARREADY is LOW", UVM_MEDIUM)
    else `uvm_error("AXI4_ASSERT", "#### Failed #### :: ARSIZE remains stable when ARVALID is asserted, and ARREADY is LOW" )
  
  
  // ==> AXI4_ERRM_ARBURST_STABLE 
  // ==> ARBURST remains stable when ARVALID is asserted, and ARREADY is LOW Section A3.2.1 -
  property AXI4_ERRM_ARBURST_STABLE;
    @(posedge ACLK) disable iff(!ARESETn)
    !($isunknown({ARVALID, ARREADY, ARLEN})) & ARVALID & !ARREADY
    ##1 ARESETn |-> $stable(ARBURST);
  endproperty
  axi_errm_arburst_stable : assert property (AXI4_ERRM_ARBURST_STABLE)
    `uvm_info("AXI4_ASSERT", "#### Passed #### :: ARBURST remains stable when ARVALID is asserted, and ARREADY is LOW", UVM_MEDIUM)
    else `uvm_error("AXI4_ASSERT", "#### Failed #### :: ARBURST remains stable when ARVALID is asserted, and ARREADY is LOW" )





  // -------------------------------------------------------------------------------------------------------------------------------------------- //
  // ------------------------------------------------------- Read-Data-Channel-Assertions ------------------------------------------------------- //
  // -------------------------------------------------------------------------------------------------------------------------------------------- //
  
  // ===== Handshake Rules ===== //
  // ==> AXI4_ERRS_RDATA_STABLE ::
  // ==> RDATA remains stable when RVALID is asserted, and RREADY is LOW.
  property AXI4_ERRS_RDATA_STABLE;
    @(posedge ACLK) disable iff(!ARESETn)
    !($isunknown({RVALID,RREADY,RDATA})) & RVALID & !RREADY
    ##1 ARESETn |-> $stable(RDATA);
  endproperty
  //axi4_errs_rdata_stable : assert property (AXI4_ERRS_RDATA_STABLE)
    //`uvm_info("AXI4_ASSERT", "#### Passed #### :: RDATA remains stable when RVALID is asserted, and RREADY is LOW.", UVM_MEDIUM)
    //else `uvm_error("AXI4_ASSERT", "#### Failed #### :: RDATA does not remain stable when RVALID is asserted, and RREADY is LOW." )


  // ==> AXI4_ERRS_RID_STABLE ::
  // ==> RID remains stable when RVALID is asserted, and RREADY is LOW.
  property AXI4_ERRS_RID_STABLE;
    @(posedge ACLK) disable iff(!ARESETn)
    !($isunknown({RVALID, RREADY, RID})) & RVALID & !RREADY
    ##1 ARESETn |-> $stable(RID);
  endproperty
  //axi4_errs_rid_stable : assert property (AXI4_ERRS_RID_STABLE)
    //`uvm_info("AXI4_ASSERT", "#### Passed #### :: RID remains stable when RVALID is asserted, and RREADY is LOW.", UVM_MEDIUM)
    //else `uvm_error("AXI4_ASSERT", "#### Failed #### :: RID does not remain stable when RVALID is asserted, and RREADY is LOW." )


endmodule

