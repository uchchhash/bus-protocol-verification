interface spi_interface();

    // ----- SPI Signals ----- //
    //  Inputs
    logic SLVSEL;	// Slave Select
    logic SCLK;		// SPI Clock
    logic MOSI;		// Master Out Slave In

    // Outputs
    logic MISO;		// Master In Slave Out


	// Serial Clock Frequency Measurement
	real t0;
    real sclk_period, sclk_freq;
 /* 
	always@(posedge SCLK)begin
		if(SLVSEL == 0)begin
			sclk_period = $realtime - t0;
			t0 = $realtime;
			sclk_freq = (1.0/sclk_period);
		end
		else begin
			sclk_period = 0;
			sclk_freq = 0;		
		end
	end
*/

	// Clock Frequency Measurement 
	always @(SCLK) begin
		if(SLVSEL == 0) begin
			if(SCLK == 1) begin
				t0 = $realtime;
			end
			else if(SCLK == 0) begin
				sclk_period = ($realtime - t0)*2.0;
				t0 = 0;
				sclk_freq = (1.0/sclk_period);
				//$display("@[%0t] negedge of SCLK & SLVSEL is low || sclk_period = %0e", $time, sclk_period);
			end		
		end
		else if(SLVSEL == 1) begin
			t0 = 0.0;
			sclk_period = 0.0;
			sclk_freq = 0.0;
		end
	end 


endinterface
