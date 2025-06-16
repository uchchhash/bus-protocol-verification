//--------- SPI Monitor for SS line 0 ----------------//

class spi_monitor0 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor0)

    // Sequence item and Interface
    spi_sequence_item spi_item;
    virtual spi_interface spi_vif0;
    spi_agent_config0 spi_agnt_cfg0; 
    
    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP0; 
        
    // Required Variables
    bit [1:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;
    
    // Constructor
    function new(string name = "spi_monitor0", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"===== SPI Monitor-0 Constructed =====", UVM_LOW)
    endfunction


    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP0 = new("analysis_port_SPImntrAP0", this);
    endfunction
     
     
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-0 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif0.SLVSEL == 1) @(spi_vif0.SLVSEL);
			fork
				begin
		            while(spi_vif0.SLVSEL == 0) begin
		              @(posedge spi_vif0.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif0.MOSI;
		              spi_item.nedge_miso[j] = spi_vif0.MISO;
		              spi_item.char_len++;
		              j++;
		              @(negedge spi_vif0.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif0.MOSI;
		              spi_item.pedge_miso[i] = spi_vif0.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg0.char_len) begin
		              		#(spi_vif0.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif0.SCLK);
					@(spi_vif0.SLVSEL);
					spi_item.sclk_freq = spi_vif0.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg0.slvsel;
					spi_item.mode = spi_agnt_cfg0.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e", spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					//`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0b", spi_item.pedge_miso), UVM_MEDIUM);
					//`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0b", spi_item.nedge_miso), UVM_MEDIUM);
					//`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0b", spi_item.pedge_mosi), UVM_MEDIUM);
					//`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0b", spi_item.nedge_mosi), UVM_MEDIUM);
					analysis_port_SPImntrAP0.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask
           
endclass



