//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2004 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : EgSlaveFn.v,v
//  File Revision       : 1.17
//
//  Release Information : BP143-MN-22001-r0p0-00bet0
//
//  ----------------------------------------------------------------------------
//  Purpose             : Functionality of example AXI slave
//
//  --========================================================================--


`timescale 1ns / 1ps

module EgSlaveFn (
                  // Global Signals
                  ACLK,
                  ARESETn,

                  // Handshake signals between AXI write interface and
                  // Slave function modules
                  WAddrValid,
                  WAddrReady,
                  WAddrOut,
                  FnWResp,
                  WDATA,
                  WSTRB,

                  // Handshake signals between AXI read interface and
                  // Slave function modules
                  RAddrValid,
                  RAddrReady,
                  RAddrOut,
                  FnRData,
                  FnRResp,

                  // Miscellaneous signals
                  SlaveEnum
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
parameter DATA_WIDTH = 64; // Data bus width, default = 64-bit
parameter NUM_WS  = 0;     // Number of wait states on internal bus, default = 0

// Do not override the following parameters: they must be calculated exactly
// as shown below
parameter DATA_MAX   = DATA_WIDTH-1;  // DATA max index
parameter STRB_WIDTH = DATA_WIDTH/8;  // WSTRB width
parameter STRB_MAX   = STRB_WIDTH-1;  // WSTRB max index

// Lower an upper and bounds of address used for register index
parameter INDEX_L    = (DATA_WIDTH == 64) ? 3 : 2;
parameter INDEX_H    = INDEX_L + 3;

//------------------------------------------------------------------------------
// Inputs / Outputs
//------------------------------------------------------------------------------

// Global Signals
input                 ACLK;       // Clock input
input                 ARESETn;    // Reset async input active low

// Handshake signals between AXI write interface and Slave function modules
input                 WAddrValid; // Write address to Slave block is valid
output                WAddrReady; // Write address is consumed in Slave block
input        [31 : 0] WAddrOut;   // Write address to Slave block
output                FnWResp;    // Write response for WAddrValid
input  [DATA_MAX : 0] WDATA;      // Write data
input  [STRB_MAX : 0] WSTRB;      // Write strobes

// Handshake signals between read interface and Slave function modules
input                 RAddrValid; // Read address to Slave block is valid
output                RAddrReady; // Read address is consumed in Slave block
input        [31 : 0] RAddrOut;   // Read address to Slave block
output                FnRResp;    // Read response for RAddrValid
output [DATA_MAX : 0] FnRData;    // Read data for RAddrValid

// Miscellaneous signal
input         [7 : 0] SlaveEnum;  // Slave enumeration for identification

//------------------------------------------------------------------------------
// Signal declarations for i/o ports
//------------------------------------------------------------------------------

// Global Signals
wire                  ACLK;       // Clock wire
wire                  ARESETn;    // Reset async wire  active low

// Handshake signals between AXI write interface and Slave function modules
wire                  WAddrValid; // Write address to Slave block is valid
wire                  WAddrReady; // Write address is consumed in Slave block
wire         [31 : 0] WAddrOut;   // Write address to Slave block
wire                  FnWResp;    // Write response for WAddrValid
wire   [DATA_MAX : 0] WDATA;      // Write data
wire   [STRB_MAX : 0] WSTRB;      // Write strobes

// Handshake signals between read interface and Slave function modules
wire                  RAddrValid; // Read address to Slave block is valid
wire                  RAddrReady; // Read address is consumed in Slave block
wire         [31 : 0] RAddrOut;   // Read address to Slave block
wire                  FnRResp;    // Read response for RAddrValid
wire   [DATA_MAX : 0] FnRData;    // Read data for RAddrValid

// Miscellaneous signals
wire          [7 : 0] SlaveEnum;  // Slave enumeration for identification

// -----------------------------------------------------------------------------
//
//                              EgSlaveFn
//                              =========
//
//  Overview
//  ========
//
//  This block implements the functionality of the example AXI slave.
//  It contains 16 memory mapped read-write registers,
//  plus a read-only ID register.
//  The registers are aliased to fill up the unused memory space.
//  It accepts write data, and provides the read data and responses to each
//  transfer to the interface sub-block.
//
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Constant declarations
//  ----------------------------------------------------------------------------
//  Register address constant encoding
`define EGSLAVEAXI_REG_0 4'b0000
`define EGSLAVEAXI_REG_1 4'b0001
`define EGSLAVEAXI_REG_2 4'b0010
`define EGSLAVEAXI_REG_3 4'b0011
`define EGSLAVEAXI_REG_4 4'b0100
`define EGSLAVEAXI_REG_5 4'b0101
`define EGSLAVEAXI_REG_6 4'b0110
`define EGSLAVEAXI_REG_7 4'b0111
`define EGSLAVEAXI_REG_8 4'b1000
`define EGSLAVEAXI_REG_9 4'b1001
`define EGSLAVEAXI_REG_A 4'b1010
`define EGSLAVEAXI_REG_B 4'b1011
`define EGSLAVEAXI_REG_C 4'b1100
`define EGSLAVEAXI_REG_D 4'b1101
`define EGSLAVEAXI_REG_E 4'b1110
`define EGSLAVEAXI_REG_F 4'b1111

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------
reg    [DATA_MAX : 0] WstrbMask;
// Mask to update the register contents with correct write data lanes

wire   [DATA_MAX : 0] InvWstrbMask;
// Mask to retain the contents of register for lanes wstrb = 0

wire   [DATA_MAX : 0] NextRWREG0;  // D-Input of RWREG0
wire   [DATA_MAX : 0] NextRWREG1;  // D-Input of RWREG1
wire   [DATA_MAX : 0] NextRWREG2;  // D-Input of RWREG2
wire   [DATA_MAX : 0] NextRWREG3;  // D-Input of RWREG3
wire   [DATA_MAX : 0] NextRWREG4;  // D-Input of RWREG4
wire   [DATA_MAX : 0] NextRWREG5;  // D-Input of RWREG5
wire   [DATA_MAX : 0] NextRWREG6;  // D-Input of RWREG6
wire   [DATA_MAX : 0] NextRWREG7;  // D-Input of RWREG7
wire   [DATA_MAX : 0] NextRWREG8;  // D-Input of RWREG8
wire   [DATA_MAX : 0] NextRWREG9;  // D-Input of RWREG9
wire   [DATA_MAX : 0] NextRWREG10; // D-Input of RWREG10
wire   [DATA_MAX : 0] NextRWREG11; // D-Input of RWREG11
wire   [DATA_MAX : 0] NextRWREG12; // D-Input of RWREG12
wire   [DATA_MAX : 0] NextRWREG13; // D-Input of RWREG13
wire   [DATA_MAX : 0] NextRWREG14; // D-Input of RWREG14
wire   [DATA_MAX : 0] NextRWREG15; // D-Input of RWREG15

wire [INDEX_H : INDEX_L] WAddrSlice;
// Selecting the portion of write address vector for selecting register bank.

wire [INDEX_H : INDEX_L] RAddrSlice;
// Selecting the portion of read address vector for selecting register bank.

wire                     NextWToggle; // D-Input of WToggle register
wire                     NextRToggle; // D-Input of RToggle register

wire                     iWAddrReady; // Internal signal of WAddrReady
wire      [DATA_MAX : 0] ZEROFILL;    // Vector filled with '0's

//------------------------------------------------------------------------------
// Register declarations
//------------------------------------------------------------------------------

reg    [DATA_MAX : 0] RWREG0;  // Read/write register 0
reg    [DATA_MAX : 0] RWREG1;  // Read/write register 1
reg    [DATA_MAX : 0] RWREG2;  // Read/write register 2
reg    [DATA_MAX : 0] RWREG3;  // Read/write register 3
reg    [DATA_MAX : 0] RWREG4;  // Read/write register 4
reg    [DATA_MAX : 0] RWREG5;  // Read/write register 5
reg    [DATA_MAX : 0] RWREG6;  // Read/write register 6
reg    [DATA_MAX : 0] RWREG7;  // Read/write register 7
reg    [DATA_MAX : 0] RWREG8;  // Read/write register 8
reg    [DATA_MAX : 0] RWREG9;  // Read/write register 9
reg    [DATA_MAX : 0] RWREG10; // Read/write register 10
reg    [DATA_MAX : 0] RWREG11; // Read/write register 11
reg    [DATA_MAX : 0] RWREG12; // Read/write register 12
reg    [DATA_MAX : 0] RWREG13; // Read/write register 13
reg    [DATA_MAX : 0] RWREG14; // Read/write register 14
reg    [DATA_MAX : 0] RWREG15; // Read/write register 15

reg          [15 : 0] RegWEn;  // Write enable for register write access

reg                   WToggle;
// Toggle signal to control the timing of assertion of WAddrReady in cases
// when NUM_WS is set to 1.

reg                   RToggle;
// Toggle signal to control the timing of assertion of RAddrReady in cases
// when NUM_WS is set to 1.

reg    [DATA_MAX : 0] RegBankData;
// Mux output of register bank

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
// Fill the vector with zero's
// -----------------------------------------------------------------------------
assign ZEROFILL = {DATA_WIDTH{1'b0}};


// -----------------------------------------------------------------------------
// WstrbMask :
// ~~~~~~~~~~~
// Mask to update the register contents with correct write data lanes
// To select the write data lanes, wstrb signal is sampled.
// -----------------------------------------------------------------------------

always @(WSTRB)
begin : p_WstrbMaskComb
  integer i,j; // loop variables
  for (i=0; i < STRB_WIDTH; i=i+1)  // loop through write strobes
    for (j=0; j<8; j=j+1)           // update each bit in byte
      WstrbMask[j+(i*8)] = WSTRB[i];
end

// -----------------------------------------------------------------------------
// InvWstrbMask :
// ~~~~~~~~~~~~~~
// Mask to retain the contents of register for lanes wstrb = 0
// For byte lanes where wstrb = 0 the register contents needs to be maintain
// old value.
// -----------------------------------------------------------------------------
assign InvWstrbMask = ~WstrbMask;

// -----------------------------------------------------------------------------
// D-Input logic for register bank.
// -----------------------------------------------------------------------------
assign NextRWREG0   = (RWREG0 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG1   = (RWREG1 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG2   = (RWREG2 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG3   = (RWREG3 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG4   = (RWREG4 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG5   = (RWREG5 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG6   = (RWREG6 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG7   = (RWREG7 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG8   = (RWREG8 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG9   = (RWREG9 & InvWstrbMask)   | (WDATA & WstrbMask);
assign NextRWREG10  = (RWREG10 & InvWstrbMask)  | (WDATA & WstrbMask);
assign NextRWREG11  = (RWREG11 & InvWstrbMask)  | (WDATA & WstrbMask);
assign NextRWREG12  = (RWREG12 & InvWstrbMask)  | (WDATA & WstrbMask);
assign NextRWREG13  = (RWREG13 & InvWstrbMask)  | (WDATA & WstrbMask);
assign NextRWREG14  = (RWREG14 & InvWstrbMask)  | (WDATA & WstrbMask);
assign NextRWREG15  = (RWREG15 & InvWstrbMask)  | (WDATA & WstrbMask);

// -----------------------------------------------------------------------------
// Selecting the portion of write address vector for selecting register bank.
// -----------------------------------------------------------------------------
assign WAddrSlice = WAddrOut[INDEX_H : INDEX_L];

// -----------------------------------------------------------------------------
// Register write enable select generation
// -----------------------------------------------------------------------------
always @(WAddrValid or iWAddrReady or WAddrOut or WAddrSlice)
begin : p_WenComb
  RegWEn   = {16{1'b0}};
  if ((WAddrValid & iWAddrReady & (~WAddrOut[11])) == 1'b1)
    begin
      case (WAddrSlice)
        `EGSLAVEAXI_REG_0 :
          begin
            RegWEn[0] = 1'b1;
          end

        `EGSLAVEAXI_REG_1 :
          begin
            RegWEn[1] = 1'b1;
          end

        `EGSLAVEAXI_REG_2 :
          begin
            RegWEn[2] = 1'b1;
          end

        `EGSLAVEAXI_REG_3 :
          begin
            RegWEn[3] = 1'b1;
          end

        `EGSLAVEAXI_REG_4 :
          begin
            RegWEn[4] = 1'b1;
          end

        `EGSLAVEAXI_REG_5 :
          begin
            RegWEn[5] = 1'b1;
          end

        `EGSLAVEAXI_REG_6 :
          begin
            RegWEn[6] = 1'b1;
          end

        `EGSLAVEAXI_REG_7 :
          begin
            RegWEn[7] = 1'b1;
          end

        `EGSLAVEAXI_REG_8 :
          begin
            RegWEn[8] = 1'b1;
          end

        `EGSLAVEAXI_REG_9 :
          begin
            RegWEn[9] = 1'b1;
          end

        `EGSLAVEAXI_REG_A :
          begin
            RegWEn[10] = 1'b1;
          end

        `EGSLAVEAXI_REG_B :
          begin
            RegWEn[11] = 1'b1;
          end

        `EGSLAVEAXI_REG_C :
          begin
            RegWEn[12] = 1'b1;
          end

        `EGSLAVEAXI_REG_D :
          begin
            RegWEn[13] = 1'b1;
          end

        `EGSLAVEAXI_REG_E :
          begin
            RegWEn[14] = 1'b1;
          end

        `EGSLAVEAXI_REG_F :
          begin
            RegWEn[15] = 1'b1;
          end

        default :
          ;
      endcase
  end
end // p_WenComb

// -----------------------------------------------------------------------------
// RWREG0: D-Input of RWREG0 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG0Seq
  if (ARESETn == 1'b0)
    begin
      RWREG0           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[0] == 1'b1)
        begin
          RWREG0       <= NextRWREG0;
        end
    end
end // p_RWREG0Seq

// -----------------------------------------------------------------------------
// RWREG1: D-Input of RWREG1 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG1Seq
  if (ARESETn == 1'b0)
    begin
      RWREG1           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[1] == 1'b1)
        begin
          RWREG1       <= NextRWREG1;
        end
    end
end // p_RWREG1Seq

// -----------------------------------------------------------------------------
// RWREG2: D-Input of RWREG2 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG2Seq
  if (ARESETn == 1'b0)
    begin
      RWREG2           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[2] == 1'b1)
        begin
          RWREG2       <= NextRWREG2;
        end
    end
end // p_RWREG2Seq

// -----------------------------------------------------------------------------
// RWREG3: D-Input of RWREG3 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG3Seq
  if (ARESETn == 1'b0)
    begin
      RWREG3           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[3] == 1'b1)
        begin
          RWREG3       <= NextRWREG3;
        end
    end
end // p_RWREG3Seq

// -----------------------------------------------------------------------------
// RWREG4: D-Input of RWREG4 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG4Seq
  if (ARESETn == 1'b0)
    begin
      RWREG4           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[4] == 1'b1)
        begin
          RWREG4       <= NextRWREG4;
        end
    end
end // p_RWREG4Seq

// -----------------------------------------------------------------------------
// RWREG5: D-Input of RWREG5 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG5Seq
  if (ARESETn == 1'b0)
    begin
      RWREG5           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[5] == 1'b1)
        begin
          RWREG5       <= NextRWREG5;
        end
    end
end // p_RWREG5Seq

// -----------------------------------------------------------------------------
// RWREG6: D-Input of RWREG6 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG6Seq
  if (ARESETn == 1'b0)
    begin
      RWREG6           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[6] == 1'b1)
        begin
          RWREG6       <= NextRWREG6;
        end
    end
end // p_RWREG6Seq

// -----------------------------------------------------------------------------
// RWREG7: D-Input of RWREG7 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG7Seq
  if (ARESETn == 1'b0)
    begin
      RWREG7           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[7] == 1'b1)
        begin
          RWREG7       <= NextRWREG7;
        end
    end
end // p_RWREG7Seq

// -----------------------------------------------------------------------------
// RWREG8: D-Input of RWREG8 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG8Seq
  if (ARESETn == 1'b0)
    begin
      RWREG8           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[8] == 1'b1)
        begin
          RWREG8       <= NextRWREG8;
        end
    end
end // p_RWREG8Seq

// -----------------------------------------------------------------------------
// RWREG9: D-Input of RWREG9 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG9Seq
  if (ARESETn == 1'b0)
    begin
      RWREG9           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[9] == 1'b1)
        begin
          RWREG9       <= NextRWREG9;
        end
    end
end // p_RWREG9Seq

// -----------------------------------------------------------------------------
// RWREG10: D-Input of RWREG10 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG10Seq
  if (ARESETn == 1'b0)
    begin
      RWREG10           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[10] == 1'b1)
        begin
          RWREG10       <= NextRWREG10;
        end
    end
end // p_RWREG10Seq

// -----------------------------------------------------------------------------
// RWREG11: D-Input of RWREG11 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG11Seq
  if (ARESETn == 1'b0)
    begin
      RWREG11           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[11] == 1'b1)
        begin
          RWREG11       <= NextRWREG11;
        end
    end
end // p_RWREG11Seq

// -----------------------------------------------------------------------------
// RWREG12: D-Input of RWREG12 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG12Seq
  if (ARESETn == 1'b0)
    begin
      RWREG12           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[12] == 1'b1)
        begin
          RWREG12       <= NextRWREG12;
        end
    end
end // p_RWREG12Seq

// -----------------------------------------------------------------------------
// RWREG13: D-Input of RWREG13 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG13Seq
  if (ARESETn == 1'b0)
    begin
      RWREG13           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[13] == 1'b1)
        begin
          RWREG13       <= NextRWREG13;
        end
    end
end // p_RWREG13Seq

// -----------------------------------------------------------------------------
// RWREG14: D-Input of RWREG14 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG14Seq
  if (ARESETn == 1'b0)
    begin
      RWREG14           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[14] == 1'b1)
        begin
          RWREG14       <= NextRWREG14;
        end
    end
end // p_RWREG14Seq

// -----------------------------------------------------------------------------
// RWREG15: D-Input of RWREG15 registered when valid write is sampled.
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RWREG15Seq
  if (ARESETn == 1'b0)
    begin
      RWREG15           <= {DATA_WIDTH{1'b0}};
    end
  else
    begin
      if (RegWEn[15] == 1'b1)
        begin
          RWREG15       <= NextRWREG15;
        end
    end
end // p_RWREG15Seq

// -----------------------------------------------------------------------------
// FnWResp :
// Write response is set to SLVERR when write is performed for reserved address
// and slave ID memory spoace, otherwise it is set to OKAY.
// -----------------------------------------------------------------------------
assign FnWResp = (WAddrOut[11] == 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// WAddrReady :
// After sampling WAddrValid, WAddrReady is asserted on the next clock cycle if
// the NUM_WS is set to 1 otherwise it is set to high by default.
// -----------------------------------------------------------------------------
assign iWAddrReady = (NUM_WS == 0) ? 1'b1 : WToggle;

// -----------------------------------------------------------------------------
// WToggle generation:
// Toggle signal to control the timing of assertion of WAddrReady in cases
// when NUM_WS is set to 1.
// -----------------------------------------------------------------------------
assign NextWToggle = ((WAddrValid == 1'b1) && (NUM_WS == 1)) ? ~WToggle : 1'b0;

// -----------------------------------------------------------------------------
// WToggle: D-Input of WToggle registered
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_WToggleSeq
  if (ARESETn == 1'b0)
    begin
      WToggle       <= 1'b0;
    end
  else
    begin
      WToggle       <= NextWToggle;
    end
end // p_WToggleSeq

// -----------------------------------------------------------------------------
// Selecting the portion of read address vector for selecting register bank.
// -----------------------------------------------------------------------------
assign RAddrSlice = RAddrOut[INDEX_H : INDEX_L];

// -----------------------------------------------------------------------------
// RegBankData Mux
// -----------------------------------------------------------------------------
always @(RAddrSlice or RWREG0 or RWREG1 or RWREG2 or RWREG3 or RWREG4 or
         RWREG5 or RWREG6 or RWREG7 or RWREG8 or RWREG9 or RWREG10 or
         RWREG11 or RWREG12 or RWREG13 or RWREG14 or RWREG15)
begin : p_RegBankDataComb
  RegBankData = {DATA_WIDTH{1'b0}};
  case (RAddrSlice)
    `EGSLAVEAXI_REG_0 :
      begin
        RegBankData = RWREG0;
      end

    `EGSLAVEAXI_REG_1 :
      begin
        RegBankData = RWREG1;
      end

    `EGSLAVEAXI_REG_2 :
      begin
        RegBankData = RWREG2;
      end

    `EGSLAVEAXI_REG_3 :
      begin
        RegBankData = RWREG3;
      end

    `EGSLAVEAXI_REG_4 :
      begin
        RegBankData = RWREG4;
      end

    `EGSLAVEAXI_REG_5 :
      begin
        RegBankData = RWREG5;
      end

    `EGSLAVEAXI_REG_6 :
      begin
        RegBankData = RWREG6;
      end

    `EGSLAVEAXI_REG_7 :
      begin
        RegBankData = RWREG7;
      end

    `EGSLAVEAXI_REG_8 :
      begin
        RegBankData = RWREG8;
      end

    `EGSLAVEAXI_REG_9 :
      begin
        RegBankData = RWREG9;
      end

    `EGSLAVEAXI_REG_A :
      begin
        RegBankData = RWREG10;
      end

    `EGSLAVEAXI_REG_B :
      begin
        RegBankData = RWREG11;
      end

    `EGSLAVEAXI_REG_C :
      begin
        RegBankData = RWREG12;
      end

    `EGSLAVEAXI_REG_D :
      begin
        RegBankData = RWREG13;
      end

    `EGSLAVEAXI_REG_E :
      begin
        RegBankData = RWREG14;
      end

    `EGSLAVEAXI_REG_F :
      begin
        RegBankData = RWREG15;
      end

    default :
      ;
  endcase
end // p_RegBankDataComb

// -----------------------------------------------------------------------------
// Final read data mux from EgSlaveFn module
// -----------------------------------------------------------------------------
assign FnRData = (RAddrOut[11] == 1'b0) ? RegBankData :
                                          {ZEROFILL[DATA_MAX : 8], SlaveEnum};

// -----------------------------------------------------------------------------
// FnRResp :
// ~~~~~~~~~
// Read response is set to SLVERR when read is performed from reserved address,
// otherwise it is set to OKAY.
// -----------------------------------------------------------------------------
assign FnRResp = 1'b0; // always ok((RAddrOut[11] & (~RAddrOut[10])) == 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// RAddrReady :
// ~~~~~~~~~~~~
// After sampling RAddrValid RAddrReady is asserted on the next clock cycle if
// the NUM_WS is set to 1 otherwise it is set to high by default.
// -----------------------------------------------------------------------------
assign RAddrReady = (NUM_WS == 0) ? 1'b1 : RToggle;

// -----------------------------------------------------------------------------
// RToggle generation:
// ~~~~~~~~~~~~~~~~~~~
// Toggle signal to control the timing of assertion of RAddrReady in cases
// when NUM_WS is set to 1.
// -----------------------------------------------------------------------------
assign NextRToggle = ((RAddrValid == 1'b1) && (NUM_WS == 1)) ? ~RToggle : 1'b0;

// -----------------------------------------------------------------------------
// RToggle: D-Input of RToggle registered
// -----------------------------------------------------------------------------
always @ (posedge ACLK or negedge ARESETn)
begin : p_RToggleSeq
  if (ARESETn == 1'b0)
    begin
      RToggle       <= 1'b0;
    end
  else
    begin
      RToggle       <= NextRToggle;
    end
end // p_RToggleSeq

// -----------------------------------------------------------------------------
// Connecting local copies to output
// -----------------------------------------------------------------------------
assign WAddrReady = iWAddrReady;


endmodule

//  --================================ End ===================================--
