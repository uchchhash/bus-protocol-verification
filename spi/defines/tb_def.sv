

// MODE = LSB/RX/TX
`define MODE0_MSB 3'b001 // LSB = 0 //  Rx_neg = 0 //  Tx_neg = 1  //pedge_sample
`define MODE1_MSB 3'b010 // LSB = 0 //  Rx_neg = 1 //  Tx_neg = 0  //nedge_sample
`define MODE0_LSB 3'b101 // LSB = 1 //  Rx_neg = 0 //  Tx_neg = 1  //pedge_sample
`define MODE1_LSB 3'b110 // LSB = 1 //  Rx_neg = 1 //  Tx_neg = 0  //nedge_sample


// -- latest defines
`define LSB 1'b1;
`define MSB 1'b0;
`define MODE0 2'b00; // Rx_neg = 0 // Tx_neg = 1 // pedge_sample
`define MODE1 2'b01; // Rx_neg = 1 // Tx_neg = 0 // nedge_sample



`define RX_NEG 1'b1 // mode[1]
`define TX_NEG 1'b0 // mode[0]


`define TXRX0_ADDR 5'h00;
`define TXRX1_ADDR 5'h04;
`define TXRX2_ADDR 5'h08;
`define TXRX3_ADDR 5'h0C;
`define CTRL_ADDR 5'h10;
`define DIV_ADDR 5'h14;
`define SS_ADDR 5'h18;

`define UVM_REG_DATA_WIDTH 128

parameter PCLK_FREQ = 100_000_000; // 100MHz



parameter MODE00 = 2'b00;
parameter MODE01 = 2'b01; 
