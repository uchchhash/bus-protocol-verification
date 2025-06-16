//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//     (C) COPYRIGHT 2004 ARM Limited
//           ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : EgSlaveAxi.v,v
//  File Revision       : 1.29
//
//  Release Information : BP143-MN-22001-r0p0-00bet0
//
//  ----------------------------------------------------------------------------
//  Purpose             : An example AXI slave
//
//  --========================================================================--




`timescale 1ns / 1ps

`include "Axi.v"
`include "EgSlaveAxiUAddr.v"
`include "EgSlaveAxiAGen.v"
`include "EgSlaveCIf.v"
`include "EgSlaveFn.v"
`include "EgSlaveRIf.v"
`include "EgSlaveWIf.v"

module EgSlaveAxi (

                   // Global Signals 
                   ACLK, 
                   ARESETn, 
                 
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
                 
                   // Write Address Channel 
                   AWID,
                   AWADDR, 
                   AWLEN, 
                   AWSIZE, 
                   AWBURST, 
                   AWVALID, 
                   AWREADY, 
                 
                   // Write Channel 
                   WDATA, 
                   WSTRB, 
                   WVALID, 
                   WREADY, 
                 
                   // Write Response Channel 
                   BID,
                   BRESP, 
                   BVALID, 
                   BREADY, 
                 
                   // Low Power Interface 
                   CSYSREQ, 
                   CSYSACK,
                   CACTIVE,
                 
                   // Module specific signals
                   SlaveEnum,
                 
                   // Scan insertion dummy pins
                   SCANENABLE,
                   SCANINACLK,
                   SCANOUTACLK
                  );

