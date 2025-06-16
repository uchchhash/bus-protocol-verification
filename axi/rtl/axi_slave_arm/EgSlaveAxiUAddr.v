//  --=====================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//     (C) COPYRIGHT 2004 ARM Limited
//           ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  -------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : EgSlaveAxiUAddr.v,v
//  File Revision       : 1.3
//
//  Release Information : BP143-MN-22001-r0p0-00bet0
//
//  -------------------------------------------------------------------------
//  Purpose             : Accepts AXI burst based address and unpacks this 
//                        into an address per data beat. Also indicates the 
//                        last address in a burst. The unpacked interface has 
//                        an AXI-like VALID/READY interface.
//
//  --=====================================================================--

`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Module Declaration
//------------------------------------------------------------------------------
module EgSlaveAxiUAddr 
  (
   // Global Inputs
   ACLK,         // global AXI clock
   ARESETn,      // global AXI reset
   
   // AXI interface
   AxADDR,        // transaction address
   AxSIZE,       // transaction size
   AxBURST,      // transaction burst type
   AxLEN,        // transaction length
   AxVALID,      // valid transaction
   AxREADY,      // AxiUnpackAddr accepted transaction

   // Unpacked address interface
   AddrOut,      // incrementing address
   AddrLast,     // indicates last address in burst
   AddrValid,    // incrementing address is valid
   AddrReady     // address accepted
);

//------------------------------------------------------------------------------
// Inputs / Outputs
//------------------------------------------------------------------------------

  // Global signals
  input             ACLK;        // global AXI clock
  input             ARESETn;     // global AXI reset

  // AXI interface
  input [31:0]      AxADDR;      // transaction address           
  input [2:0]       AxSIZE;      // transaction size              
  input [1:0]       AxBURST;     // transaction burst type        
  input [3:0]       AxLEN;       // transaction length            
  input             AxVALID;     // valid transaction             
  output            AxREADY;     // AxiUnpackAddr accepted transaction

  // Unpacked address interface
  output [31:0]     AddrOut;     // incrementing address           
  output            AddrLast;    // indicates last address in burst
  output            AddrValid;   // incrementing address is valid  
  input             AddrReady;   // address accepted               
  
//------------------------------------------------------------------------------
// Signal/wire declarations
//------------------------------------------------------------------------------

  // I/O wires

  // AXI interface
  wire [31:0]       AxADDR;       // transaction address            
  wire [2:0]        AxSIZE;       // transaction size               
  wire [1:0]        AxBURST;      // transaction burst type         
  wire [3:0]        AxLEN;        // transaction length             
  wire              AxVALID;      // valid transaction              
  wire              AxREADY;      // AxiUnpackAddr accepted transaction
                                                                   
  // Unpacked address interface                                    
  wire [31:0]       AddrOut;      // incrementing address           
  wire              AddrLast;     // indicates last address in burst
  wire              AddrValid;    // incrementing address is valid  
  wire              AddrReady;    // address accepted               
  
  // internal versions of output signals
  reg [31:0]        iAddrOut;     // internal version of AddrOut
  reg               iAddrLast;    // internal version of AddrLast
  reg               iAddrValid;   // internal version of AddrValid
  wire              iAxREADY;     // internal version of AREADY

  // internal signals
  wire [31:0]       AddrOutNxt;   // D-input of AddrOut registers
  wire              AddrLastNxt;  // D-input of AddrLast register  
  wire              AddrValidNxt; // D-input of AddrValid register

  wire [11:0]       AddrIncr;     // output address from AddrGenAxi
  
  reg [3:0]         AddrCount;    // burst counter
  wire [3:0]        AddrCountNxt; // D-input of AddrCount registers
  
  wire              AddrNew;      // indicates a new AXI address is available

  reg [2:0]         SizeReg;      // ASIZE register
  reg [1:0]         BurstReg;     // ABURST register
  reg [3:0]         LenReg;       // ALEN register
  
//  ----------------------------------------------------------------------------
//
//  Main body of code
//  =================
//
//  ----------------------------------------------------------------------------

 
// -----------------------------------------------------------------------------
// Instantiation of combinatorial address incrementer
// -----------------------------------------------------------------------------
// As bursts cannot cross 4KB boundary, only least significant 12 bits need to
// increment.

  EgSlaveAxiAGen  uEgSlaveAxiAGen (
      .AddrIn  (iAddrOut[11:0]),
      .AxLEN   (LenReg),
      .AxSIZE  (SizeReg),
      .AxBURST (BurstReg),

      .AddrOut (AddrIncr)
  );
  
// -----------------------------------------------------------------------------
// Control signal registers
// -----------------------------------------------------------------------------

  // Enable for address registers
  assign AddrNew = AxVALID & iAxREADY; // new address on AXI interface

  // Address registers
  always @ (posedge ACLK or negedge ARESETn)
  begin : p_BurstCtrlSeq
    if (!ARESETn)
    begin
      SizeReg  <= 3'b000;
      BurstReg <= 2'b00;
      LenReg   <= 4'h0;
    end
    else
      if (AddrNew) // new burst accepted
      begin
        SizeReg  <= AxSIZE;  // update current transfer size
        BurstReg <= AxBURST; // update current burst type
        LenReg   <= AxLEN;   // update current burst length
      end
  end

// -----------------------------------------------------------------------------
// AddrOut logic
// -----------------------------------------------------------------------------

  // Multiplexors for next address
  assign AddrOutNxt = (// If AXI address accepted, then store new address
                       AddrNew ? AxADDR
                       : (// Else if output address accepted, then increment the
                          // address
                          AddrReady ? {iAddrOut[31:12],AddrIncr}
                          // otherwise keep stable
                          : iAddrOut)
                       );
  

  // Address register
  always @ (posedge ACLK or negedge ARESETn)
  begin : p_AddrRegSeq
    if (!ARESETn)
      iAddrOut <= {32{1'b0}};
    else
      iAddrOut <= AddrOutNxt;
   end

  // assign output from internal version
  assign AddrOut = iAddrOut;

// -----------------------------------------------------------------------------
// AddrLast logic
// -----------------------------------------------------------------------------
// AddrLast is high when the last address in a burst is presented on the address
// interface.

  // Counts incremented addresses to determine when burst is complete.
  assign AddrCountNxt = (// If new burst started, then load from ALEN
                         (AxVALID & iAxREADY) ? AxLEN
                         : (// Else if incrementing address accepted then
                            // decrement
                            (iAddrValid & AddrReady) ? (AddrCount - 4'h1)
                            // otherwise keep stable
                            : AddrCount)
                         );


  // AddrLast is high whenever the beat counter is zero and a valid address
  // value is driven
  assign AddrLastNxt = ((AddrValidNxt && (AddrCountNxt == 4'h0))
                        ? 1'b1 : 1'b0);
  
  // AddrLast registers
  always @ (posedge ACLK or negedge ARESETn)
  begin : p_CountReg
    if (!ARESETn)
    begin
      AddrCount <= 4'h0;
      iAddrLast  <= 1'b0;
    end
    else
    begin
      AddrCount <= AddrCountNxt;
      iAddrLast <= AddrLastNxt;
    end
   end

  // assign output from internal version
  assign AddrLast = iAddrLast;

// -----------------------------------------------------------------------------
// AddrValid logic
// -----------------------------------------------------------------------------

  // AddrValid is high when an address is accepted and goes low when the last
  // address is accepted, unless another burst is started.
  assign AddrValidNxt = (// If new incoming address accepted then set valid
                         (AxVALID & iAxREADY) ? 1'b1
                         : (// Else if final outgoing address accepted then
                            // clear valid
                            (AddrReady & iAddrLast) ? 1'b0
                            // otherwise keep stable
                            : iAddrValid)
                         );

  // AddrValid register
  always @ (posedge ACLK or negedge ARESETn)
  begin : p_AddrValidReg
    if (!ARESETn)
      iAddrValid <= 1'b0;
    else
      iAddrValid <= AddrValidNxt;
   end

  // assign output from internal version
  assign AddrValid = iAddrValid;

// -----------------------------------------------------------------------------
// READY logic
// -----------------------------------------------------------------------------

  // A new AXI address can be accepted when no valid address is stored
  assign iAxREADY = ~iAddrValid;

  // assign output from internal version
  assign AxREADY = iAxREADY;
  
endmodule
// ----------------------- END ----------------------- // 