//--------- SPI Monitor for SS line 1 ----------------//
class spi_monitor1 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor1)

    // Sequence item and Interface
    spi_sequence_item spi_item;
  	virtual spi_interface spi_vif1;
    spi_agent_config1 spi_agnt_cfg1;

    
    // Required Variables
    bit [2:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP1; 
    
    // Constructor
    function new(string name = "spi_monitor1", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor Constructed ------", UVM_LOW);
    endfunction


    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP1 = new("analysis_port_SPImntrAP1", this);
    endfunction
 

     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-1 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif1.SLVSEL == 1) @(spi_vif1.SLVSEL);
			fork
				begin
		            while(spi_vif1.SLVSEL == 0) begin
		              @(posedge spi_vif1.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif1.MOSI;
		              spi_item.nedge_miso[j] = spi_vif1.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif1.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif1.MOSI;
		              spi_item.pedge_miso[i] = spi_vif1.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg1.char_len) begin
		              		#(spi_vif1.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif1.SCLK);
					@(spi_vif1.SLVSEL);
					spi_item.sclk_freq = spi_vif1.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg1.slvsel;
					spi_item.mode = spi_agnt_cfg1.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e",spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP1.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass



//--------- SPI Monitor for SS line 2 ----------------//
class spi_monitor2 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor2)

    // Required Instances
    spi_sequence_item spi_item;
    spi_agent_config2 spi_agnt_cfg2;
  	virtual spi_interface spi_vif2;
 
    
    // Required Variables
    parameter PCLK_FREQ = 100_000_000; // 100MHz
    bit [2:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP2; 
    
    // Constructor
    function new(string name = "spi_monitor2", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor2 Constructed ------", UVM_LOW);
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor2 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP2 = new("analysis_port_SPImntrAP2", this);
    endfunction
 
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-2 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif2.SLVSEL == 1) @(spi_vif2.SLVSEL);
			fork
				begin
		            while(spi_vif2.SLVSEL == 0) begin
		              @(posedge spi_vif2.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif2.MOSI;
		              spi_item.nedge_miso[j] = spi_vif2.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif2.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif2.MOSI;
		              spi_item.pedge_miso[i] = spi_vif2.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg2.char_len) begin
		              		#(spi_vif2.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif2.SCLK);
					@(spi_vif2.SLVSEL);
					spi_item.sclk_freq = spi_vif2.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg2.slvsel;
					spi_item.mode = spi_agnt_cfg2.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e",spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP2.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass


//--------- SPI Monitor for SS line 3 ----------------//
class spi_monitor3 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor3)

    // Required Instances
    spi_sequence_item spi_item;
    spi_agent_config3 spi_agnt_cfg3;
  	virtual spi_interface spi_vif3;

    // Required Variables
    parameter PCLK_FREQ = 100_000_000; // 100MHz
    bit [2:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;

    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP3; 
    
    // Constructor
    function new(string name = "spi_monitor3", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor3 Constructed ------", UVM_LOW);
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor3 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP3 = new("analysis_port_SPImntrAP3", this);
    endfunction
 
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-3 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif3.SLVSEL == 1) @(spi_vif3.SLVSEL);
			fork
				begin
		            while(spi_vif3.SLVSEL == 0) begin
		              @(posedge spi_vif3.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif3.MOSI;
		              spi_item.nedge_miso[j] = spi_vif3.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif3.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif3.MOSI;
		              spi_item.pedge_miso[i] = spi_vif3.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg3.char_len) begin
		              		#(spi_vif3.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif3.SCLK);
					@(spi_vif3.SLVSEL);
					spi_item.sclk_freq = spi_vif3.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg3.slvsel;
					spi_item.mode = spi_agnt_cfg3.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e", spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP3.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass

//--------- SPI Monitor for SS line 4 ----------------//
class spi_monitor4 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor4)

    // Required Instances
    spi_sequence_item spi_item;
    spi_agent_config4 spi_agnt_cfg4;
  	virtual spi_interface spi_vif4;

    // Required Variables
    parameter PCLK_FREQ = 100_000_000; // 100MHz
    bit [2:0] mode;
    int i,j;
    int length;

    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP4; 
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
    // Constructor
    function new(string name = "spi_monitor4", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor4 Constructed ------", UVM_LOW);
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor4 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP4 = new("analysis_port_SPImntrAP4", this);
    endfunction
 
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-4 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif4.SLVSEL == 1) @(spi_vif4.SLVSEL);
			fork
				begin
		            while(spi_vif4.SLVSEL == 0) begin
		              @(posedge spi_vif4.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif4.MOSI;
		              spi_item.nedge_miso[j] = spi_vif4.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif4.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif4.MOSI;
		              spi_item.pedge_miso[i] = spi_vif4.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg4.char_len) begin
		              		#(spi_vif4.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif4.SCLK);
					@(spi_vif4.SLVSEL);
					spi_item.sclk_freq = spi_vif4.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg4.slvsel;
					spi_item.mode = spi_agnt_cfg4.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e",spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP4.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass

