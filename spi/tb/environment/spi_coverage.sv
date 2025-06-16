class spi_coverage extends uvm_subscriber#(apb_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_coverage)
    
    // Register Model Instance
   	spi_reg_block spi_rb;     
    
    // APB Signals
    bit pready;
    bit pslverr;
    bit presetn;
    bit psel;
    bit penable; 
    bit pwrite;
    bit [4:0]  paddr;
    bit [31:0] wdata;
    bit [31:0] rdata;
    
    // interrupt
    bit IRQ;

	covergroup apb_cg; 
		option.per_instance = 1;
		READY_cov : coverpoint pready   {bins READY_HIGH = {1'b1};
										 ignore_bins READY_LOW = {1'b0};}
										 
		SLVERR_cov : coverpoint pslverr {bins SLV_OK = {1'b0};
										ignore_bins SLV_ERR  = {1'b1};}
			
		RESETn_cov : coverpoint presetn {bins RST_DEACTIVE = {1'b1};
										 bins RST_ACTIVE   = {1'b0};}								 
		
		SEL_cov : coverpoint psel 		{bins SEL_HIGH = {1'b1};
										 bins SEL_LOW  = {1'b0};}
										 
		ENABLE_cov : coverpoint penable {bins ENB_HIGH  = {1'b1};
										 bins ENB_LOW   = {1'b0};}
										 										 
		RW_cov   : coverpoint pwrite	{bins PWRITE = {1'b1};
										 bins PREAD  = {1'b0};}
										 
		ADDR_cov : coverpoint paddr 	{bins RXTX0_ADDR = {5'h0}; 
										 bins RXTX1_ADDR = {5'h4};
										 bins RXTX2_ADDR = {5'h8};
										 bins RXTX3_ADDR = {5'hC};}
										 						
		WDATA_cov : coverpoint wdata {bins wdata_range [5]={[0:$]};}
		
		RDATA_cov : coverpoint rdata {bins rdata_range [5]={[0:$]};}
		
		// data-address cross
		READ_CROSS_cov  : cross ADDR_cov, RDATA_cov, READY_cov, SLVERR_cov, RESETn_cov, SEL_cov, ENABLE_cov, RW_cov {ignore_bins RESET_ignore = binsof(RESETn_cov.RST_ACTIVE);
																										  ignore_bins SEL_ignore = binsof(SEL_cov.SEL_LOW);
																										  ignore_bins ENABLE_ignore = binsof(ENABLE_cov.ENB_LOW);
																										  ignore_bins RW_ignore = binsof(RW_cov.PWRITE);}
		
		WRITE_CROSS_cov : cross ADDR_cov, WDATA_cov, READY_cov, SLVERR_cov, RESETn_cov, SEL_cov, ENABLE_cov, RW_cov {ignore_bins RESET_ignore = binsof(RESETn_cov.RST_ACTIVE);
																										  ignore_bins SEL_ignore = binsof(SEL_cov.SEL_LOW);
																										  ignore_bins ENABLE_ignore = binsof(ENABLE_cov.ENB_LOW);
																										  ignore_bins RW_ignore = binsof(RW_cov.PREAD);}
	endgroup
        

	// Covergroup for interrupt signal
	covergroup interrupt_cg;
		option.per_instance = 1;
		IRQ_cov : coverpoint IRQ 	{bins IRQ_HIGH = {1'b1};
									 bins IRQ_LOW  = {1'b0};}		
	endgroup


	// SPI Combination covergroup
	covergroup spi_comb_cg;
	
		option.per_instance = 1;

		// Write Access
		WRITE_cov : coverpoint pwrite	{bins PWRITE = {1'b1};}	
		
		// Control Register		
		CHAR_LEN : coverpoint spi_rb.ctrl.char_len.value[6:0]  {bins LEN_RANGE0  = {[ 0:31]};
  														  		bins LEN_RANGE1  = {[32:63]};
  														  		bins LEN_RANGE2  = {[64:95]};  														  		
  														  		bins LEN_RANGE3  = {[96:127]};} 

  		GO_BSY : coverpoint spi_rb.ctrl.go_bsy.value[0]  {bins GO_HIGH  = {1'b1};}  
  		 		  		
  		RX_NEG : coverpoint spi_rb.ctrl.rx_neg.value[0]  {bins RXn_LOW  = {1'b0};
  														  bins RXn_HIGH = {1'b1};}
  			
  		TX_NEG : coverpoint spi_rb.ctrl.tx_neg.value[0]  {bins TXn_LOW  = {1'b0};
  														  bins TXn_HIGH = {1'b1};} 
  					
  		LSB : coverpoint spi_rb.ctrl.lsb.value[0]  {bins LSB_LOW  = {1'b0};
  													bins LSB_HIGH = {1'b1};}
  			
  		IE :  coverpoint spi_rb.ctrl.ie.value[0]   {bins IE_LOW  = {1'b0};
  													bins IE_HIGH = {1'b1};}
  			
		ASS : coverpoint spi_rb.ctrl.ass.value[0]  {bins ASS_LOW  = {1'b0};
													bins ASS_HIGH = {1'b1};}	
	
		// Divider Register
		DIV_RATIO_cov: coverpoint spi_rb.divider.ratio.value[15:0]  {bins DIV_RANGE_LOW [10] = {[0:1000]};
																	 bins DIV_RANGE_HIGH [5] = {[1001:65535]};}

		// Slave Select Register
		SLVSEL_cov : coverpoint spi_rb.ss.cs.value[7:0]  {bins SLV_1 = {8'b00000001};
														  bins SLV_2 = {8'b00000010};
														  bins SLV_3 = {8'b00000100};	
														  bins SLV_4 = {8'b00001000};			
														  bins SLV_5 = {8'b00010000};			
														  bins SLV_6 = {8'b00100000};	
														  bins SLV_7 = {8'b01000000};			
														  bins SLV_8 = {8'b10000000};}
		// Data Registers
		RXTX0_cov : coverpoint spi_rb.rxtx0.F.value[31:0] {bins rxtx0_range [5]={[0:$]};}
		RXTX1_cov : coverpoint spi_rb.rxtx0.F.value[31:0] {bins rxtx1_range [5]={[0:$]};}
		RXTX2_cov : coverpoint spi_rb.rxtx0.F.value[31:0] {bins rxtx2_range [5]={[0:$]};}
		RXTX3_cov : coverpoint spi_rb.rxtx0.F.value[31:0] {bins rxtx3_range [5]={[0:$]};}
	
	
		// Combination Crosses
		MODE0_cross : cross WRITE_cov, DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG   {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																													ignore_bins TXn_ignore = binsof(TX_NEG.TXn_LOW);}
		MODE1_cross : cross WRITE_cov, DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG   {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_LOW);
																													ignore_bins TXn_ignore = binsof(TX_NEG.TXn_HIGH);}		
	
	endgroup


          
    // Constructor Function
    function new(string name = "spi_coverage", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Functional Coverage Constructed =====", UVM_LOW)
		interrupt_cg = new();
		apb_cg = new();
		spi_comb_cg = new();
    endfunction


	function void write(T t);
		//`uvm_info("get_type_name", "===== SPI Functional Coverage Write =====", UVM_MEDIUM)
		paddr = t.pwrite ? t.write_addr : t.read_addr;
		wdata = t.write_data;
		rdata = t.read_data;
		pwrite = t.pwrite;
		psel = t.psel;
		penable = t.penable;
		presetn = t.presetn;
		pready = t.pready;
		pslverr = t.pslverr;
		IRQ = t.IRQ;

		// Sample the interrupt signal
		interrupt_cg.sample();
		
		// Sample the APB signals
		apb_cg.sample();
						
		// Sample the SPI combination coverage when go_bsy is high & pwrite is high
		if(paddr == 5'h10 && wdata[8] == 1'b1 && pwrite) begin
			spi_comb_cg.sample();
		end
	//`uvm_info (get_type_name(), $sformatf("pwrite = %0h || paddr = %0h || wdata = %0h || rdata = %0h || IRQ = %0d", pwrite, paddr, wdata, rdata, IRQ), UVM_MEDIUM);						
	//`uvm_info (get_type_name(), $sformatf("waddr = %0h, raddr = %0h, pwrite = %0h || paddr = %0h", t.write_addr, t.read_addr, t.pwrite, paddr), UVM_MEDIUM);		
	endfunction

endclass







/*



		RXTX0_MODE0_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																											ignore_bins TXn_ignore = binsof(TX_NEG.TXn_LOW)
																											ignore_bins LEN2_ignore = binsof(CHAR_LEN.LEN_RANGE2);
																											ignore_bins LEN3_ignore = binsof(CHAR_LEN.LEN_RANGE3);
																											ignore_bins LEN4_ignore = binsof(CHAR_LEN.LEN_RANGE4);
																											ignore_bins LEN5_ignore = binsof(CHAR_LEN.LEN_RANGE5);
																											ignore_bins LEN6_ignore = binsof(CHAR_LEN.LEN_RANGE6);	
																											ignore_bins LEN7_ignore = binsof(CHAR_LEN.LEN_RANGE7);}
		
		RXTX1_MODE0_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																											ignore_bins TXn_ignore = binsof(TX_NEG.TXn_LOW)
																											ignore_bins LEN2_ignore = binsof(CHAR_LEN.LEN_RANGE2);
																											ignore_bins LEN3_ignore = binsof(CHAR_LEN.LEN_RANGE3);
																											ignore_bins LEN4_ignore = binsof(CHAR_LEN.LEN_RANGE4);
																											ignore_bins LEN5_ignore = binsof(CHAR_LEN.LEN_RANGE5);
																											ignore_bins LEN6_ignore = binsof(CHAR_LEN.LEN_RANGE6);	
																											ignore_bins LEN7_ignore = binsof(CHAR_LEN.LEN_RANGE7);}
	
	
		
		
		
		
		MODE0_cross : cross


		RXTX0_MODE0_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_LOW);}

		RXTX1_MODE0_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_LOW);
																											ignore_bins LEN0_ignore = binsof(CHAR_LEN.LEN_RANGE0);
																											ignore_bins LEN1_ignore = binsof(CHAR_LEN.LEN_RANGE1);}

																												
		RXTX2_MODE0_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_LOW);
																											ignore_bins LEN0_ignore = binsof(CHAR_LEN.LEN_RANGE0);
																											ignore_bins LEN1_ignore = binsof(CHAR_LEN.LEN_RANGE1);			
																											ignore_bins LEN2_ignore = binsof(CHAR_LEN.LEN_RANGE2);
																											ignore_bins LEN3_ignore = binsof(CHAR_LEN.LEN_RANGE3);}	
		
		RXTX3_MODE0_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_HIGH);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_LOW);
																											ignore_bins LEN0_ignore = binsof(CHAR_LEN.LEN_RANGE0);
																											ignore_bins LEN1_ignore = binsof(CHAR_LEN.LEN_RANGE1);			
																											ignore_bins LEN2_ignore = binsof(CHAR_LEN.LEN_RANGE2);
																											ignore_bins LEN3_ignore = binsof(CHAR_LEN.LEN_RANGE3);
																											ignore_bins LEN4_ignore = binsof(CHAR_LEN.LEN_RANGE4);
																											ignore_bins LEN5_ignore = binsof(CHAR_LEN.LEN_RANGE5);}
		
		
		RXTX0_MODE1_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_LOW);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_HIGH);}
		
		RXTX1_MODE1_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_LOW);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_HIGH);
																											ignore_bins LEN0_ignore = binsof(CHAR_LEN.LEN_RANGE0);
																											ignore_bins LEN1_ignore = binsof(CHAR_LEN.LEN_RANGE1);}
																											
		RXTX2_MODE1_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_LOW);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_HIGH);
																											ignore_bins LEN0_ignore = binsof(CHAR_LEN.LEN_RANGE0);
																											ignore_bins LEN1_ignore = binsof(CHAR_LEN.LEN_RANGE1);			
																											ignore_bins LEN2_ignore = binsof(CHAR_LEN.LEN_RANGE2);
																											ignore_bins LEN3_ignore = binsof(CHAR_LEN.LEN_RANGE3);}	
		
		RXTX3_MODE1_cross : cross DIV_RATIO_cov, SLVSEL_cov, CHAR_LEN, GO_BSY, LSB, IE, ASS, TX_NEG, RX_NEG {ignore_bins RXn_ignore = binsof(RX_NEG.RXn_LOW);
																											ignore_bins TXn_ignore  = binsof(TX_NEG.TXn_HIGH);
																											ignore_bins LEN0_ignore = binsof(CHAR_LEN.LEN_RANGE0);
																											ignore_bins LEN1_ignore = binsof(CHAR_LEN.LEN_RANGE1);			
																											ignore_bins LEN2_ignore = binsof(CHAR_LEN.LEN_RANGE2);
																											ignore_bins LEN3_ignore = binsof(CHAR_LEN.LEN_RANGE3);
																											ignore_bins LEN4_ignore = binsof(CHAR_LEN.LEN_RANGE4);
																											ignore_bins LEN5_ignore = binsof(CHAR_LEN.LEN_RANGE5);}	
	
	
																											
																											
*/
