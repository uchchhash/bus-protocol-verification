`uvm_analysis_imp_decl(_port_SPIregAP)
`uvm_analysis_imp_decl(_port_INTRmntrAP)
`uvm_analysis_imp_decl(_port_INTRpredAP)

class scoreboard extends uvm_scoreboard;
    
    // Factory Registration
    `uvm_component_utils(scoreboard)

	// TLM ports required
    uvm_analysis_imp_port_SPIregAP   #(uvm_reg_item, scoreboard) analysis_imp_SPIregAP;
    uvm_analysis_imp_port_INTRmntrAP #(apb_sequence_item, scoreboard) analysis_imp_INTRmntrAP;
    uvm_analysis_imp_port_INTRpredAP #(apb_sequence_item, scoreboard) analysis_imp_INTRpredAP;
    uvm_tlm_analysis_fifo #(spi_sequence_item) spi_fifo;
        
    // Register Block Instance
    spi_reg_block spi_rb;  

	// System Clock Frequency
	parameter PCLK_FREQ = 100_000_000; // 100MHz
                
                   
    // Sequence Items Instances
    spi_sequence_item spi_item; // Receive Item from SPI Monitor
    spi_sequence_item act_item, exp_item; // Assign Expected and Actual items
    spi_sequence_item act_store, exp_store; // Store Expected and Actual items
	spi_sequence_item reg_item;	
	
	// Required Variables
	int i,j;
    int pass_count, fail_count;
    string tr_type; // transfer type
    string reg_name; // register name
    string kind; // read or write access
    bit [31:0] value; // register value
    uvm_reg data_regs[], config_regs[]; // Data and Config Registers
    

	// Store the register values comming from reg predictor
	bit [127:0] rx_registers;
	bit [127:0] tx_registers;
	bit [127:0] miso_data;
	bit [127:0] mosi_data;
	bit [31:0] ctrl_read, div_read, ss_read;  // Actual
	bit [13:0] ctrl_write; // expected
	bit [15:0] div_write; // expected
	bit [7:0] ss_write; // expected	
	bit transfer_done;
	bit monitor_receiver;
	int ss_counter; 
	int test_counter;  	
    bit [127:0] filter_rx;
    bit [127:0] filter_tx;
    bit [7:0] slvsel;
    real sclk_freq;
    

	
    function new(string name="scoreboard", uvm_component parent= null);
        super.new(name, parent);
        //`uvm_info(get_type_name(), "==== APB-SPI Scoreboard Constructed ====", UVM_MEDIUM);	
    endfunction


    	
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name(), "APB-SPI Scoreboard 'Build Phase' Started", UVM_MEDIUM);

        analysis_imp_SPIregAP = new("analysis_imp_SPIregAP", this);  
        analysis_imp_INTRmntrAP = new("analysis_imp_INTRmntrAP", this);  
        analysis_imp_INTRpredAP = new("analysis_imp_INTRpredAP", this);  
        spi_fifo = new("spi_fifo", this);
    endfunction

	virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
       // `uvm_info(get_type_name(), "====  SPI SCB 'RUN Phase' Started   =====", UVM_LOW)
       forever begin
       		begin
       			spi_fifo.get(spi_item);
        		receive_monitor_data(spi_item);
        	end
       end      
    endtask

	bit IRQ_queue [$];    
	// Receive actual IRQ from Interrupt Monitor
	virtual function void write_port_INTRmntrAP (apb_sequence_item intr_item);
		`uvm_info (get_type_name(), "**** Scoreboard Got Transaction From IRQ Monitor   ****", UVM_HIGH)
	    if(IRQ_queue.size() == 1) begin
	    	checkValueDigital2(IRQ_queue.pop_back(), intr_item.IRQ, "IRQ");
	    end
	endfunction

	// Receive expected IRQ from Interrupt Predictor
	virtual function void write_port_INTRpredAP (apb_sequence_item intr_item);
		`uvm_info (get_type_name(), "***** Scoreboard Got Transaction From IRQ Predictor  ****", UVM_HIGH)
	    IRQ_queue.push_front(intr_item.IRQ);
	endfunction


	// Receive items from SPI Monitor
	task receive_monitor_data(spi_sequence_item spi_item);
		`uvm_info (get_type_name(), "**** Scoreboard Got Transaction From SPI Monitor   ****", UVM_HIGH)
	    monitor_receiver = 1;
	    act_item = spi_sequence_item::type_id::create("act_item", this);
        exp_item = spi_sequence_item::type_id::create("exp_item", this);
             
		// ---------- Actual Control Signals ---------- //
		act_item.mode = spi_item.mode;
		act_item.slvsel = spi_item.slvsel;
		act_item.sclk_freq = spi_item.sclk_freq;
		act_item.char_len = spi_item.char_len;
		act_item.length = (act_item.char_len == 0) ? 128 : act_item.char_len;
		`uvm_info (get_type_name(), $sformatf("[ACT][Control Signals Monitor] MODE = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e", 
												act_item.mode, act_item.slvsel, act_item.length, act_item.sclk_freq), UVM_HIGH);

 		// ---------- Actual DATA (MOSI) & Expected Data (MISO) ---------- //
        exp_item.SDI = (act_item.mode == 1) ? spi_item.pedge_miso : spi_item.nedge_miso;
        act_item.SDO = (act_item.mode == 1) ? spi_item.pedge_mosi : spi_item.nedge_mosi;
 		`uvm_info (get_type_name(), $sformatf("[EXP][RX-Monitor--] MISO = %0h", exp_item.SDI), UVM_HIGH);       
		`uvm_info (get_type_name(), $sformatf("[ACT][TX-Monitor--] MOSI = %0h", act_item.SDO), UVM_HIGH);
	endtask

	
	
	// Receive items from REG Predictor
	virtual function void write_port_SPIregAP (uvm_reg_item reg_item);
		//`uvm_info (get_type_name(), "***** Scoreboard Got Transaction From REG Predictor  ****", UVM_MEDIUM)
		act_store = spi_sequence_item::type_id::create("act_store", this);

				
		reg_name = reg_item.element.get_full_name(); // Register Names
		kind = reg_item.kind.name(); // Register Read/Write kind
		value = reg_item.value[0];
 		//`uvm_info (get_type_name(), $sformatf("[REG] Register Name = %s || Access = %s || Value = %0h", reg_name, kind, value), UVM_MEDIUM);       
	    		
	    data_regs = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3}; // Data Registers
		config_regs = '{spi_rb.ss, spi_rb.ctrl, spi_rb.divider};

		// ---------- Expected Register Values ---------- //
		if(kind == "UVM_WRITE") begin
			transfer_done = 0;
			// ---------- Expected DATA (MOSI Bits) ---------- //
        	// ---------- mirror values from Tx register ---------- //
			if(reg_name == "spi_rb.rxtx0" || reg_name == "spi_rb.rxtx1" || reg_name == "spi_rb.rxtx2" || reg_name == "spi_rb.rxtx3") begin		
				for (int i = 0; i <= 3; i++) begin
					tx_registers[i*32 +: 32] = data_regs[i].get_mirrored_value();
 				end
			end	
			else if (reg_name == "spi_rb.ss") begin
				ss_write = reg_item.value[0];
				ss_counter++;
				if(ss_counter == 1) slvsel = ~ss_write;
			end								
			else if (reg_name == "spi_rb.ctrl") begin
				exp_store = spi_sequence_item::type_id::create("exp_store", this);
				ctrl_write = reg_item.value[0];
				exp_store.ie = spi_rb.ctrl.ie.get_mirrored_value();
				exp_store.ass = spi_rb.ctrl.ass.get_mirrored_value();
				exp_store.lsb = spi_rb.ctrl.lsb.get_mirrored_value();
				exp_store.char_len = spi_rb.ctrl.char_len.get_mirrored_value();
				exp_store.rx_neg = spi_rb.ctrl.rx_neg.get_mirrored_value();
				exp_store.tx_neg = spi_rb.ctrl.tx_neg.get_mirrored_value();
				exp_store.length = (exp_store.char_len == 0) ? 128 : exp_store.char_len;
				exp_store.max_index = (exp_store.length <= 32) ? 0 : (exp_store.length <= 64) ? 1 : (exp_store.length <= 96) ? 2 : 3;
			end	
			else if (reg_name == "spi_rb.divider") begin
				div_write = reg_item.value[0];
			end						
		end
		
		// ---------- Actual Register Values ---------- //
		if(kind == "UVM_READ") begin
			if(reg_name == "spi_rb.rxtx0" || reg_name == "spi_rb.rxtx1" || reg_name == "spi_rb.rxtx2" || reg_name == "spi_rb.rxtx3") begin		
				for (int i = 0; i <= 3; i++) begin
					rx_registers[i*32 +: 32] = data_regs[i].get_mirrored_value();
 				end
			end	
			else if (reg_name == "spi_rb.ss") begin
				ss_read = reg_item.value[0];
			end
			else if (reg_name == "spi_rb.ctrl") begin
				ctrl_read = reg_item.value[0];
			end	
			else if (reg_name == "spi_rb.divider") begin
				div_read = reg_item.value[0];
				transfer_done = 1;
				ss_counter = 0;			
			end									
		end
		
		if(transfer_done && !monitor_receiver) begin
			`uvm_info (get_type_name(), $sformatf("Transfer_Done = %0d, Monitor_Receiver = %0d", transfer_done, monitor_receiver), UVM_HIGH);
			checkValueDigital(ctrl_write, ctrl_read, "CTRL");
			checkValueDigital(div_write, div_read, "DIV ");
			checkValueDigital(ss_write, ss_read, "SS  ");			
		end

		if(transfer_done && monitor_receiver) begin
			`uvm_info (get_type_name(), $sformatf("Transfer_Done = %0d, Monitor_Receiver = %0d", transfer_done, monitor_receiver), UVM_HIGH);	
			monitor_receiver = 0;
		    // ---------- Calculate Expected Clock Frequency ---------- //  
		    sclk_freq = PCLK_FREQ/((div_write +1)*2)*1e-9;
			//`uvm_info (get_type_name(), $sformatf("[Control Signals MIRROR] SlvSel = %b, SCLK_freq = %0e", slvsel, sclk_freq), UVM_LOW);
			
			// ---------- Expected MISO (spi monitor) Actual MISO (rx register)---------- //
 			//`uvm_info (get_type_name(), $sformatf("[EXP][RX-Monitor] MISO = %0h", exp_item.SDI), UVM_MEDIUM);       
			//`uvm_info (get_type_name(), $sformatf("[ACT][RX-Mirror]  MISO = %0h", rx_registers), UVM_MEDIUM);			
			
			// ---------- Expected MOSI (tx register) Actual MOSI (spi monitor)---------- //			
			//`uvm_info (get_type_name(), $sformatf("[ACT][TX-Monitor] MOSI = %0h", act_item.SDO), UVM_MEDIUM);			
			//`uvm_info (get_type_name(), $sformatf("[EXP][TX-Mirror]  MOSI = %0h", tx_registers), UVM_MEDIUM);			
		
			// ---------- Expected Control Signals (ctrl register) ---------- //
			//`uvm_info (get_type_name(), $sformatf("[EXP] IE = %0d || ASS = %0d || LSB = %0d || TXn = %0d || RXn = %0d", 
												//	exp_store.ie, exp_store.ass, exp_store.lsb, exp_store.tx_neg, exp_store.rx_neg), UVM_MEDIUM);
			//`uvm_info (get_type_name(), $sformatf("[EXP] CHAR_LEN = %0d || Length = %0d", exp_store.char_len, exp_store.length), UVM_MEDIUM);			
			
			// Filter the RX & Tx register from MSB to length
			for (int i = 127; i >= exp_store.length; i--) begin
				rx_registers[i] = 0;
				tx_registers[i] = 0;
			end
			
			// ---------- Actual MISO (rx register) Expected MOSI (tx register) - FILTERED ---------- //
			//`uvm_info (get_type_name(), $sformatf("[ACT][RX-Mirror-FILTER1]  MISO = %0h", rx_registers), UVM_MEDIUM);			
			//`uvm_info (get_type_name(), $sformatf("[EXP][TX-Mirror-FILTER1]  MOSI = %0h", tx_registers), UVM_MEDIUM);			

			
			// bit reversal for msb first transfer
			miso_data = exp_item.SDI;
			mosi_data = act_item.SDO;

			if(!exp_store.lsb) begin
				reverseBits(exp_item.SDI, exp_store.length, miso_data);
				reverseBits(act_item.SDO, exp_store.length, mosi_data);				
			end
 			//`uvm_info (get_type_name(), $sformatf("[EXP][RX-Monitor-FILTER] MISO = %0h", miso_data), UVM_MEDIUM);       
			//`uvm_info (get_type_name(), $sformatf("[ACT][TX-Monitor-FILTER] MOSI = %0h", mosi_data), UVM_MEDIUM);
			displayStatus;
			checkValue(sclk_freq, act_item.sclk_freq, sclk_freq*0.1, "FREQ", "Hz");
			checkValueDigital2(slvsel, act_item.slvsel, "SLV");
			checkValueDigital3(exp_store.char_len, act_item.char_len, "LEN");
			checkValueDigital(tx_registers, mosi_data, "MOSI");
			checkValueDigital(miso_data, rx_registers, "MISO");
			repeat(2)$display();
		end		
	endfunction


	function void reverseBits(input bit [127:0] inputReg, input int length, output bit [127:0] outputReg);
	  bit [127:0] reversedReg;
	  for(int i = 0; i < length; i++) begin
		reversedReg[i] = inputReg[length-1-i];
	  end
	  outputReg = reversedReg;
	endfunction

	
	// Status Update task
	function void displayStatusReal;
		input reg [8*20:0] var_name;
		input real var_real;
		`uvm_info (get_type_name(), $sformatf("Status :: %0s = %0e", var_name, var_real), UVM_LOW);
	endfunction

	function void displayStatusDigital;
		input reg [8*20:0] var_name;
		input integer var_discrete;
		`uvm_info (get_type_name(), $sformatf("Status :: %0s = %0h", var_name, var_discrete), UVM_LOW);
	endfunction


	function void displayStatus;
		tr_type = $sformatf("Mode-%0d %s", exp_store.rx_neg == 0 ? 0 : 1, exp_store.lsb == 0 ? "MSB" : "LSB");
		test_counter++;
