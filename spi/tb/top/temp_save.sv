

I am writing to inform you of a bug found in the SPI Master IP from OpenCore. 

Bug Description:
During the MODE-0-MSB/LSB first Transfer with the divider set to 0, 
I have observed that the expected data transferred through MISO line does not match the actual data received at the RX register. 
The issue arises due to an extra bit of data sampling that occurs during the transfer, which overwrites the MSB/LSB bit of the RX register.

To be more specific, 
When a 128'h0 value is written to the TX register and a 128'h0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF value is written bit by bit to the MISO line, 
the value stored to the RX register becomes 128'h0ffffffffffffffffffffffffffffffe during MSB first transfer and 128'h7ffffffffffffffffffffffffffffff0 during LSB first transfer.

Probable Cause of the Bug:

The cause of the bug lies in the "spi_shift" module.
The data is stored in the RX register with the following RTL line:
-> data[rx_bit_pos[SPI_CHAR_LEN_BITS-1:0]] <= #Tp rx_clk ? s_in : data[rx_bit_pos[SPI_CHAR_LEN_BITS-1:0]];
In this line, the s_in value comes from the MISO line, and when the rx_clk signal is high, the data is sampled from s_in to the RX register.
But the rx_clk signal toggles an extra time during the transfer. 
The extra toggling results in one extra bit of s_in sampled to the RX register, which overwrites the MSB/LSB bit.


Probable Solution of the Bug:
The rx_clk signal is generated with the following RTL line:
-> "assign rx_clk = (rx_negedge ? neg_edge : pos_edge) && (!last || s_clk);"
By replacing the logical OR operation with an AND operation, we can resolve the issue. 
The rx_clk signal depends on the AND operation of the !last bit and s_clk signal, which is generated as expected.


Thank you for your attention to this matter.

Best regards,
Uchchhash Sarkar


