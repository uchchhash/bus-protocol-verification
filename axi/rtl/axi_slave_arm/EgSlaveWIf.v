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
//  File Name           : EgSlaveWIf.v,v
//  File Revision       : 1.4
//
//  Release Information : BP143-MN-22001-r0p0-00bet0
//
//  ----------------------------------------------------------------------------
//  Purpose             : Write interface for an example AXI slave
//
//  --========================================================================--

`timescale 1ns / 1ps

module EgSlaveWIf (

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

                   // Write Channel 
                   WVALID, 
                   WREADY, 

                   // Write Response Channel 
                   BID,
                   BRESP, 
                   BVALID, 
                   BREADY, 

                   // Handshake signals between AXI write interface and
                   // Slave function modules
                   WAddrValid,
                   WAddrReady,
                   WAddrOut,
                   FnWResp
                  );

//------------------------------------------------------------------------------
// Include global Constant's 
//------------------------------------------------------------------------------
// AXI Standard Defines
`include "Axi.v"

//------------------------------------------------------------------------------
// EgSlaveAxi Block Parameters
//------------------------------------------------------------------------------
// user parameters
parameter ID_WIDTH   = 4;             // ID bus width, default = 4-bit

// Do not override the following parameters: they must be calculated exactly
// as shown below
parameter ID_MAX     = ID_WIDTH-1;    // AWID/BID max index

//------------------------------------------------------------------------------
// Inputs / Outputs
//------------------------------------------------------------------------------

// Global Signals 
input                 ACLK;       // Clock input
input                 ARESETn;    // Reset async input active low

// Write Address Channel   
input    [ID_MAX : 0] AWID;       // Write address ID
input        [31 : 0] AWADDR;     // Write address
input         [3 : 0] AWLEN;      // Write burst length
input         [2 : 0] AWSIZE;     // Write burst size
input         [1 : 0] AWBURST;    // Write burst type
input                 AWVALID;    // Write address valid
output                AWREADY;    // Write address ready

// Write Channel 
input                 WVALID;     // Write valid
output                WREADY;     // Write ready

// Write Response Channel 
output   [ID_MAX : 0] BID;        // Write response ID
output        [1 : 0] BRESP;      // Write response
output                BVALID;     // Response valid
input                 BREADY;     // Response ready

// Handshake signals between AXI write interface and Slave function modules
output                WAddrValid; // Write address to Slave block is valid
input                 WAddrReady; // Write address is consumed in Slave block
output       [31 : 0] WAddrOut;   // Write address to Slave block
input                 FnWResp;    // Write response for WAddrValid



//------------------------------------------------------------------------------
// Signal declarations for i/o ports
//------------------------------------------------------------------------------

// Global Signals 
wire                  ACLK;       // Clock wire 
wire                  ARESETn;    // Reset async wire  active low

// Write Address Channel   
wire     [ID_MAX : 0] AWID;       // Write address ID
wire         [31 : 0] AWADDR;     // Write address
wire          [3 : 0] AWLEN;      // Write burst length
wire          [2 : 0] AWSIZE;     // Write burst size
wire          [1 : 0] AWBURST;    // Write burst type
wire                  AWVALID;    // Write address valid
wire                  AWREADY;    // Write address ready

// Write Channel 
wire                  WVALID;     // Write valid
wire                  WREADY;     // Write ready

// Write Response Channel 
reg      [ID_MAX : 0] BID;        // Write response ID
wire          [1 : 0] BRESP;      // Write response
wire                  BVALID;     // Response valid
wire                  BREADY;     // Response ready

// Handshake signals between AXI write interface and Slave function modules
wire                  WAddrValid; // Write address to Slave block is valid
wire                  WAddrReady; // Write address is consumed in Slave block
wire         [31 : 0] WAddrOut;   // Write address to Slave block
wire                  FnWResp;    // Write response for WAddrValid

// -----------------------------------------------------------------------------
//
//                              EgSlaveWIf
//                              ==========
//
// -----------------------------------------------------------------------------
//
//  Overview
//  ========
//
//  This block provides the AXI write interface for an example AXI slave.
//  This block interfaces to AXI write address channel, write data channel and
//  write response channel.
//  This block also interfaces to example slave function block.
//
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
wire        WAddrLast;
// Indication that last beat of write burst is asserted

wire        WUAddrValid;
// Indication that address driven on WAddrOut is valid, as driven by
// AXI Address Unpacker module

wire        WUAddrReady;
// Indication to AXI Address Unpacker module to increment the address

