class apb_spi_vseq_base extends uvm_sequence#(uvm_sequence_item);

	// Factory Registration
	`uvm_object_utils(apb_spi_vseq_base)

	// Handles for the target sequencers:
	apb_sequencer apb_seqr;
	spi_sequencer0 spi_seqr0;
	spi_sequencer1 spi_seqr1;
	spi_sequencer2 spi_seqr2;
	spi_sequencer3 spi_seqr3;
	spi_sequencer4 spi_seqr4;
	spi_sequencer5 spi_seqr5;
	spi_sequencer6 spi_seqr6;
	spi_sequencer7 spi_seqr7;
	
	// multiple spi sequence
	spi_miso_sequence0 miso_seq0;
	spi_miso_sequence1 miso_seq1;
	spi_miso_sequence2 miso_seq2;
	spi_miso_sequence3 miso_seq3;
	spi_miso_sequence4 miso_seq4;
	spi_miso_sequence5 miso_seq5;
	spi_miso_sequence6 miso_seq6;
	spi_miso_sequence7 miso_seq7;
    spi_sequence_item spi_item;

	// Register Sequence Handles
	data_load_seq dload_seq;
	data_unload_seq dunload_seq;
	control_load_seq ctrl_load_seq;
	control_go_seq go_seq;
	spi_polling_seq spi_poll_seq;
	divider_load_seq div_load_seq;
	slave_select_seq slv_sel_seq;
	slave_deselect_seq slv_desel_seq;
	config_unload_seq cfg_unload_seq;
	
	// Bus Sequence Handles
	apb_reset_sequence reset_seq;
	
	// Register Block Instance
	spi_reg_block spi_rb;
	uvm_status_e status;
    uvm_reg spi_regs[];
    uvm_reg config_regs[];
    uvm_reg data_regs[];
    
	// Required Variables
	rand bit ie;
	rand bit ass;
	rand bit lsb;
	rand bit [1:0] mode;
	rand bit [6:0] char_len;
	rand bit [7:0] slvsel;
	rand bit [15:0] divider;
	int reg_val;
	bit [31:0] write_val, read_val;
	
	// Constructor Function
	function new(string name="apb_spi_vseq_base");
		super.new(name);
		// `uvm_info(get_type_name(), "--**********-- APB-SPI Virtual Sequence Constructed ---**********-", UVM_LOW);
	endfunction
    
	task body();
		`uvm_info(get_type_name(), "====  APB-SPI Virtual Sequence Body Task Called   ====", UVM_MEDIUM);

		`uvm_info(get_type_name(), "====  APB-SPI Virtual Sequence Body Task Finished ====", UVM_MEDIUM)
	endtask

	task load_data(input bit [6:0] char_len);
		// ------ Load Data ------ //
		dload_seq = data_load_seq::type_id::create("dload_seq");
		dload_seq.spi_rb = spi_rb;
		dload_seq.char_len = char_len;
		dload_seq.start(apb_seqr); 
	endtask

	task load_div(input bit [15:0] divider);
		// ------ Load Divider ------ //
		div_load_seq = divider_load_seq::type_id::create("div_load_seq");
		div_load_seq.spi_rb = spi_rb;
		div_load_seq.divider = divider;
		div_load_seq.start(apb_seqr);
	endtask

	task load_ctrl(input bit [6:0] char_len, input bit [1:0] mode, input bit lsb, input bit ie, input bit ass);
		//------ Load Control ------//
		ctrl_load_seq = control_load_seq::type_id::create("ctrl_load_seq");
		ctrl_load_seq.spi_rb = spi_rb;
		ctrl_load_seq.char_len = char_len;
		ctrl_load_seq.mode = mode;
		ctrl_load_seq.lsb = lsb;
		ctrl_load_seq.ie = ie;
		ctrl_load_seq.ass = ass;
		ctrl_load_seq.start(apb_seqr);
	endtask

	task load_ss(input bit [7:0] slvsel);
		//------ Load Slave Select ----- //
		slv_sel_seq = slave_select_seq::type_id::create("slv_sel_seq");
		slv_sel_seq.spi_rb = spi_rb;
		slv_sel_seq.slvsel = slvsel;
		slv_sel_seq.start(apb_seqr);
	endtask

	task load_go();
		//------ Start Transter ::  Go_BSY ------//
		go_seq = control_go_seq::type_id::create("ctrl_go_seq");
		go_seq.spi_rb = spi_rb;
		go_seq.start(apb_seqr);
	endtask

		
	//----------- multiple miso transfer for multiple ss lines --------------//
    task miso_transfer0(input bit [6:0] char_len, input bit [1:0] mode);
		miso_seq0 = spi_miso_sequence0::type_id::create("miso_seq0");
		miso_seq0.mode = mode;
		miso_seq0.char_len = char_len;
		miso_seq0.start(spi_seqr0);
	endtask

    task miso_transfer1(input bit [6:0] char_len, input bit [1:0] mode);
		miso_seq1 = spi_miso_sequence1::type_id::create("miso_seq1");
		miso_seq1.mode = mode;
		miso_seq1.char_len = char_len;
		miso_seq1.start(spi_seqr1);
	endtask

    task miso_transfer2(input bit [6:0] char_len, input bit [1:0] mode);
		//------ SPI MISO Transfer ----//
		miso_seq2 = spi_miso_sequence2::type_id::create("miso_seq2");
		miso_seq2.mode = mode;
		miso_seq2.char_len = char_len;
		miso_seq2.start(spi_seqr2);
	endtask

    task miso_transfer3(input bit [6:0] char_len, input bit [1:0] mode);
		//------ SPI MISO Transfer ----//
		miso_seq3 = spi_miso_sequence3::type_id::create("miso_seq3");
		miso_seq3.mode = mode;
		miso_seq3.char_len = char_len;
		miso_seq3.start(spi_seqr3);
	endtask

    task miso_transfer4(input bit [6:0] char_len, input bit [1:0] mode);
		//------ SPI MISO Transfer ----//
		miso_seq4 = spi_miso_sequence4::type_id::create("miso_seq4");
		miso_seq4.mode = mode;
		miso_seq4.char_len = char_len;
		miso_seq4.start(spi_seqr4);
	endtask

    task miso_transfer5(input bit [6:0] char_len, input bit [1:0] mode);
		//------ SPI MISO Transfer ----//
		miso_seq5 = spi_miso_sequence5::type_id::create("miso_seq5");
		miso_seq5.mode = mode;
		miso_seq5.char_len = char_len;
		miso_seq5.start(spi_seqr5);
	endtask


    task miso_transfer6(input bit [6:0] char_len, input bit [1:0] mode);
		//------ SPI MISO Transfer ----//
		miso_seq6 = spi_miso_sequence6::type_id::create("miso_seq6");
		miso_seq6.mode = mode;
		miso_seq6.char_len = char_len;
		miso_seq6.start(spi_seqr6);
	endtask

    task miso_transfer7(input bit [6:0] char_len, input bit [1:0] mode);
		//------ SPI MISO Transfer ----//
		miso_seq7 = spi_miso_sequence7::type_id::create("miso_seq7");
		miso_seq7.mode = mode;
		miso_seq7.char_len = char_len;
		miso_seq7.start(spi_seqr7);
	endtask
		
	task miso_transfer(input bit [6:0] char_len, input bit [1:0] mode, input bit [7:0] slvsel);
		case(slvsel) 
			8'b00000001 : miso_transfer0(char_len, mode);
			8'b00000010 : miso_transfer1(char_len, mode);
			8'b00000100 : miso_transfer2(char_len, mode);
			8'b00001000 : miso_transfer3(char_len, mode);
			8'b00010000 : miso_transfer4(char_len, mode);
			8'b00100000 : miso_transfer5(char_len, mode);
			8'b01000000 : miso_transfer6(char_len, mode);
			8'b10000000 : miso_transfer7(char_len, mode);
		endcase
	endtask

	task spi_polling();
		//------ SPI Polling & Slave De-select ----//
		spi_poll_seq = spi_polling_seq::type_id::create("spi_poll_seq");
		spi_poll_seq.spi_rb = spi_rb;
		spi_poll_seq.start(apb_seqr);
	endtask

	task unload_ss();
		//------ UnLoad Slave Select ----- //
		slv_desel_seq = slave_deselect_seq::type_id::create("slv_desel_seq");
		slv_desel_seq.spi_rb = spi_rb;
		slv_desel_seq.start(apb_seqr);
	endtask

	task unload_data(input bit [6:0] char_len);
		// ------ Unload Data ------ //
		dunload_seq = data_unload_seq::type_id::create("dunload_seq");
		dunload_seq.spi_rb = spi_rb;
		dunload_seq.char_len = char_len;
		dunload_seq.start(apb_seqr);   
	endtask
	
	task unload_config;
		// ---- Read the Config Registers ----- //
		cfg_unload_seq = config_unload_seq::type_id::create("cfg_unload_seq");
		cfg_unload_seq.spi_rb = spi_rb;
		cfg_unload_seq.start(apb_seqr);		
	endtask