//  ----------------------------------------------------------------------------
//  Include global Constant's
//  ----------------------------------------------------------------------------
// AXI Standard Defines
`include "Axi.v"

//------------------------------------------------------------------------------
// EgSlaveAxi Block Parameters
//------------------------------------------------------------------------------
// user parameters
parameter DATA_WIDTH = 32; // Data bus width, default = 64-bit
parameter ID_WIDTH   = 4;  // ID bus width, default = 4-bit
parameter NUM_WS     = 0;  // Number of wait states on internal bus, default = 0

// Do not override the following parameters: they must be calculated exactly
// as shown below
parameter DATA_MAX   = DATA_WIDTH-1;  // DATA max index
parameter STRB_WIDTH = DATA_WIDTH/8;  // WSTRB width
parameter STRB_MAX   = STRB_WIDTH-1;  // WSTRB max index
parameter ID_MAX     = ID_WIDTH-1;    // AWID/ARID/RID/BID max index


//------------------------------------------------------------------------------
// Inputs / Outputs
//------------------------------------------------------------------------------

// Global Signals 
input                 ACLK;       // Clock input
input                 ARESETn;    // Reset async input active low

// Read Address Channel 
input    [ID_MAX : 0] ARID;       // Read address ID
input        [31 : 0] ARADDR;     // Read address
input         [3 : 0] ARLEN;      // Read burst length
input         [2 : 0] ARSIZE;     // Read burst size
input         [1 : 0] ARBURST;    // Read burst type
input                 ARVALID;    // Read address valid
output                ARREADY;    // Read address ready

// Read Channel 
output   [ID_MAX : 0] RID;        // Read response ID
output                RLAST;      // Read last
output [DATA_MAX : 0] RDATA;      // Read data
output        [1 : 0] RRESP;      // Read response
output                RVALID;     // Read valid
input                 RREADY;     // Read ready

// Write Address Channel   
input    [ID_MAX : 0] AWID;       // Write address ID
input        [31 : 0] AWADDR;     // Write address
input         [3 : 0] AWLEN;      // Write burst length
input         [2 : 0] AWSIZE;     // Write burst size
input         [1 : 0] AWBURST;    // Write burst type
input                 AWVALID;    // Write address valid
output                AWREADY;    // Write address ready

// Write Channel 
input  [DATA_MAX : 0] WDATA;      // Write data
input  [STRB_MAX : 0] WSTRB;      // Write strobes
input                 WVALID;     // Write valid
output                WREADY;     // Write ready

// Write Response Channel 
output   [ID_MAX : 0] BID;        // Write response ID
output        [1 : 0] BRESP;      // Write response
output                BVALID;     // Response valid
input                 BREADY;     // Response ready

// Low Power Interface 
input                 CSYSREQ;    // Low power request
output                CSYSACK;    // Low power acknowledge
output                CACTIVE;    // Peripheral active

// Module specific signals
input         [7 : 0] SlaveEnum;    // Slave enumeration ID

// Scan insertion dummy pins
input                 SCANENABLE;   // Enable scan test mode
input                 SCANINACLK;   // Scan data input
output                SCANOUTACLK;  // Scan data output


//------------------------------------------------------------------------------
// Signal declarations for i/o ports
//------------------------------------------------------------------------------

// Global Signals 
wire                  ACLK;       // Clock wire 
wire                  ARESETn;    // Reset async wire  active low

// Read Address Channel 
wire     [ID_MAX : 0] ARID;       // Read address ID
wire         [31 : 0] ARADDR;     // Read address
wire          [3 : 0] ARLEN;      // Read burst length
wire          [2 : 0] ARSIZE;     // Read burst size
wire          [1 : 0] ARBURST;    // Read burst type
wire                  ARVALID;    // Read address valid
wire                  ARREADY;    // Read address ready

// Read Channel 
wire     [ID_MAX : 0] RID;        // Read response ID
wire                  RLAST;      // Read last
wire   [DATA_MAX : 0] RDATA;      // Read data
wire          [1 : 0] RRESP;      // Read response
wire                  RVALID;     // Read valid
wire                  RREADY;     // Read ready

// Write Address Channel   
wire     [ID_MAX : 0] AWID;       // Write address ID
wire         [31 : 0] AWADDR;     // Write address
wire          [3 : 0] AWLEN;      // Write burst length
wire          [2 : 0] AWSIZE;     // Write burst size
wire          [1 : 0] AWBURST;    // Write burst type
wire                  AWVALID;    // Write address valid
wire                  AWREADY;    // Write address ready

// Write Channel 
wire   [DATA_MAX : 0] WDATA;      // Write data
wire   [STRB_MAX : 0] WSTRB;      // Write strobes
wire                  WVALID;     // Write valid
wire                  WREADY;     // Write ready

// Write Response Channel 
wire     [ID_MAX : 0] BID;        // Write response ID
wire          [1 : 0] BRESP;      // Write response
wire                  BVALID;     // Response valid
wire                  BREADY;     // Response ready

// Low Power Interface 
wire                  CSYSREQ;    // Low power request
wire                  CSYSACK;    // Low power acknowledge
wire                  CACTIVE;    // Peripheral active

// Module specific signals
wire          [7 : 0] SlaveEnum;  // Slave enumeration ID

// Scan insertion dummy pins
wire                  SCANENABLE;  // Enable scan test mode
wire                  SCANINACLK;  // Scan data input
wire                  SCANOUTACLK; // Scan data output

// -----------------------------------------------------------------------------
//
//                              EgSlaveAxi
//                              ==========
//
// -----------------------------------------------------------------------------
// This is a top level block.
// This block instantiates following blocks
// a) EgSlaveWIf
// b) EgSlaveRIf
// c) EgSlaveFn
// d) EgSlaveCIf
//
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
  wire                WAddrValid; // Write address to Slave block is valid
  wire                WAddrReady; // Write address is consumed in Slave block
  wire [31:0]         WAddrOut;   // Write address to Slave block

  wire                FnWResp;    // Write response for WAddrValid

  wire                RAddrValid; // Read address to Slave block is valid
  wire                RAddrReady; // Read address is consumed in Slave block
  wire [31:0]         RAddrOut;   // Read address to Slave block

  wire                FnRResp;    // Read response for RAddrValid
  wire [DATA_MAX : 0] FnRData;    // Read data for RAddrValid

  wire                AWValidInt; // Internal AWVALID, after low power override
  wire                ARValidInt; // Internal ARVALID, after low power override

  wire                AWReadyInt; // Internal AWREADY, before low power override
  wire                ARReadyInt; // Internal ARREADY, before low power override
  
//------------------------------------------------------------------------------
// Register declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Function declarations
//------------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//
//  Main body of code
//  =================
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Instantiation of AXI write interface block
//  ----------------------------------------------------------------------------

EgSlaveWIf #(ID_WIDTH) uEgSlaveWIf
    (
      // AXI Interconnect facing I/O
      .ACLK           (ACLK),
      .ARESETn        (ARESETn),

      .AWID           (AWID),
      .AWADDR         (AWADDR),
      .AWLEN          (AWLEN),
      .AWSIZE         (AWSIZE),
      .AWBURST        (AWBURST),
      .AWVALID        (AWValidInt),
      .AWREADY        (AWReadyInt),

      .WVALID         (WVALID),
      .WREADY         (WREADY),

      .BID            (BID),
      .BRESP          (BRESP),
      .BVALID         (BVALID),
      .BREADY         (BREADY),

      // Handshake signals between AXI write interface and
      // Slave function modules
      .WAddrValid     (WAddrValid),
      .WAddrReady     (WAddrReady),
      .WAddrOut       (WAddrOut),
      .FnWResp        (FnWResp)
    );

//  ----------------------------------------------------------------------------
//  Instantiation of AXI read interface block
//  ----------------------------------------------------------------------------

EgSlaveRIf #(DATA_WIDTH, ID_WIDTH) uEgSlaveRIf
    (
      // AXI Interconnect facing I/O
      .ACLK           (ACLK),
      .ARESETn        (ARESETn),

      .ARID           (ARID),
      .ARADDR         (ARADDR),
      .ARLEN          (ARLEN),
      .ARSIZE         (ARSIZE),
      .ARBURST        (ARBURST),
      .ARVALID        (ARValidInt),
      .ARREADY        (ARReadyInt),

      .RID            (RID),
      .RLAST          (RLAST),
      .RDATA          (RDATA),
      .RRESP          (RRESP),
      .RVALID         (RVALID),
      .RREADY         (RREADY),

      // Handshake signals between AXI read interface and
      // Slave function modules
      .RAddrValid     (RAddrValid),
      .RAddrReady     (RAddrReady),
      .RAddrOut       (RAddrOut),
      .FnRData        (FnRData),
      .FnRResp        (FnRResp)
    );

//  ----------------------------------------------------------------------------
//  Instantiation of AXI low power interface block
//  ----------------------------------------------------------------------------
EgSlaveCIf uEgSlaveCIf
    (
     // AXI Interconnect facing I/O
     .ACLK           (ACLK),
     .ARESETn        (ARESETn),

     // Low power interface signals
     .CSYSREQ        (CSYSREQ),
     .CSYSACK        (CSYSACK),
     .CACTIVE        (CACTIVE),

     // Write and Read address valid signals from external AXI interface
     .AWValidIn      (AWVALID),
     .ARValidIn      (ARVALID),

     // Write and Read address valid signals to EgSlaveWIf and EgSlaveRIf
     .AWValidOut     (AWValidInt),
     .ARValidOut     (ARValidInt),

     // Write and Read address ready signals from EgSlaveWIf and EgSlaveRIf
     .AWReadyIn      (AWReadyInt),
     .ARReadyIn      (ARReadyInt),

     // Write and Read address ready signals to external AXI interface
     .AWReadyOut     (AWREADY),
     .ARReadyOut     (ARREADY)
     );

//  ----------------------------------------------------------------------------
//  Instantiation of slave functionality block
//  ----------------------------------------------------------------------------
EgSlaveFn #(DATA_WIDTH, NUM_WS) uEgSlaveFn
    (
      // Global Signals
      .ACLK           (ACLK),
      .ARESETn        (ARESETn),

      // Handshake signals between AXI write interface and
      // Slave function modules
      .WAddrValid     (WAddrValid),
      .WAddrReady     (WAddrReady),
      .WAddrOut       (WAddrOut),
      .FnWResp        (FnWResp),
      .WDATA          (WDATA),
      .WSTRB          (WSTRB),
      
      // Handshake signals between AXI read interface and
      // Slave function modules
      .RAddrValid     (RAddrValid),
      .RAddrReady     (RAddrReady),
      .RAddrOut       (RAddrOut),
      .FnRData        (FnRData),
      .FnRResp        (FnRResp),

      // Miscellaneous signals
      .SlaveEnum      (SlaveEnum)
    );

// synopsys translate_off

//------------------------------------------------------------------------------
// OVL Assertions
//------------------------------------------------------------------------------

`ifdef ASSERT_ON

  //----------------------------------------------------------------------------
  // OVL_ASSERT: Data bus width check
  //----------------------------------------------------------------------------
  // DATA_WIDTH parameter must be either 32 or 64
  //----------------------------------------------------------------------------

  assert_proposition #(0, 0, "DATA_WIDTH should be 32 or 64")
    egslaveaxidatawidth(.reset_n   (1'b1), 
                        .test_expr (DATA_WIDTH == 32 || DATA_WIDTH == 64));


  //----------------------------------------------------------------------------
  // OVL_ASSERT: AWSIZE check
  //----------------------------------------------------------------------------
  // 64 bit write transfer not allowed on 32 bit data bus.
  //----------------------------------------------------------------------------

  assert_never #(1, 0, "64-bit write transfer not allowed on 32-bit bus")
    egslavewtxrwidth (.clk       (ACLK), 
                      .reset_n   (ARESETn), 
                      .test_expr (DATA_WIDTH == 32 && AWSIZE == `AXI_ASIZE_64 &&
                                  AWVALID));

  //----------------------------------------------------------------------------
  // OVL_ASSERT: AWSIZE check
  //----------------------------------------------------------------------------
  // 64 bit read transfer not allowed on 32 bit data bus.
  //----------------------------------------------------------------------------

  assert_never #(1, 0, "64-bit read transfer not allowed on 32-bit bus")
    egslavertxrwidth (.clk       (ACLK), 
                      .reset_n   (ARESETn), 
                      .test_expr (DATA_WIDTH == 32 && ARSIZE == `AXI_ASIZE_64 &&
                                  ARVALID));

  //----------------------------------------------------------------------------
  // OVL_ASSERT: Wait states value check 
  //----------------------------------------------------------------------------
  // NUM_WS should be either 0 or 1
  //----------------------------------------------------------------------------

  assert_proposition #(0, 0, "NUM_WS should be either 0 or 1")
    egslaveaxinumws(.reset_n   (1'b1),
                    .test_expr (NUM_WS == 0 || NUM_WS == 1));

`endif
// synopsys translate_on


endmodule

//  --================================ End ===================================--
