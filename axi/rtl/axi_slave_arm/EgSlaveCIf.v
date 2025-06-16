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
//  File Name           : EgSlaveCIf.v,v
//  File Revision       : 1.13
//
//  Release Information : BP143-MN-22001-r0p0-00bet0
//
//  ----------------------------------------------------------------------------
//  Purpose             : AXI Low Power Interface for EgSlaveAxi
//                        When in low power mode, AxVALID and AxREADY are 
//                        overriden to zero so slave does not accept any further
//                        transactions.
//  --========================================================================--


`timescale 1ns / 1ps

module EgSlaveCIf 
  (
   // Global Signals
   ACLK,
   ARESETn,

   // AXI Low Power Interface
   CSYSREQ,
   CSYSACK,
   CACTIVE,

   // AxVALID / AxREADY signals
   AWValidIn,
   AWValidOut,

   AWReadyIn,
   AWReadyOut,

   ARValidIn,
   ARValidOut,

   ARReadyIn,
   ARReadyOut

   );

//------------------------------------------------------------------------------
// Inputs / Outputs
//------------------------------------------------------------------------------
  
  // Global signals
  input           ACLK;       // Clock input
  input           ARESETn;    // Reset async input active low
  
  // Low power interface 
  input           CSYSREQ;    // Low power request
  output          CSYSACK;    // Low power acknowledge
  output          CACTIVE;    // Peripheral active
  
  // Address channel handshake signals
  input           AWValidIn;  // Write address valid, before low power override
  input           AWReadyIn;  // Write address ready, before low power override

  input           ARValidIn;  // Read address valid, before low power override
  input           ARReadyIn;  // Read address ready, before low power override
  
  output          AWValidOut; // Write address valid, after low power override
  output          AWReadyOut; // Write address ready, after low power override
  
  output          ARValidOut; // Read address valid, after low power override
  output          ARReadyOut; // Read address ready, after low power override

//------------------------------------------------------------------------------
// Signal declarations for i/o ports
//------------------------------------------------------------------------------

  // Global Signals
  wire            ACLK;       // Clock wire
  wire            ARESETn;    // Reset async wire active low

  // Low Power Interface 
  wire            CSYSREQ;    // Low power request
  reg             CSYSACK;    // Low power acknowledge
  wire            CACTIVE;    // Peripheral active

  // Address channel handshake signals
  wire            AWValidIn;  // Write address valid, before low power override
  wire            AWReadyIn;  // Write address ready, before low power override

  wire            ARValidIn;  // Read address valid, before low power override
  wire            ARReadyIn;  // Read address ready, before low power override
  
  wire            AWValidOut; // Write address valid, after low power override
  wire            AWReadyOut; // Write address ready, after low power override
  
  wire            ARValidOut; // Read address valid, after low power override
  wire            ARReadyOut; // Read address ready, after low power override
  
// -----------------------------------------------------------------------------
//
//                              EgSlaveCIf
//                              ==========
//
//  Overview
//  ========
//
// -----------------------------------------------------------------------------
// This block is an example implementation of the AXI low power interface.
// As the EgSlaveAxi has only an AXI interface, CACTIVE is high whenever the AXI
// interface is in use, i.e. AWREADY or ARREADY are low.
//
// A low power request is acknowledged after CACTIVE has gone low, the block 
// stalls the AXI interface when a low power request is received so clocks can 
// be safely disabled.
//
// Normally, an AXI slave with no external interface or low power mode does not 
// require a low power interface as it is active only when the transmitting 
// masters are active. It is included here as an example.
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module specific constant declarations
//------------------------------------------------------------------------------

`define EGSLAVECIF_ST_RUN_MODE      2'b00
`define EGSLAVECIF_ST_WAIT_FOR_IDLE 2'b01
`define EGSLAVECIF_ST_LOW_POWER     2'b10

//------------------------------------------------------------------------------
// Wire declarations
//------------------------------------------------------------------------------

  // Internal signals
  wire            CSysAckNxt;  // D-input of CSYSACK output register

  // State signals
  reg [1:0]       CIfState;    // Registered state signal
  reg [1:0]       CIfStateNxt; // D-input of state registers