endclass


// ------------------------------------------------ //
// ---------- SPI LSB/MSB First Sequence ---------- //
// ------------------------------------------------ //

class spi_lsb_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_lsb_sequence)

	// Constructor Function
	function new(string name="spi_lsb_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI LSB Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI LSB Sequence Body Task Called   =====", UVM_HIGH);
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 
				
		load_data(spi_item.char_len); // Load Data
		load_div(spi_item.divider); // Load Divider
		load_ctrl(spi_item.char_len, spi_item.mode, lsb, spi_item.ie, spi_item.ass); // Load Control
		load_ss(spi_item.slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end  
			begin
				miso_transfer(spi_item.char_len, spi_item.mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join	
		unload_data(spi_item.char_len); // Unload Data
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====  SPI LSB Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass

// ----------------------------------------------------- //
// ---------- SPI Modes of Operation Sequence ---------- //
// ----------------------------------------------------- //

class spi_modes_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_modes_sequence)

	// Constructor Function
	function new(string name="spi_modes_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Modes of Operation Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Modes of Operation Sequence Body Task Called   =====", UVM_HIGH);
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 		
				
		load_data(spi_item.char_len); // Load Data

		load_div(spi_item.divider); // Load Divider
		load_ctrl(spi_item.char_len, mode, spi_item.lsb, spi_item.ie, spi_item.ass); // Load Control

		load_ss(spi_item.slvsel); // Load Slave-Select


		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end 
			begin
				miso_transfer(spi_item.char_len, mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join

		unload_data(spi_item.char_len); // Unload Data
		
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====  SPI Modes of Operation Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass

// ------------------------------------------ //
// ---------- SPI Divider Sequence ---------- //
// ------------------------------------------ //

class spi_divider_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_divider_sequence)

	// Constructor Function
	function new(string name="spi_divider_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Divider Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Divider Sequence Body Task Called   =====", UVM_HIGH);
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 
				
		load_data(spi_item.char_len); // Load Data
		load_div(divider); // Load Divider
		load_ctrl(spi_item.char_len, spi_item.mode, spi_item.lsb, spi_item.ie, spi_item.ass); // Load Control
		load_ss(spi_item.slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end 
			begin
				miso_transfer(spi_item.char_len, spi_item.mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(spi_item.char_len); // Unload Data		
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====  SPI Divider Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass


// -------------------------------------------- //
// ---------- SPI Interrupt Sequence ---------- //
// -------------------------------------------- //

class spi_interrupt_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_interrupt_sequence)
	
	bit fork_done;

	// Constructor Function
	function new(string name="spi_interrupt_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Interrupt Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Interrupt Sequence Body Task Started   =====", UVM_HIGH)
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 
				
		load_data(spi_item.char_len); // Load Data
		load_div(spi_item.divider); // Load Divider
		load_ctrl(spi_item.char_len, spi_item.mode, spi_item.lsb, ie, spi_item.ass); // Load Control
		load_ss(spi_item.slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end 
			begin
				miso_transfer(spi_item.char_len, spi_item.mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(spi_item.char_len); // Unload Data		
		unload_config; // Read the config registers 		
		`uvm_info(get_type_name(), "===== SPI Interrupt Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass


// --------------------------------------------------- //
// ---------- SPI Character Length Sequence ---------- //
// --------------------------------------------------- //

class spi_char_len_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_char_len_sequence)

	// Constructor Function
	function new(string name="spi_char_len_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Character Length Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====   SPI Character Length Sequence Body Task Started   =====", UVM_HIGH)

		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 
							
		load_data(char_len); // Load Data
		load_div(spi_item.divider); // Load Divider
		load_ctrl(char_len, spi_item.mode, spi_item.lsb, spi_item.ie, spi_item.ass); // Load Control
		load_ss(spi_item.slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end  
			begin
				miso_transfer(char_len, spi_item.mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(char_len); // Unload Data
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====   SPI Character Length Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass


// ----------------------------------------------------------- //
// ---------- SPI Auto/Manual Slave-Select Sequence ---------- //
// ----------------------------------------------------------- //

class spi_auto_ss_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_auto_ss_sequence)

	// Constructor Function
	function new(string name="spi_auto_ss_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Auto/Manual Slave Select Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Auto/Manual Slave Select Sequence Body Task Called   =====", UVM_HIGH);
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 	
				
		load_data(spi_item.char_len); // Load Data
		load_div(spi_item.divider); // Load Divider
		load_ctrl(spi_item.char_len, spi_item.mode, spi_item.lsb, spi_item.ie, ass); // Load Control
		load_ss(spi_item.slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end 
			begin
				miso_transfer(spi_item.char_len, spi_item.mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(spi_item.char_len); // Unload Data		
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====  SPI Auto/Manual Slave Select Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass


// ----------------------------------------------- //
// ---------- SPI Slave-Select Sequence ---------- //
// ----------------------------------------------- //

class spi_slvsel_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_slvsel_sequence)

	// Constructor Function
	function new(string name="spi_slvsel_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Slave Select Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Slave Select Sequence Body Task Called   =====", UVM_HIGH);
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 
				
		load_data(spi_item.char_len); // Load Data
		load_div(spi_item.divider); // Load Divider
		load_ctrl(spi_item.char_len, spi_item.mode, spi_item.lsb, spi_item.ie, spi_item.ass); // Load Control
		load_ss(slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end 
			begin
				miso_transfer(spi_item.char_len, spi_item.mode, slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(spi_item.char_len); // Unload Data		
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====  SPI Slave Select Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass



// ----------------------------------------- //
// ---------- SPI Random Sequence ---------- //
// ----------------------------------------- //

class spi_random_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_random_sequence)

	// Constructor Function
	function new(string name="spi_random_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Random Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Random Sequence Body Task Called   =====", UVM_HIGH);	
		// Create the Bus Items & Randomize
		spi_item = spi_sequence_item::type_id::create("spi_item");
		assert(spi_item.randomize()); 
				
		load_data(spi_item.char_len); // Load Data
		load_div(spi_item.divider); // Load Divider
		load_ctrl(spi_item.char_len, spi_item.mode, spi_item.lsb, spi_item.ie, spi_item.ass); // Load Control
		load_ss(spi_item.slvsel); // Load Slave-Select
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end  
			begin
				miso_transfer(spi_item.char_len, spi_item.mode, spi_item.slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!spi_item.ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(spi_item.char_len); // Unload Data
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====  SPI Random Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass

// --------------------------------------------------- //
// ------------- SPI Combination Sequence ------------ //
// --------------------------------------------------- //

class spi_combination_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_combination_sequence)

	// Constructor Function
	function new(string name="spi_combination_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Combination Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====   SPI Combination Sequence Body Task Started   =====", UVM_HIGH)						
		load_data(char_len); // Load Data
		load_ss(slvsel); // Load Slave-Select		
		load_div(divider); // Load Divider
		load_ctrl(char_len, mode, lsb, ie, ass); // Load Control
		fork
			begin
				load_go(); // Load Go - Start Transfer					
			end 
			begin
				miso_transfer(char_len, mode, slvsel);
			end
			begin
				spi_polling(); // Do SPI Polling
				if(!ass) begin // Slave De-Select
					unload_ss();
				end
			end
		join
		unload_data(char_len); // Unload Data
		unload_config; // Read the config registers 
		`uvm_info(get_type_name(), "=====   SPI Combination Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass



// ---------------------------------------- //
// ---------- SPI Reset Sequence ---------- //
// ---------------------------------------- //

class spi_reset_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_reset_sequence)
	
	// RAL sequence
	// Checks that the Hardware register reset value matches the value specified in the register model
    uvm_reg_hw_reset_seq reset_seq;
    
   // uvm_reg_bit_bash_seq;
       
	// Constructor Function
	function new(string name="spi_reset_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Reset Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
		`uvm_info(get_type_name(), "=====  SPI Reset Sequence Body Task Called   =====", UVM_HIGH);
		reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
		reset_seq.model = spi_rb;
		reset_seq.start(apb_seqr);
		`uvm_info(get_type_name(), "=====  SPI Reset Sequence Body Task Finished =====", UVM_HIGH)
	endtask

endclass


// ------------------------------------------------- //
// ---------- SPI Register Reset Sequence ---------- //
// ------------------------------------------------- //

class spi_reg_reset_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_reg_reset_sequence)
	
	// Constructor Function
	function new(string name="spi_reg_reset_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Register Reset Sequence Constructed =====", UVM_HIGH)
	endfunction
	
	uvm_reg_hw_reset_seq reset_seq;

	task body();
		`uvm_info(get_type_name(), "=====  SPI Register Reset Sequence Body Task Started   =====", UVM_HIGH)
		reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
		reset_seq.model = spi_rb;
		reset_seq.start(apb_seqr);      
		`uvm_info(get_type_name(), "===== SPI Register Reset Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass


// -------------------------------------------------- //
// ---------- SPI Register Access Sequence ---------- //
// -------------------------------------------------- //

class spi_reg_access_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_reg_access_sequence)
	

	// Constructor Function
	function new(string name="spi_reg_access_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Register Access Sequence Constructed =====", UVM_HIGH)
	endfunction
	

	task body();
		`uvm_info(get_type_name(), "=====  SPI Register Access Sequence Body Task Started   =====", UVM_HIGH)
		 
		config_regs = '{spi_rb.ss, spi_rb.ctrl, spi_rb.divider};
        data_regs = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3};
        for(int i = 0; i <=3; i++)begin
        	data_regs[i].write(status, .value(32'hFFFFFFFF));
           	data_regs[i].read(status, .value(reg_val), .parent(this));
        end
        for(int i = 0; i <=2; i++)begin
        	config_regs[i].write(status, .value(32'hFFFFFFFF));
           	config_regs[i].read(status, .value(reg_val), .parent(this));           	
        end
        
		`uvm_info(get_type_name(), "===== SPI Register Access Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass



// ---------------------------------------------------- //
// ---------- SPI Register Bit Bash Sequence ---------- //
// ---------------------------------------------------- //

class spi_reg_bit_bash_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_reg_bit_bash_sequence)
	

	// Constructor Function
	function new(string name="spi_reg_bit_bash_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Register Bit Bash Sequence Constructed =====", UVM_HIGH)
	endfunction

	apb_reset_sequence reset_seq;

	task body();
		`uvm_info(get_type_name(), "=====  SPI Register Bit Bash Sequence Body Task Started   =====", UVM_HIGH)
		reset_seq = apb_reset_sequence::type_id::create("reset_seq");

		spi_regs  = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3, spi_rb.ss, spi_rb.ctrl, spi_rb.divider};
		for(int i = 0; i<=6; i++ ) begin
			for(int j = 0; j<=31; j++) begin
				write_val = 0;
				write_val[j] = 1'b1; 
				spi_regs[i].write(status, .value(write_val));
				spi_regs[i].read(status, .value(read_val), .parent(this));
				if(i == 4 && j == 8) begin
					reset_seq.start(apb_seqr);
				end
				spi_regs[i].write(status, .value(1'b0));
				spi_regs[i].read(status, .value(read_val), .parent(this));
			end
		end		
		`uvm_info(get_type_name(), "===== SPI Register Bit Bash Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass


// ------------------------------------------------------ //
// ---------- SPI Register Write Read Sequence ---------- //
// ------------------------------------------------------ //

class spi_reg_wr_sequence extends apb_spi_vseq_base;

	// Factory Registration
	`uvm_object_utils(spi_reg_wr_sequence)
	

	// Constructor Function
	function new(string name="spi_reg_wr_sequence");
		super.new(name);
		`uvm_info(get_type_name(), "=====  SPI Register Write Read Sequence Constructed =====", UVM_HIGH)
	endfunction

	apb_reset_sequence reset_seq;
	
	// Divider Array Creation
	parameter data_RANGE = 286331153;  // divide the 32bit values into 15 ranges
	parameter divider_RANGE = 4369;   // divide the divider range values into 15 ranges
	bit [31:0] data_range_start [15];
	bit [31:0] data_range_end [15];
	bit [31:0] divider_range_start [15];
	bit [31:0] divider_range_end [15];
	bit [31:0] rand_data;
	bit [31:0] rand_div;		

	task body();
		`uvm_info(get_type_name(), "=====  SPI Register Write Read Sequence Body Task Started   =====", UVM_HIGH)
		reset_seq = apb_reset_sequence::type_id::create("reset_seq");
		spi_regs  = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3, spi_rb.divider};
	
		for (int i = 0; i < 15; i++) begin
			data_range_start[i] = i*data_RANGE;
			data_range_end[i] = ((i + 1)*data_RANGE) - 1;
			rand_data = $urandom_range(data_range_start[i], data_range_end[i]);
			for(int i = 0; i<=3; i++ ) begin
				spi_regs[i].write(status, .value(rand_data));
				spi_regs[i].read(status, .value(read_val), .parent(this));
			end
		end	
		
		for (int i = 0; i < 15; i++) begin
			divider_range_start[i] = i*divider_RANGE;
			divider_range_end[i] = ((i + 1)*divider_RANGE) - 1;
			rand_div = $urandom_range(divider_range_start[i], divider_range_end[i]);
			spi_regs[4].write(status, .value(rand_div));
			spi_regs[4].read(status, .value(read_val), .parent(this));
		end			

		`uvm_info(get_type_name(), "===== SPI Register Write Read Sequence Body Task Finished   =====", UVM_HIGH)
	endtask

endclass


