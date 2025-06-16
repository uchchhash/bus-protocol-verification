//======================================================//
//                    AXI PARAMETER FILE                //
//======================================================//

//----------------- General Parameters ------------------//
parameter MAX_OUTSTANDING = 100;           // Max outstanding transactions
parameter ACLK_FREQ       = 200_000_000;   // AXI Clock Frequency: 200 MHz

//----------------- Reset Configuration -----------------//
parameter ACTIVATE   = 1'b0;   // Reset asserted (active-low)
parameter DEACTIVATE = 1'b1;   // Reset deasserted

//----------------- AXI Handshake Signals ----------------//
parameter VALID_HIGH = 1'b1;
parameter VALID_LOW  = 1'b0;
parameter READY_HIGH = 1'b1;
parameter READY_LOW  = 1'b0;

//----------------- AXI Transaction IDs ------------------//
parameter AWID_WIDTH = 4; // Write Address ID (Master)
parameter WID_WIDTH  = 4; // Write Data ID (Master)
parameter ARID_WIDTH = 4; // Read Address ID (Master)
parameter BID_WIDTH  = 4; // Write Response ID (Slave)
parameter RID_WIDTH  = 4; // Read Response ID (Slave)

//------------------ AXI Data and Address ----------------//
parameter DATA_WIDTH = 32;    // Data bus width in bits
parameter BUS_WIDTH  = 4;     // Data bus width in bytes
parameter ADDR_WIDTH = 32;    // Address bus width

parameter ALIGN_ADDR   = 1'b1;
parameter UNALIGN_ADDR = 1'b0;

//------------------ Write Strobe ------------------------//
parameter STRB_WIDTH = (DATA_WIDTH / 8); // One strobe bit per byte

//------------------ Burst Size --------------------------//
parameter BYTE_1   = 3'b000; // 1 byte
parameter BYTE_2   = 3'b001; // 2 bytes
parameter BYTE_4   = 3'b010; // 4 bytes
parameter BYTE_8   = 3'b011; // 8 bytes
parameter BYTE_16  = 3'b100; // 16 bytes
parameter BYTE_32  = 3'b101; // 32 bytes
parameter BYTE_64  = 3'b110; // 64 bytes
parameter BYTE_128 = 3'b111; // 128 bytes

//------------------ Burst Types -------------------------//
parameter FIXED = 2'b00;
parameter INCR  = 2'b01;
parameter WRAP  = 2'b10;

//------------------ Response Types ----------------------//
parameter OKAY    = 2'b00;
parameter EXOKAY  = 2'b01;
parameter SLVERR  = 2'b10;
parameter DECERR  = 2'b11;

//------------------ Lock Types --------------------------//
parameter NORM_ACCESS = 1'b0;
parameter EX_ACCESS   = 1'b1;

//------------------ Write Cache Types -------------------//
parameter DEV_NBUFF_AW           = 4'b0000;
parameter DEV_BUFF_AW            = 4'b0001;
parameter NORM_NCACHE_NBUFF_AW   = 4'b0010;
parameter NORM_NCACHE_BUFF_AW    = 4'b0011;
parameter WT_NALC_AW             = 4'b1010;
parameter WT_RALC_AW             = 4'b1110;
parameter WT_WALC_AW             = 4'b1010;
parameter WT_RWALC_AW            = 4'b1110;
parameter WB_NALC_AW             = 4'b1011;
parameter WB_RALC_AW             = 4'b1111;
parameter WB_WALC_AW             = 4'b1011;
parameter WB_RWALC_AW            = 4'b1111;

//------------------ Read Cache Types --------------------//
parameter DEV_NBUFF_AR           = 4'b0000;
parameter DEV_BUFF_AR            = 4'b0001;
parameter NORM_NCACHE_NBUFF_AR   = 4'b0010;
parameter NORM_NCACHE_BUFF_AR    = 4'b0011;
parameter WT_NALC_AR             = 4'b0110;
parameter WT_RALC_AR             = 4'b0110;
parameter WT_WALC_AR             = 4'b1110;
parameter WT_RWALC_AR            = 4'b1110;
parameter WB_NALC_AR             = 4'b0111;
parameter WB_RALC_AR             = 4'b0111;
parameter WB_WALC_AR             = 4'b1111;
parameter WB_RWALC_AR            = 4'b1111;

//------------------ Protection Types --------------------//
parameter DATA_SEC_UNPRIV     = 3'b000;
parameter DATA_SEC_PRIV       = 3'b001;
parameter DATA_NSEC_UNPRIV    = 3'b010;
parameter DATA_NSEC_PRIV      = 3'b011;
parameter INST_SEC_UNPRIV     = 3'b100;
parameter INST_SEC_PRIV       = 3'b101;
parameter INST_NSEC_UNPRIV    = 3'b110;
parameter INST_NSEC_PRIV      = 3'b111;

//------------------ Design Constants --------------------//
parameter DEFAULT_VAL = 32'hBEEF_CAFE;
parameter RO_ADDR     = 32'h0000_0FFC;  // Read-only address region: 0xFFC–0xFFF
parameter RO_VAL      = 32'hDEAD_C0C0;

//------------------ Size Encoding -----------------------//
parameter BYTE  = 3'b000;
parameter HWORD = 3'b001;
parameter WORD  = 3'b010;

//------------------ Internal State Machine States -------//
parameter INIT         = 4'h1;
parameter DATA_PH      = 4'h2;
parameter PEN_DATA_PH  = 4'h3;
parameter R_INIT       = 4'h5;
parameter R_DATA       = 4'h6;
parameter PEN_R_DATA   = 4'h4;
