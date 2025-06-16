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
//  File Name           : EgSlaveRIf.v,v
//  File Revision       : 1.6
//
//  Release Information : BP143-MN-22001-r0p0-00bet0
//
//  ----------------------------------------------------------------------------
//  Purpose             : Read interface for an example AXI slave
//
//  --========================================================================--

`timescale 1ns / 1ps

module EgSlaveRIf (

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

                   // Handshake signals between AXI read interface and
                   // Slave function modules
                   RAddrValid,
                   RAddrReady,
                   RAddrOut,
                   FnRData,
                   FnRResp
                  );

// -----------------------------------------------------------------------------
// Include Global Constant's
// -----------------------------------------------------------------------------

// AXI Standard Defines
`include "Axi.v"

//------------------------------------------------------------------------------
// EgSlaveAxi Block Parameters
//------------------------------------------------------------------------------
// user parameters
parameter DATA_WIDTH = 64;            // Data bus width, default = 64-bit
parameter ID_WIDTH   = 4;             // ID bus width, default = 4-bit

// Do not override the following parameters: they must be calculated exactly
// as shown below
parameter DATA_MAX   = DATA_WIDTH-1;  // DATA max index
parameter ID_MAX     = ID_WIDTH-1;    // ARID/RID max index

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

// Handshake signals between read interface and Slave function modules
output                RAddrValid; // Read address to Slave block is valid
input                 RAddrReady; // Read address is consumed in Slave block
output       [31 : 0] RAddrOut;   // Read address to Slave block
input                 FnRResp;    // Read response for RAddrValid
input  [DATA_MAX : 0] FnRData;    // Read data for RAddrValid


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
reg      [ID_MAX : 0] RID;        // Read response ID
wire                  RLAST;      // Read last
reg    [DATA_MAX : 0] RDATA;      // Read data
reg           [1 : 0] RRESP;      // Read response
wire                  RVALID;     // Read valid
wire                  RREADY;     // Read ready

// Handshake signals between read interface and Slave function modules
wire                  RAddrValid; // Read address to Slave block is valid
wire                  RAddrReady; // Read address is consumed in Slave block
wire         [31 : 0] RAddrOut;   // Read address to Slave block
wire                  FnRResp;    // Read response for RAddrValid
wire   [DATA_MAX : 0] FnRData;    // Read data for RAddrValid

// -----------------------------------------------------------------------------
//
//                              EgSlaveRIf
//                              ==========
//
// -----------------------------------------------------------------------------
//
//  Overview
//  ========
//
//  This block provides the AXI read interface for an example AXI slave.
//  This block interfaces to AXI read address channel and read data channel.
//  This block also interfaces to example slave function block.
//
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
wire        RAddrLast;
// Indication that last beat of write burst is asserted

wire        RUAddrReady;
// Indication to AXI Address Unpacker module to increment the address

wire        RUReady;
// Indication that AXI Address Unpacker module has accepted the AXI transaction

wire        iARREADY;
// Internal signal of ARREADY

wire        URAddrValid;
// Indication that AXI Address Unpacker module has valid address

wire        iRAddrValid;
// Internal signal of RAddrValid

wire        ClkEnRid;
// Clock enable to register ARID information onto RID.

wire        NextRVALID;
// D-Input of iRVALID

wire        NextRLAST;
// D-Input of iRLAST

wire        GatedARValid;
// Gating of ARVALID when read channel handshake in progress

//------------------------------------------------------------------------------
// Register declarations
//------------------------------------------------------------------------------
reg         iRLAST;
// Internal signal of RLAST

reg         iRVALID;
// Internal signal of RVALID

//------------------------------------------------------------------------------
// Function declarations
//------------------------------------------------------------------------------


//  ----------------------------------------------------------------------------
//
//  Main body of code
//  =================
//
//  ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Gating of ARVALID when read channel handshake in progress
// -----------------------------------------------------------------------------
assign GatedARValid = ARVALID & (~iRLAST);

// -----------------------------------------------------------------------------
//  Instantiation of AXI address unpacker block for Read address channel
// -----------------------------------------------------------------------------

  EgSlaveAxiUAddr uEgSlvAxiRUAddr (
      .ACLK           (ACLK),
      .ARESETn        (ARESETn),

      .AxADDR         (ARADDR),
      .AxSIZE         (ARSIZE),
      .AxBURST        (ARBURST),
      .AxLEN          (ARLEN),
      .AxVALID        (GatedARValid),
      .AxREADY        (RUReady),

      .AddrOut        (RAddrOut),
      .AddrLast       (RAddrLast),
      .AddrValid      (URAddrValid),
      .AddrReady      (RUAddrReady)
    );

//  ----------------------------------------------------------------------------
// iRAddrValid :
// ~~~~~~~~~~~~~
// Assert RAddrValid to function block only when
// AXI address unpacker is ready with address and read channel hand shake is not
// in progress.
//  ----------------------------------------------------------------------------
assign iRAddrValid = (~iRVALID & URAddrValid) | (URAddrValid & RREADY);

//  ----------------------------------------------------------------------------
// ARREADY generation:
// ~~~~~~~~~~~~~~~~~~~
// EgSlaveAxiUAddr generates RUReady when AXI transaction is accepted.
// By default RUReady is high. This signal goes low when EgSlaveAxiUAddr is
// breaking the bursts to different beats. When last beat of the read
// transaction is completed RUready signal will be driven high.
// Since AXI read channel's handshake needs to be completed before
// we accept further AXI read address, ARREADY is not driven to logic 1 until
// read channel handshake is complete.
//  ----------------------------------------------------------------------------
assign iARREADY = RUReady & (~iRLAST);

