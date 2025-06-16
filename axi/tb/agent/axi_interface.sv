
`include "uvm_macros.svh"
import uvm_pkg::*;
// AXI interface includes all five channel signals 
// AXI interface includes the protocol checkers
// Received the generated ACLK from tb_top

interface axi_interface(input ACLK);

    // ---------- GLobal Signals ---------- //
    logic                  ARESETn; // Input  : Active-Low-Reset

		// ---------- Write Address Channel (AW) ---------- //
		logic [AWID_WIDTH-1:0] AWID;    // Input  : Write-Address-ID 
		logic [ADDR_WIDTH-1:0] AWADDR;  // Input  : Write-Address-Bus
		logic [3:0] 	   			 AWLEN;   // Input  : Write-Burst-Length
		logic [2:0] 	   			 AWSIZE;  // Input  : Write-Burst-Size
		logic [1:0] 	   			 AWBURST; // Input  : Write-Burst-Type
		logic 		   			 		 AWVALID; // Input  : Write-Address-Valid
		logic 		   					 AWREADY; // Output : Write-Address-Ready
		logic [1:0]            AWLOCK;  // Input  : Write-Lock-Type           // not available in design
		logic [3:0]            AWCACHE; // Input  : Write-Cache-Type          // not available in design
		logic [2:0]            AWPROT;  // Input  : Write-Protection-Type	    // not available in design

    // ---------- Write Data Channel (W) ---------- //	
    logic [ WID_WIDTH-1:0] WID;     // Input  : Write-Data-ID               // not available in design
    logic [DATA_WIDTH-1:0] WDATA;   // Input  : Write-Data-Bus
    logic [STRB_WIDTH-1:0] WSTRB;   // Input  : Write-Data-Strobe
    logic 		   					 WVALID;  // Input  : Write-Data-Valid
    logic 		   					 WREADY;  // Output : Write-Data-Ready
    logic 		   					 WLAST;   // Input  : Write-Data-Last             // not available in design


    // ---------- Write Response Channel (B) ---------- //
    logic [BID_WIDTH-1:0]  BID;     // Output : Write-Response-ID
    logic [1:0] 	         BRESP;   // Output : Write-Response-Type
    logic 		   					 BVALID;  // Output : Write-Response-Valid
    logic 		   					 BREADY;  // Input  : Write-Response-Ready

    // ---------- Read Address Channel (AW) ---------- //
    logic [ARID_WIDTH-1:0] ARID;    // Input  : Read-Address-ID
    logic [ADDR_WIDTH-1:0] ARADDR;  // Input  : Read-Address-Bus
    logic [3:0] 	   			 ARLEN;   // Input  : Read-Burst-Length 
    logic [2:0] 	   			 ARSIZE;  // Input  : Read-Burst-Size 
    logic [1:0] 	   			 ARBURST; // Input  : Read-Burst-Type
    logic 		   					 ARVALID; // Input  : Read-Address-Valid
    logic 		   					 ARREADY; // Output : Read-Address-Ready
    logic [1:0]            ARLOCK;  // Input  : Read-Lock-Type              // not available in design
    logic [3:0]            ARCACHE; // Input  : Read-Cache-Type             // not available in design
    logic [2:0]            ARPROT;  // Input  : Read-Protection-Type        // not available in desgin

    //----- Read Data Channel (R) -----//
    logic [RID_WIDTH-1:0]  RID;     // Output : Read-Data-ID
    logic [DATA_WIDTH-1:0] RDATA;   // Output : Read-Data-Bus
    logic [1:0] 	   			 RRESP;   // Output : Read-Response-Type
    logic 		   					 RLAST;   // Output : Read-Data-Last
    logic 		   					 RVALID;  // Output : Read-Data-Valid
    logic 		   					 RREADY;  // Input  : Read-Data-Ready

    //----- Low Power Interface -----//
    logic                  CSYSREQ; // Input  : Low power request
    logic                  CSYSACK; // Output : Low power acknowledge
    logic                  CACTIVE; // Output : Peripheral active

    //----- Scan Insertion Dummy Pins -----//
    logic                  SCANENABLE;   // Input  : Enable scan test mode
    logic                  SCANINACLK;   // Input  : Scan data input
    logic                  SCANOUTACLK;  // Output : Scan data output 

    //----- Module Specific Signals -----//
    logic [7:0]            SlaveEnum;    // Input : Slave Enumeration ID

    assign CSYSREQ    = 0;
    assign SCANENABLE = 0;
    assign SCANINACLK = 0;
    assign SlaveEnum  = 0;


		// ------------------------------------------ //
		// --------- AXI4 Slave Assertions ---------- //
		// ------------------------------------------ //

	//	string valid_signals[5] = {"AWVALID", "WVALID", "BVALID", "ARVALID", "RVALID"};
	//	string ready_signals[5] = {"AWREADY", "WREADY", "BREADY", "ARREADY", "RREADY"};




		// ----- axi_valid_reset_x_chk ----- //
    // --> all valid signals must remain in known state while not in reset	
		// --> A value of X on AWVALID, WVALID, BVALID, ARVALID, RVALID is not permitted when not in reset

		// ----- axi_ready_reset_x_chk	----- //
    // --> all ready signals must remain in known state while not in reset
    // --> A value of X on AWREADY, WREADY, BREADY, ARREADY, RREADY is not permitted when not in reset


/*
		// ----- axi_handshake_chk	----- //
		// --> all valid signals must remain asserted until corresponding ready signals are high	
		// --> When AWVALID, WVALID, BVALID, ARVALID, RVALID is asserted, then it must remain asserted until AWREADY, WREADY, BREADY, ARREADY, RREADY is HIGH

		property AW_handshake_property;	
			@(posedge ACLK) WVALID |-> (WVALID[*1:$]) ##0 WREADY;
		endproperty

		property  W_handshake_property;	
			@(posedge ACLK) WVALID |-> (WVALID[*1:$]) ##0 WREADY;
		endproperty

		property  B_handshake_property;	
			@(posedge ACLK) BVALID |-> (BVALID[*1:$]) ##0 BREADY;
		endproperty

		property AR_handshake_property;	
			@(posedge ACLK) ARVALID |-> (ARVALID[*1:$]) ##0 ARREADY;
		endproperty

		property  R_handshake_property;	
			@(posedge ACLK) RVALID |-> (RVALID[*1:$]) ##0 RREADY;
		endproperty

		AW_handshake_CHK : assert property (AW_handshake_property)
			`uvm_info("AXI_VIF", "## ASSERT : Passed ## :: AWVALID remains asserted until AWREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ASSERT : Failed ## :: AWVALID does not remain asserted until AWREADY is HIGH")

		W_handshake_CHK : assert property (W_handshake_property)
			`uvm_info("AXI_VIF", "## ASSERT : Passed ## :: WVALID remains asserted until WREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ASSERT : Failed ## :: WVALID does not remain asserted until WREADY is HIGH")

		B_handshake_CHK : assert property (B_handshake_property)
			`uvm_info("AXI_VIF", "## ASSERT : Passed ## :: BVALID remains asserted until BREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ASSERT : Failed ## :: BVALID does not remain asserted until BREADY is HIGH")

		AR_handshake_CHK : assert property (AR_handshake_property)
			`uvm_info("AXI_VIF", "## ASSERT : Passed ## :: ARVALID remains asserted until ARREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ASSERT : Failed ## :: ARVALID does not remain asserted until ARREADY is HIGH")

		R_handshake_CHK : assert property (R_handshake_property)
			`uvm_info("AXI_VIF", "## ASSERT : Passed ## :: RVALID remains asserted until RREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ASSERT : Failed ## :: RVALID does not remain asserted until RREADY is HIGH")