wire        WUReady;
// Indication that AXI Address Unpacker module has accepted the AXI transaction

wire  [1:0] NextBRESP;
// D-Input logic for BRESP

wire        NextDataTxrWin;
// D-Input logic for DataTxrWindow

wire        iAWREADY;
// Internal copy of AWREADY

wire        NextBVALID;
// D-Input logic for iBVALID

wire        ClkEnBid;
// Clock enable to register AWID information onto BID.

wire        GatedAWValid;
// Gating of AWVALID when bufferred channel handshake in progress

wire        iWREADY;
// Internal version of WREADY

//------------------------------------------------------------------------------
// Register declarations
//------------------------------------------------------------------------------
reg         DataTxrWindow;
// This signal indicates when it is safe to sample WVALID.

reg         iBVALID;
// Internal signal of BVALID

reg   [1:0] iBRESP;
// Internal signal of BRESP

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
// Gating of AWVALID when bufferred channel handshake in progress
// -----------------------------------------------------------------------------
assign GatedAWValid = AWVALID & (~iBVALID);

// -----------------------------------------------------------------------------
//  Instantiation of AXI address unpacker block for Write address channel
// -----------------------------------------------------------------------------

  EgSlaveAxiUAddr uEgSlvAxiWUAddr ( 
      .ACLK           (ACLK),
      .ARESETn        (ARESETn),

      .AxADDR         (AWADDR),
      .AxSIZE         (AWSIZE),
      .AxBURST        (AWBURST),
      .AxLEN          (AWLEN),
      .AxVALID        (GatedAWValid),
      .AxREADY        (WUReady),

      .AddrOut        (WAddrOut),
      .AddrLast       (WAddrLast),
      .AddrValid      (WUAddrValid),
      .AddrReady      (WUAddrReady)
    );

//  ----------------------------------------------------------------------------
// WAddrValid generation:
// ~~~~~~~~~~~~~~~~~~~~~~
// WAddrValid indicates to EgSlaveFn block that WDATA and WAddrOut is valid.
// WAddrValid is derived by 'AND' ing following signals
// WUAddrValid --> Implies that EgSlaveAxiUAddr is driving valid address on
//                 WAddrOut lines.
// WVALID      --> Implies that AXI is driving valid data for WAddrout on WDATA
//                 bus.
//  ----------------------------------------------------------------------------
assign WAddrValid = WUAddrValid & WVALID;

//  ----------------------------------------------------------------------------
// AWREADY generation:
// ~~~~~~~~~~~~~~~~~~~
// EgSlaveAxiUAddr generates WUReady when AXI transaction is accepted.
// By default WUReady is high. This signal goes low when EgSlaveAxiUAddr is
// breaking the bursts to different beats. When last beat of the write
// transaction is completed WUready signal will be driven high.
// Since AXI bufferend response channel's handshake needs to be completed before
// we accept further AXI write address, AWREADY is not driven to logic 1 until
// buffered response channel handshake is complete.
//  ----------------------------------------------------------------------------
assign iAWREADY = WUReady & (~iBVALID);

//  ----------------------------------------------------------------------------
// WREADY generation:
// ~~~~~~~~~~~~~~~~~~
// WREADY follows WAddrReady driven by EgSlaveFn block when data transfer is
// in progress. The default value of WREADY is logic 0. The data transfer
// window extends from the clock edge when write address is accepted till the
// last beat of the write transfer is accepted by EgSlaveFn block.
//  ----------------------------------------------------------------------------
assign iWREADY = WAddrReady & DataTxrWindow;

//  ----------------------------------------------------------------------------
// WUAddrReady generation:
// ~~~~~~~~~~~~~~~~~~~~~~~
// WUAddrReady when high is indication to EgSlaveAxiUAddr to increment the
// address. WUAddrReady is driven high when the EgSlaveFn has accepted the
// write address for every beat of the write transfer. Acceptance of the
// address is indicated by WAddrReady signal.
// Following signal is qualified in generating WUAddrReady signal
// WVALID        --> Implies that AXI is having valid data on WDATA bus.
// WAddrReady    --> Implies that EgSlaveFn has accepted the address and data.
// DataTxrWindow --> Implies that WVALID is sampled after the acceptance of the
//                   AXI write address.
//  ----------------------------------------------------------------------------
assign WUAddrReady = WVALID & WAddrReady & DataTxrWindow;


