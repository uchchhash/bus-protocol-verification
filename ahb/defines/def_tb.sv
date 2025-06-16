//--- TRANSFER TYPE HTRANS[1:0] ---//
`define IDLE 2'b00
`define BUSY 2'b01
`define SEQ 2'b11
`define NONSEQ 2'b10


//------- BURST OPERATION HBURST[2:0] -------//
`define SINGLE 3'b000
`define INCR 3'b001
`define WRAP4 3'b010
`define INCR4 3'b011
`define WRAP8 3'b100
`define INCR8 3'b101
`define WRAP16 3'b110
`define INCR16 3'b111

////------- TRANSFER SIZE HSIZE[2:0] -------//
`define BYTE 3'b000
`define HALFWORD 3'b001
`define WORD 3'b010


`define addrWidth 32
`define dataWidth 32

parameter condition = 1;