//--------- SPI Monitor for SS line 5 ----------------//
class spi_monitor5 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor5)

    // Required Instances
    spi_sequence_item spi_item;
    spi_agent_config5 spi_agnt_cfg5;
  	virtual spi_interface spi_vif5;

    // Required Variables
    parameter PCLK_FREQ = 100_000_000; // 100MHz
    bit [2:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP5; 
    
    // Constructor
    function new(string name = "spi_monitor5", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor5 Constructed ------", UVM_LOW);
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor5 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP5 = new("analysis_port_SPImntrAP5", this);
    endfunction
 
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-5 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif5.SLVSEL == 1) @(spi_vif5.SLVSEL);
			fork
				begin
		            while(spi_vif5.SLVSEL == 0) begin
		              @(posedge spi_vif5.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif5.MOSI;
		              spi_item.nedge_miso[j] = spi_vif5.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif5.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif5.MOSI;
		              spi_item.pedge_miso[i] = spi_vif5.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg5.char_len) begin
		              		#(spi_vif5.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif5.SCLK);
					@(spi_vif5.SLVSEL);
					spi_item.sclk_freq = spi_vif5.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg5.slvsel;
					spi_item.mode = spi_agnt_cfg5.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e", spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP5.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass

//--------- SPI Monitor for SS line 6 ----------------//
class spi_monitor6 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor6)

    // Required Instances
    spi_sequence_item spi_item;
    spi_agent_config6 spi_agnt_cfg6;
  	virtual spi_interface spi_vif6;

    // Required Variables
    parameter PCLK_FREQ = 100_000_000; // 100MHz
    bit [2:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP6; 
    
    // Constructor
    function new(string name = "spi_monitor6", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor6 Constructed ------", UVM_LOW);
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor6 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP6 = new("analysis_port_SPImntrAP6", this);
    endfunction
 
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-6 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif6.SLVSEL == 1) @(spi_vif6.SLVSEL);
			fork
				begin
		            while(spi_vif6.SLVSEL == 0) begin
		              @(posedge spi_vif6.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif6.MOSI;
		              spi_item.nedge_miso[j] = spi_vif6.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif6.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif6.MOSI;
		              spi_item.pedge_miso[i] = spi_vif6.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg6.char_len) begin
		              		#(spi_vif6.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif6.SCLK);
					@(spi_vif6.SLVSEL);
					spi_item.sclk_freq = spi_vif6.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg6.slvsel;
					spi_item.mode = spi_agnt_cfg6.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e", spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP6.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass

//--------- SPI Monitor for SS line 7 ----------------//
class spi_monitor7 extends uvm_monitor;

    // Factory Registration
    `uvm_component_utils(spi_monitor7)

    // Required Instances
    spi_sequence_item spi_item;
    spi_agent_config7 spi_agnt_cfg7;
  	virtual spi_interface spi_vif7;

    // Required Variables
    parameter PCLK_FREQ = 100_000_000; // 100MHz
    bit [2:0] mode;
    int i,j;
    int length;
 	
  	// interrupt
  	uvm_event spi_tx_done;
  
    // Analysis Ports // SPI Monitor to Scoreboard
    uvm_analysis_port #(spi_sequence_item) analysis_port_SPImntrAP7; 
    
    // Constructor
    function new(string name = "spi_monitor7", uvm_component parent = null);
        super.new(name, parent);
       // `uvm_info(get_type_name(), "------ SPI Monitor7 Constructed ------", UVM_LOW);
    endfunction

    // ---------- Build Phase ----------//
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //`uvm_info(get_type_name, "SPI Monitor7 'Build Phase' Started", UVM_LOW);
        analysis_port_SPImntrAP7 = new("analysis_port_SPImntrAP7", this);
    endfunction
 
     // ---------- Run Phase ----------//
     virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "===== SPI Monitor-7 Run Phase Started =====", UVM_HIGH);
        #2ns;
		forever begin
			spi_item = spi_sequence_item::type_id::create("spi_item", this);
			spi_item.char_len = 0;
			i=0;
			j=0;
			while(spi_vif7.SLVSEL == 1) @(spi_vif7.SLVSEL);
			fork
				begin
		            while(spi_vif7.SLVSEL == 0) begin
		              @(posedge spi_vif7.SCLK);
		              spi_item.nedge_mosi[j] = spi_vif7.MOSI;
		              spi_item.nedge_miso[j] = spi_vif7.MISO;
		              spi_item.char_len++;
		              j++;                                  
		              @(negedge spi_vif7.SCLK);
		              spi_item.pedge_mosi[i] = spi_vif7.MOSI;
		              spi_item.pedge_miso[i] = spi_vif7.MISO;
		              i++;
		              if(spi_item.char_len == spi_agnt_cfg7.char_len) begin
		              		#(spi_vif7.sclk_period*(0.5));
		              		spi_tx_done.trigger;
		              end
		            end
				end
				begin
				    @(spi_vif7.SCLK);
					@(spi_vif7.SLVSEL);
					spi_item.sclk_freq = spi_vif7.sclk_freq;
					spi_item.slvsel = spi_agnt_cfg7.slvsel;
					spi_item.mode = spi_agnt_cfg7.mode;
					//`uvm_info (get_type_name(), $sformatf("mode = %0d || SLV = %b || LEN = %0d || S_FREQ = %0e", spi_item.mode, spi_item.slvsel, spi_item.char_len, spi_item.sclk_freq), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MISO = %0h", spi_item.pedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MISO = %0h", spi_item.nedge_miso), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode0_MOSI = %0h", spi_item.pedge_mosi), UVM_HIGH);
					`uvm_info (get_type_name(), $sformatf("mode1_MOSI = %0h", spi_item.nedge_mosi), UVM_HIGH);
					analysis_port_SPImntrAP7.write(spi_item);
				end
			join_any
			disable fork;
		end
    endtask

endclass