// -----------------------------------------------------------------------------
// RUAddrReady generation:
// ~~~~~~~~~~~~~~~~~~~~~~~
// RUAddrReady when high is indication to EgSlaveAxiUAddr to increment the
// address. RUAddrReady is driven high when the EgSlaveFn has accepted the
// read address for every beat of the read transfer. Acceptance of the
// address is indicated by RAddrReady signal.
// Following signal is qualified in generating WUAddrReady signal
// RAddrReady            --> Implies that the EgSlaveFn is ready to accept next
//                           address as the current read transfer is complete.
// ((~iRVALID) | RREADY) --> In this expression RVALID = 0 implies that after
//                           the acceptance of the read address for the first
//                           beat of the read data pipeline the next address if
//                           EgSlaveFn is ready to accept it.
//                           In this expression RREADY = 1 implies that RVALID
//                           is asserted and it is waiting for the read channel
//                           handshake before enabling the incrementing of
//                           address from AXI address unpacker module.
// iRAddrValid           --> Implies that Valid read was indicated by AXI
//                           address unpacker.
// -----------------------------------------------------------------------------
assign RUAddrReady = RAddrReady & ((~iRVALID) | RREADY) & iRAddrValid;

// -----------------------------------------------------------------------------
// ClkEnRid :
// ~~~~~~~~~~
// ClkEnRid is clock enable to register ARID information onto RID.
// Since the EgSlaveAXI block accepts only one outstanding read transaction,
// ARID = RID always. Hence ARID is registered onto RID output at the end of
// acceptance of read address on AXI bus.
// -----------------------------------------------------------------------------
assign ClkEnRid = iARREADY & ARVALID;

// -----------------------------------------------------------------------------
// This block registers Read address channel ID information.
// The AXI ARID input is registered when the AXI read address is accepted.
// i.e. when ARVALID and ARREADY are sampled asserted.
// ARID is registered and driven out as RID. RID information
// driven on the bus becomes valid only when RVALID is asserted, but RID is
// driven well in advance before RVALID is asserted.
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_RdIdRegSeq
  if (ARESETn == 1'b0)
    begin
      RID     <= {ID_WIDTH{1'b0}};
    end
  else
    begin
      if (ClkEnRid == 1'b1)
        begin
          RID <= ARID;
        end
    end
end // p_RdIdRegSeq


// -----------------------------------------------------------------------------
// RRESP and RDATA generation:
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~
// RRESP registers the response driven by EgSlaveFn block for read(FnRResp).
// RDATA registers the read data driven by EgSlaveFn block(FnRData).
// RUAddrReady signal indicates to the AXI Address unpacker module to
// increment the address. On this clock edge the read data and read response
// driven by EgSlaveFn is valid. This signal is used as the clock enable to
// register RDATA and RRESP.
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_RdChRegSeq
  if (ARESETn == 1'b0)
    begin
      RDATA     <= {DATA_WIDTH{1'b0}};
      RRESP     <= `AXI_RESP_OKAY;
    end
  else
    begin
      if (RUAddrReady == 1'b1)
        begin
          RDATA <= FnRData;
          RRESP <= {FnRResp, 1'b0};
        end
    end
end // p_RdChRegSeq


// -----------------------------------------------------------------------------
// RVALID generation:
// ~~~~~~~~~~~~~~~~~~
// RVALID is driven to logic 1 for every beat of the read transfer completed
// between EgSlaveRIf and EgSlaveFn module. RVALID once asserted it has to
// maintain it's level until RREADY is sampled asserted(AXI protocol).
// RVALID is derived by 'OR' ing following conditions
// (iRAddrValid & RAddrReady) --> Implies successful read transfer between
//                                EgSlaveRIf and EgSlaveFn module is completed.
// (iRVALID & (~RREADY))      --> Implies Read data channel handshake is not
//                                yet complete.
// -----------------------------------------------------------------------------
assign NextRVALID = (iRAddrValid & RAddrReady) | (iRVALID & (~RREADY));

// -----------------------------------------------------------------------------
// This block registers D-Input logic for RVALID.
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_RvalidSeq
  if (ARESETn == 1'b0)
    begin
      iRVALID <= 1'b0;
    end
  else
    begin
      iRVALID <= NextRVALID;
    end
end // p_RvalidSeq

// -----------------------------------------------------------------------------
// RLAST generation:
// ~~~~~~~~~~~~~~~~~
// RLAST is driven to logic 1 after last beat of the read transfer is completed
// between EgSlaveRIf and EgSlaveFn module. RLAST once asserted it has to
// maintain it's level until RREADY is sampled asserted(AXI protocol).
// RLAST is derived by 'OR' ing following conditions
// (RAddrLast & RUAddrReady) --> Implies successful last beat read transfer
//                               between EgSlaveRIf and EgSlaveFn module is
//                               completed.
// (iRLAST & (~RREADY))      --> Implies Read data channel handshake is not
//                                yet complete.
// -----------------------------------------------------------------------------
assign NextRLAST = (RAddrLast & RUAddrReady) | (iRLAST & (~RREADY));

// -----------------------------------------------------------------------------
// This block registers D-Input logic for RLAST.
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_RlastSeq
  if (ARESETn == 1'b0)
    begin
      iRLAST <= 1'b0;
    end
  else
    begin
      iRLAST <= NextRLAST;
    end
end // p_RlastSeq

// -----------------------------------------------------------------------------
// Connecting local copies to output
// -----------------------------------------------------------------------------
assign ARREADY     = iARREADY;
assign RLAST       = iRLAST;
assign RVALID      = iRVALID;
assign RAddrValid  = iRAddrValid;


endmodule

//  --================================ End ===================================--
