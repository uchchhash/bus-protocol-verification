
// ----------------------------------------- //
// ---------- SPI Driver for SS-0 ---------- //
// ----------------------------------------- //

class spi_driver0 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver0)
	
	// Required Variables & Instances
    spi_agent_config0 spi_agnt_cfg0;
    virtual spi_interface spi_vif0;
    spi_sequence_item spi_item;
    bit [7:0] length;

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver0", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-0 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-0 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-0 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-0 Run Phase Finished =====", UVM_HIGH)    
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif0.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
        	//`uvm_info(get_type_name(), "===== SPI Driver Item Received =====", UVM_MEDIUM)    			
			spi_agnt_cfg0.char_len = spi_item.char_len;
			spi_agnt_cfg0.mode = spi_item.mode;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif0.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif0.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif0.SCLK);
				spi_vif0.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif0.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass




// ----------------------------------------- //
// ---------- SPI Driver for SS-1 ---------- //
// ----------------------------------------- //

class spi_driver1 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver1)
	
	// Required Variables & Instances
    spi_agent_config1 spi_agnt_cfg1;
    virtual spi_interface spi_vif1;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver1", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-1 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-1 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-1 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-1 Run Phase Finished =====", UVM_HIGH)   
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif1.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg1.char_len = spi_item.char_len;
			spi_agnt_cfg1.mode = spi_item.mode;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif1.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif1.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif1.SCLK);
				spi_vif1.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif1.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass



// ----------------------------------------- //
// ---------- SPI Driver for SS-2 ---------- //
// ----------------------------------------- //

class spi_driver2 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver2)
	
	// Required Variables & Instances
    spi_agent_config2 spi_agnt_cfg2;
    virtual spi_interface spi_vif2;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver2", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-2 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-2 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-2 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-2 Run Phase Finished =====", UVM_HIGH)     
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif2.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg2.mode = spi_item.mode;
			spi_agnt_cfg2.char_len = spi_item.char_len;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif2.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif2.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif2.SCLK);
				spi_vif2.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif2.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass




// ----------------------------------------- //
// ---------- SPI Driver for SS-3 ---------- //
// ----------------------------------------- //

class spi_driver3 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver3)
	
	// Required Variables & Instances
    spi_agent_config3 spi_agnt_cfg3;
    virtual spi_interface spi_vif3;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver3", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-3 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-3 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-3 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-3 Run Phase Finished =====", UVM_HIGH)     
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif3.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg3.mode = spi_item.mode;
			spi_agnt_cfg3.char_len = spi_item.char_len;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif3.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif3.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif3.SCLK);
				spi_vif3.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif3.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass



// ----------------------------------------- //
// ---------- SPI Driver for SS-4 ---------- //
// ----------------------------------------- //

class spi_driver4 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver4)
	
	// Required Variables & Instances
    spi_agent_config4 spi_agnt_cfg4;
    virtual spi_interface spi_vif4;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver4", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-4 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-4 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-4 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-4 Run Phase Finished =====", UVM_HIGH)    
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif4.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg4.mode = spi_item.mode;
			spi_agnt_cfg4.char_len = spi_item.char_len;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif4.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif4.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif4.SCLK);
				spi_vif4.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif4.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass



// ----------------------------------------- //
// ---------- SPI Driver for SS-5 ---------- //
// ----------------------------------------- //

class spi_driver5 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver5)
	
	// Required Variables & Instances
    spi_agent_config5 spi_agnt_cfg5;
    virtual spi_interface spi_vif5;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver5", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-5 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-5 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-5 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-5 Run Phase Finished =====", UVM_HIGH)    
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif5.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg5.mode = spi_item.mode;
			spi_agnt_cfg5.char_len = spi_item.char_len;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif5.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif5.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif5.SCLK);
				spi_vif5.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif5.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass



// ----------------------------------------- //
// ---------- SPI Driver for SS-6 ---------- //
// ----------------------------------------- //

class spi_driver6 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver6)
	
	// Required Variables & Instances
    spi_agent_config6 spi_agnt_cfg6;
    virtual spi_interface spi_vif6;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver6", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-6 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-6 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-6 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-6 Run Phase Finished =====", UVM_HIGH)     
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif6.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg6.mode = spi_item.mode;
			spi_agnt_cfg6.char_len = spi_item.char_len;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif6.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif6.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif6.SCLK);
				spi_vif6.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif6.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass



// ----------------------------------------- //
// ---------- SPI Driver for SS-7 ---------- //
// ----------------------------------------- //

class spi_driver7 extends uvm_driver #(spi_sequence_item);

    // Factory Registration
    `uvm_component_utils(spi_driver7)
	
	// Required Variables & Instances
    spi_agent_config7 spi_agnt_cfg7;
    virtual spi_interface spi_vif7;
    spi_sequence_item spi_item;
    bit [7:0] length; 

  
    // ---------- Constructor ----------//
    function new(string name= "spi_driver7", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Driver-7 Constructed =====", UVM_LOW)
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== SPI Driver-7 Build Phase Started =====", UVM_MEDIUM)    
    endfunction

    // ---------- Run Phase ----------//
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Driver-7 Run Phase Started =====", UVM_HIGH)    
        do_miso_transfer();
        `uvm_info(get_type_name(), "===== SPI Driver-7 Run Phase Finished =====", UVM_HIGH)     
    endtask

	task do_miso_transfer();
		forever begin
			spi_vif7.MISO <= 1'b0;
			seq_item_port.get_next_item(spi_item);
			spi_agnt_cfg7.mode = spi_item.mode;
			spi_agnt_cfg7.char_len = spi_item.char_len;
			length = (spi_item.char_len == 0) ? 128 : spi_item.char_len;	
			spi_vif7.MISO <= spi_item.miso_reg[0];
			for (int i = 1; i <length-1; i++) begin
				if (spi_item.mode == 1) @(posedge spi_vif7.SCLK);
				else if (spi_item.mode == 0) @(negedge spi_vif7.SCLK);
				spi_vif7.MISO <= spi_item.miso_reg[i];
			end
			wait(spi_vif7.SLVSEL == 1); // Wait until Slave Deactivates			
			seq_item_port.item_done();
		end
	endtask	
	
endclass