//  ----------------------------------------------------------------------------
//
//  Main body of code
//  =================
//
//  ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Low Power Interface State Machine
// -----------------------------------------------------------------------------

  // This state machine tracks the state of the low power interface
  always @ (ARValidIn or AWValidIn or ARReadyIn or AWReadyIn or 
            CIfState or CSYSREQ)
  begin : p_CIfStateNxtComb
    case (CIfState)

      // free running mode this is the reset state, AXI interface is not stalled
      // CACTIVE is high
      // CSYSACK is high
      `EGSLAVECIF_ST_RUN_MODE :
//        if (~CSYSREQ) // low power request received
        if (CSYSREQ) // low power request received			
          if ( AWValidIn | ARValidIn | 
              ~AWReadyIn | ~ARReadyIn) // read or write address channel busy
            CIfStateNxt = `EGSLAVECIF_ST_WAIT_FOR_IDLE;
            // wait for current transactions to complete
          else // read and write address channels are idle
            CIfStateNxt = `EGSLAVECIF_ST_LOW_POWER; // enter low power state
        else // no low power request received
          CIfStateNxt = `EGSLAVECIF_ST_RUN_MODE; // retain state
      
      // waiting for current transactions to complete, AXI interface is stalled
      // CACTIVE is high
      // CSYSACK is high
      `EGSLAVECIF_ST_WAIT_FOR_IDLE :
        if (AWReadyIn & ARReadyIn) // read and write channels idle
          CIfStateNxt = `EGSLAVECIF_ST_LOW_POWER; // go into low power mode
        else // transaction still in progress
          CIfStateNxt = `EGSLAVECIF_ST_WAIT_FOR_IDLE; // retain state

      // low power mode, AXI interface is stalled
      // CACTIVE is low
      // CSYSACK is low
      `EGSLAVECIF_ST_LOW_POWER :
        if (CSYSREQ) // exit from low power mode requested
          CIfStateNxt = `EGSLAVECIF_ST_RUN_MODE; // exit immediately
        else // no exit from low power requested
          CIfStateNxt = `EGSLAVECIF_ST_LOW_POWER; // retain state 

      default : // illegal state, propagate X
        CIfStateNxt = 2'bxx;

    endcase // case(CIfState)
  end // block: p_CIfStateNxtComb

  // State machine registers
  always @ (posedge ACLK or negedge ARESETn)
  begin : p_CIfStateSeq
    if (ARESETn == 1'b0)
      CIfState <= `EGSLAVECIF_ST_RUN_MODE;
    else
      CIfState <= CIfStateNxt;
  end // p_CIfStateSeq
  
// -----------------------------------------------------------------------------
// CACTIVE indicates when the EgSlaveAxi peripheral is in a low power state
// -----------------------------------------------------------------------------

  // CACTIVE can be driven directly from the state decode.
  assign CACTIVE = ~(CIfState == `EGSLAVECIF_ST_LOW_POWER);

// -----------------------------------------------------------------------------
// CSYSACK 
// A low power request is accepted after any outstanding transactions are 
// complete. When exiting a low power state, CSYSREQ is acknowledged as soon as 
// CACTIVE goes high.
// -----------------------------------------------------------------------------


  // CSYSACK is low when in low power state, this is registered so it only 
  // changes after CACTIVE is stable
  assign CSysAckNxt = (CIfState != `EGSLAVECIF_ST_LOW_POWER);

  // CSYSACK register
  always @ (posedge ACLK or negedge ARESETn)
  begin : p_CSysAckSeq
    if (ARESETn == 1'b0)
      CSYSACK <= 1'b1;
    else
      CSYSACK <= CSysAckNxt;
  end // p_CSysAckSeq

// -----------------------------------------------------------------------------
// AxVALID Override
// When a low power request is received, AWVALID and ARVALID are driven low so 
// the block does not receive any new transactions.
// -----------------------------------------------------------------------------

  assign AWValidOut = AWValidIn & (CIfState == `EGSLAVECIF_ST_RUN_MODE);
  assign ARValidOut = ARValidIn & (CIfState == `EGSLAVECIF_ST_RUN_MODE);

// -----------------------------------------------------------------------------
// AxREADY Override
// When a low power request is received, AWREADY and ARREADY are driven low so 
// the block does not accept any new transactions.
// -----------------------------------------------------------------------------

  assign AWReadyOut = AWReadyIn & (CIfState == `EGSLAVECIF_ST_RUN_MODE);
  assign ARReadyOut = ARReadyIn & (CIfState == `EGSLAVECIF_ST_RUN_MODE);

endmodule

//  --================================ End ===================================--