`uvm_info (get_type_name(), $sformatf("========================================================================================================================================"), UVM_LOW)
`uvm_info (get_type_name(), $sformatf("[%0d][TIME :: %s] Transfer = %s, Length = %0d, Slave = %b, SS Type = %s, IE Type = %s, Div Ratio = %0d",test_counter, get_time(), tr_type,exp_store.char_len, slvsel, exp_store.ass == 0 ? "MANUAL" : "AUTO", exp_store.ie == 0 ? "DEACTIVATED" : "ACTIVATED", div_write),UVM_LOW);
`uvm_info (get_type_name(), $sformatf("========================================================================================================================================"), UVM_LOW)
	endfunction
	

	function void checkValue; // checkValue with absolute tolorence
		input real expected, measured, abstol;
		input reg [8*20:0] description, unit;
		begin
			if(abs(expected - measured) > abstol) begin
				`uvm_info (get_type_name(), $sformatf("[%0s] FAIL :: Expected = %0e %0s | Actual = %0e %0s", description, expected, unit, measured, unit), UVM_LOW);
				fail_count = fail_count+1;
			end
			else begin
				`uvm_info (get_type_name(), $sformatf("[%0s] PASS :: Expected = %0e %0s | Actual = %0e %0s", description, expected, unit, measured, unit), UVM_LOW);
			//	pass_count = pass_count+1;
			end
		end
	endfunction
	
	function void checkValueDigital;
		input bit [127:0] expected;
		input bit [127:0] measured;
		input reg [8*20:0] description;
		begin
			if(expected != measured) begin
				`uvm_info (get_type_name(), $sformatf("[%0s] FAIL :: Expected = %0h | Actual = %0h", description, expected, measured), UVM_LOW);
				fail_count = fail_count+1;
			end
			else begin
				`uvm_info (get_type_name(), $sformatf("[%0s] PASS :: Expected = %0h | Actual = %0h", description, expected, measured), UVM_LOW);
            	pass_count = pass_count+1;
			end
		end
	endfunction


	function void checkValueDigital2;
		input bit [127:0] expected;
		input bit [127:0] measured;
		input reg [8*20:0] description;
		begin
			if(expected != measured) begin
				`uvm_info (get_type_name(), $sformatf("[%0s]  FAIL :: Expected = %0b | Actual = %0b", description, expected, measured), UVM_LOW);
				fail_count = fail_count+1;
			end
			else begin
				`uvm_info (get_type_name(), $sformatf("[%0s]  PASS :: Expected = %0b | Actual = %0b", description, expected, measured), UVM_LOW);
            	//pass_count = pass_count+1;
			end
		end
	endfunction

	function void checkValueDigital3;
		input bit [127:0] expected;
		input bit [127:0] measured;
		input reg [8*20:0] description;
		begin
			if(expected != measured) begin
				`uvm_info (get_type_name(), $sformatf("[%0s]  FAIL :: Expected = %0d | Actual = %0d", description, expected, measured), UVM_LOW);
				fail_count = fail_count+1;
			end
			else begin
				`uvm_info (get_type_name(), $sformatf("[%0s]  PASS :: Expected = %0d | Actual = %0d", description, expected, measured), UVM_LOW);
            	//pass_count = pass_count+1;
			end
		end
	endfunction
	

	// Function to return absolute value
	function real abs(input real in_val);
		if(in_val < 0.0) begin
		    return (-1)*in_val;
		end
		else begin
		    return in_val;
		end
	endfunction

	// Function to return system time
	function string get_time();
		int file_pointer;
		//Stores time and date to file sys_time
		void'($system("date +%X--%x > sys_time"));
		//Open the file sys_time with read access
		file_pointer = $fopen("sys_time","r");
		//assin the value from file to variable
		void'($fscanf(file_pointer,"%s",get_time));
		//close the file
		$fclose(file_pointer);
		void'($system("rm sys_time"));
	endfunction



	virtual function void report_phase(uvm_phase phase);
          `uvm_info(get_type_name(),"APB-SPI Scoreboard 'Report Phase' Started", UVM_LOW)
          if(fail_count !=0)begin
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   ********      *        ********    **          ********    *******       |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   ******       * *          **       **          **          *      *      |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   **          *****         **       **          ********    *      *      |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   **         *     *        **       **          **          *      *      |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   **        *       *    ********    ********    ********    *******       |"), UVM_LOW)  
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)      
          end
          else begin
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   ********       *       ********    ********    ********    *******       |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   **    **      * *      **          **          **          *      *      |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   ********     *****     ********    ********    ********    *      *      |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   **          *     *          **          **    **          *      *      |"), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("|   **         *       *   ********    ********    ********    *******       |"), UVM_LOW) 
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)       
          end
          `uvm_info (get_type_name(), $sformatf("=============================== Report Summary ==============================="), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("======    Total Test: %0d   ||  Total Pass: %0d  ||  Total Fail: %0d    ======", pass_count+fail_count,pass_count, fail_count),UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)
          `uvm_info (get_type_name(), $sformatf("=============================================================================="), UVM_LOW)
      endfunction



endclass