// -----------------------------------------------------------------------------
// BVALID generation:
// ~~~~~~~~~~~~~~~~~~
// BVALID is driven to logic 1 after the last beat of the write transfer is
// accepted. BVALID once asserted it has to maintain it's level until BREADY
// is sampled asserted(AXI protocol). 
// BVALID is derived by 'OR' ing following conditions
// (WAddrLast & WUAddrReady) --> Implies that last beat of the write transfer
//                               is completed.
// (iBVALID & (~BREADY))     --> Implies that the bufferend channel is not yet
//                               complete.
// -----------------------------------------------------------------------------
assign NextBVALID = (WAddrLast & WUAddrReady) | (iBVALID & (~BREADY));

// -----------------------------------------------------------------------------
// This block registers D-Input logic for BVALID.
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_BvalidSeq
  if (ARESETn == 1'b0)
    begin
      iBVALID <= 1'b0;
    end
  else
    begin
      iBVALID <= NextBVALID;
    end
end // p_BvalidSeq

// -----------------------------------------------------------------------------
// BRESP generation:
// ~~~~~~~~~~~~~~~~~
// Write-completion response generation
// At the end of handshake BRESP is reset to OKAY.
// When one of the beats of the write transfer is error'ed then the final
// response is set to SLVERR.
// -----------------------------------------------------------------------------
assign NextBRESP =  // OKAY when BRESP is read
                    (iBVALID & BREADY) ? `AXI_RESP_OKAY :
                    // Sticky transfer error response
                    (((FnWResp & iWREADY & DataTxrWindow) == 1'b1) ?
                     `AXI_RESP_SLVERR :
                     // keep current state in all other cases
                     iBRESP);

// -----------------------------------------------------------------------------
// This block registers D-Input logic for BRESP.
// With active low asynchronous reset to OKAY.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_BRESPSeq
  if (ARESETn == 1'b0)
    begin
      iBRESP <= `AXI_RESP_OKAY;
    end
  else
    begin
      iBRESP <= NextBRESP;
    end
end // p_BRESPSeq

// -----------------------------------------------------------------------------
// ClkEnBid :
// ~~~~~~~~~~
// ClkEnBid is clock enable to register AWID information onto BID.
// Since the EgSlaveAXI block accepts only one outstanding write transaction,
// AWID = WID always. Hence AWID is registered onto BID output at the end of
// acceptance of write address on AXI bus. 
// -----------------------------------------------------------------------------
assign ClkEnBid = iAWREADY & AWVALID;

// -----------------------------------------------------------------------------
// This block registers Write address channel ID information.
// The AXI AWID input is registered when the AXI write address is accepted.
// i.e. when AWVALID and AWREADY are sampled asserted.
// AWID is registered and driven out as BID. BID information
// driven on the bus becomes valid only when BVALID is asserted, but BID is
// driven well in advance before BVALID is asserted.
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_WrIdRegSeq
  if (ARESETn == 1'b0)
    begin
      BID     <= {ID_WIDTH{1'b0}};
    end
  else
    begin
      if (ClkEnBid == 1'b1)
        begin
          BID <= AWID;
        end
    end
end // p_WrIdRegSeq


// -----------------------------------------------------------------------------
// DataTxrWindow :
// ~~~~~~~~~~~~~~~
// This signal indicates when it is safe to sample WVALID.
// There can be situation where WVALID may be asserted before the address.
// During these conditions the design needs to wait for the valid address
// driven on AWADDR lines before accepting the WDATA.
// DataTxrWindow is opened from the time the write address is accepted until
// the last beat of the write transfer is accepted by EgSlaveFn module.
// -----------------------------------------------------------------------------
assign NextDataTxrWin = // When write address is accepted set the flop
                        (ClkEnBid == 1'b1) ? 1'b1 :
                        // When last beat of write address is accepted reset
                        // the flop
                        ((WAddrLast & WAddrReady & WVALID) ? 1'b0 : 
                         // keep current state in all other cases
                         DataTxrWindow);


// -----------------------------------------------------------------------------
// This block registers D-Input of DataTxrWindow
// -----------------------------------------------------------------------------
always @(posedge ACLK or negedge ARESETn)
begin : p_DataTxrWinSeq
  if (ARESETn == 1'b0)
    begin
      DataTxrWindow   <= 1'b0;
    end
  else
    begin
      DataTxrWindow   <= NextDataTxrWin;
    end
end // p_DataTxrWinSeq

// -----------------------------------------------------------------------------
// Connecting local copies to output
// -----------------------------------------------------------------------------
assign AWREADY = iAWREADY;
assign WREADY  = iWREADY;
assign BVALID  = iBVALID;
assign BRESP   = iBRESP;

endmodule

//  --================================ End ===================================--