*/

		// ---- axi_aw_stable_chk	----- //
		// --> all write-address channel signals must remain stable when valid is asserted and ready is low
		// --> AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWLOCK, AWCACHE, AWPROT, AWQOS, AWREGION, AWUSER remains stable when AWVALID is asserted and AWREADY is LOW

/*
		property aw_stable_property;
			@(posedge ACLK) 
			disable iff (!ARESETn)			
			(AWVALID && !AWREADY)	##0 $stable(AWADDR);	
		endproperty

		aw_stable_CHK : assert property (aw_stable_property)
			`uvm_info("AXI_VIF", "## ==========ASSERT : Passed ## :: AWID remains stable when valid is asserted and ready is low", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ==========ASSERT : Failed ## :: AWID does not remain stable when valid is asserted and ready is low")	






		property  W_handshake_property;	
			@(posedge ACLK) WVALID |-> (WVALID[*1:$]) ##0 WREADY;
		endproperty

		property  B_handshake_property;	
			@(posedge ACLK) BVALID |-> (BVALID[*1:$]) ##0 BREADY;
		endproperty

		W_handshake_CHK : assert property (W_handshake_property)
			`uvm_info("AXI_VIF", "## ==========ASSERT : Passed ## :: WVALID remains asserted until WREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ==========ASSERT : Failed ## :: WVALID does not remain asserted until WREADY is HIGH")

		B_handshake_CHK : assert property (B_handshake_property)
			`uvm_info("AXI_VIF", "## ==========ASSERT : Passed ## :: BVALID remains asserted until BREADY is HIGH", UVM_MEDIUM)
			else `uvm_error("AXI_VIF", "## ==========ASSERT : Failed ## :: BVALID does not remain asserted until BREADY is HIGH")


	property axi_handshake_property;
		@(posedge ACLK)
		foreach (valid_signal, ready_signal) {
		  valid_signal |-> (valid_signal[*1:$]) ##0 ready_signal;
		}
	endproperty

	AW_handshake_CHK : assert property (axi_handshake_property)
*/





endinterface




 			    			


