class apb_spi_base_test extends uvm_test;

    // Factory Registration
    `uvm_component_utils(apb_spi_base_test)

    // Environment & Environment Config Instances
    environment env;
    environment_config env_cfg;

    // Agent Config Instances
    interrupt_agent_config intr_agnt_cfg;
    apb_agent_config apb_agnt_cfg;
    spi_agent_config0 spi_agnt_cfg0;
    spi_agent_config1 spi_agnt_cfg1;
    spi_agent_config2 spi_agnt_cfg2;
    spi_agent_config3 spi_agnt_cfg3;
    spi_agent_config4 spi_agnt_cfg4;
    spi_agent_config5 spi_agnt_cfg5;    
    spi_agent_config6 spi_agnt_cfg6;
    spi_agent_config7 spi_agnt_cfg7;
   
    // Virtual Sequence Instance
    apb_spi_vseq_base v_seq;
	spi_lsb_sequence lsb_seq;
	spi_modes_sequence modes_seq;
	spi_divider_sequence div_seq;
	spi_interrupt_sequence intr_seq;
	spi_char_len_sequence char_len_seq;
	spi_auto_ss_sequence auto_ss_seq;
	spi_slvsel_sequence slvsel_seq;
	spi_random_sequence rand_seq;
	spi_combination_sequence comb_seq;
	
	// register test sequences
	spi_reset_sequence reset_seq;
  	spi_reg_access_sequence reg_access_seq;
  	spi_reg_reset_sequence reg_reset_seq;
  	spi_reg_bit_bash_sequence reg_bit_bash_seq;
  	spi_reg_wr_sequence reg_wr_seq;
  	  	
    // Constructor Function
    function new(string name = "apb_spi_base_test", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== APB-SPI Base Test Constructed =====", UVM_LOW)
    endfunction
	
	
    // ---------- Build Phase ---------- //
    // Build Environment, Environment Config
    // Send Environment Config to Environment via uvm_config database
    // Build APB & SPI Agent Configs
    // Send Agent Configs to desired agents
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("get_type_name", "===== APB-SPI Base Test Build Phase Started =====", UVM_MEDIUM)
        
        env = environment::type_id::create("env", this);
        env_cfg = environment_config::type_id::create("env_cfg", this);
        apb_agnt_cfg = apb_agent_config::type_id::create("apb_agnt_cfg", this);
        intr_agnt_cfg = interrupt_agent_config::type_id::create("intr_agnt_cfg", this);
        uvm_config_db#(environment_config)::set(this, "env", "env_cfg", env_cfg);
        uvm_config_db#(apb_agent_config)::set(this, "env.apb_agnt", "apb_agnt_cfg", apb_agnt_cfg);
        uvm_config_db#(interrupt_agent_config)::set(this, "env.intr_agnt", "intr_agnt_cfg", intr_agnt_cfg);
        
        // multiple spi agent configs for multiple ss lines
        spi_agnt_cfg0 = spi_agent_config0::type_id::create("spi_agnt_cfg0", this);
        spi_agnt_cfg1 = spi_agent_config1::type_id::create("spi_agnt_cfg1", this);
        spi_agnt_cfg2 = spi_agent_config2::type_id::create("spi_agnt_cfg2", this);
        spi_agnt_cfg3 = spi_agent_config3::type_id::create("spi_agnt_cfg3", this);        
        spi_agnt_cfg4 = spi_agent_config4::type_id::create("spi_agnt_cfg4", this);
        spi_agnt_cfg5 = spi_agent_config5::type_id::create("spi_agnt_cfg5", this);        
        spi_agnt_cfg6 = spi_agent_config6::type_id::create("spi_agnt_cfg6", this);
        spi_agnt_cfg7 = spi_agent_config7::type_id::create("spi_agnt_cfg7", this);

        uvm_config_db#(spi_agent_config0)::set(this, "env.spi_agnt0", "spi_agnt_cfg0", spi_agnt_cfg0); 
        uvm_config_db#(spi_agent_config1)::set(this, "env.spi_agnt1", "spi_agnt_cfg1", spi_agnt_cfg1); 
        uvm_config_db#(spi_agent_config2)::set(this, "env.spi_agnt2", "spi_agnt_cfg2", spi_agnt_cfg2);  
		uvm_config_db#(spi_agent_config3)::set(this, "env.spi_agnt3", "spi_agnt_cfg3", spi_agnt_cfg3); 
		uvm_config_db#(spi_agent_config4)::set(this, "env.spi_agnt4", "spi_agnt_cfg4", spi_agnt_cfg4); 
		uvm_config_db#(spi_agent_config5)::set(this, "env.spi_agnt5", "spi_agnt_cfg5", spi_agnt_cfg5); 
		uvm_config_db#(spi_agent_config6)::set(this, "env.spi_agnt6", "spi_agnt_cfg6", spi_agnt_cfg6);  
		uvm_config_db#(spi_agent_config7)::set(this, "env.spi_agnt7", "spi_agnt_cfg7", spi_agnt_cfg7);  	
				
    endfunction


    // ---------- End of Elaboration Phase ---------- //
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("get_type_name", "===== APB-SPI Base Test Elaboration Phase Done =====", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction
    
    // Method to initialize the virtual sequence handles
    function void init_vseq(apb_spi_vseq_base v_seq);
    	v_seq.spi_rb = env.spi_rb;
        v_seq.apb_seqr = env.apb_agnt.apb_seqr;       
        v_seq.spi_seqr0 = env.spi_agnt0.spi_seqr0;
        v_seq.spi_seqr1 = env.spi_agnt1.spi_seqr1;
        v_seq.spi_seqr2 = env.spi_agnt2.spi_seqr2;
        v_seq.spi_seqr3 = env.spi_agnt3.spi_seqr3; 
        v_seq.spi_seqr4 = env.spi_agnt4.spi_seqr4;  
        v_seq.spi_seqr5 = env.spi_agnt5.spi_seqr5;
        v_seq.spi_seqr6 = env.spi_agnt6.spi_seqr6; 
        v_seq.spi_seqr7 = env.spi_agnt7.spi_seqr7;     
    endfunction


	// ------------------------------------------------------------ //
	// ---------- Inidividual Tasks to Control Sequences ---------- //
	// ------------------------------------------------------------ //
	
	// --------- SPI LSB/MSB First Sequence ----------//
	task run_lsb_sequence(input bit lsb);
		lsb_seq = spi_lsb_sequence::type_id::create("lsb_seq");
		init_vseq(lsb_seq);
		lsb_seq.lsb = lsb;
		lsb_seq.start(null);
	endtask

	// --------- SPI Modes of Operations Sequence ----------//
	task run_modes_sequence(input bit [1:0] mode);
		modes_seq = spi_modes_sequence::type_id::create("modes_seq");
		init_vseq(modes_seq);
		modes_seq.mode = mode;
		modes_seq.start(null);	
	endtask

	// --------- SPI Divider Sequence ----------//
	task run_divider_sequence(input bit [15:0] divider);
		div_seq = spi_divider_sequence::type_id::create("div_seq");
		init_vseq(div_seq);
		div_seq.divider = divider;
		div_seq.start(null);
	endtask

	// --------- SPI Interrupt Sequence ----------//
	task run_interrupt_sequence(input bit ie);
		intr_seq = spi_interrupt_sequence::type_id::create("intr_seq");
		init_vseq(intr_seq);
		intr_seq.ie = ie;
		intr_seq.start(null);
	endtask	
	
	// --------- SPI Character Length Sequence ----------//
	task run_char_len_sequence(input bit [6:0] char_len);
		char_len_seq = spi_char_len_sequence::type_id::create("char_len_seq");
		init_vseq(char_len_seq);
		char_len_seq.char_len = char_len;
		char_len_seq.start(null);		
	endtask
	
	
	// --------- SPI Auto/Manual Slave Select Sequence ----------//
	task run_auto_ss_sequence(input bit ass);
		auto_ss_seq = spi_auto_ss_sequence::type_id::create("auto_ss_seq");
		init_vseq(auto_ss_seq);
		auto_ss_seq.ass = ass;
		auto_ss_seq.start(null);	
	endtask
	
	// --------- SPI Slave Select Sequence ----------//
	task run_slvsel_sequence(input bit [7:0] slvsel);
		slvsel_seq = spi_slvsel_sequence::type_id::create("slvsel_seq");
		init_vseq(slvsel_seq);
		slvsel_seq.slvsel = slvsel;
		slvsel_seq.start(null);
	endtask	
	
 	// --------- SPI Random Sequence ----------//
	task run_rand_sequence;
		rand_seq = spi_random_sequence::type_id::create("rand_seq");
		init_vseq(rand_seq);
		rand_seq.start(null);
	endtask	
 
 	// --------- SPI Reset Sequence ----------//
	task run_reset_sequence;
		reset_seq = spi_reset_sequence::type_id::create("reset_seq");
		init_vseq(reset_seq);
		reset_seq.start(null);
	endtask	
 	
 	task run_comb_sequence(input bit [15:0] divider, input bit [7:0] slvsel, input bit [6:0] char_len, input bit [1:0] mode, input bit lsb, input bit ass, input bit ie);
 		comb_seq = spi_combination_sequence::type_id::create("comb_seq");
 		init_vseq(comb_seq);
 		comb_seq.slvsel = slvsel;
 		comb_seq.divider = divider;
 		comb_seq.char_len = char_len;
 		comb_seq.mode = mode;
 		comb_seq.lsb = lsb;
 		comb_seq.ass = ass;
 		comb_seq.ie = ie;
 		comb_seq.start(null); 		
 	endtask

 
 	//------------------- Register Tests ------------------//
	task run_reg_access_sequence;
		reg_access_seq = spi_reg_access_sequence::type_id::create("reg_access_seq");
		init_vseq(reg_access_seq);
		reg_access_seq.start(null);
	endtask	
	
 	task run_reg_bit_bash_sequence;
		reg_bit_bash_seq = spi_reg_bit_bash_sequence::type_id::create("reg_bit_bash_seq");
		init_vseq(reg_bit_bash_seq);
		reg_bit_bash_seq.start(null);
	endtask	
	 
 	task run_reg_reset_sequence;
		reg_reset_seq = spi_reg_reset_sequence::type_id::create("reg_reset_seq");
		init_vseq(reg_reset_seq);
		reg_reset_seq.start(null);
	endtask	
	
	task run_reg_wr_sequence;
		reg_wr_seq = spi_reg_wr_sequence::type_id::create("reg_wr_seq");
		init_vseq(reg_wr_seq);
 		reg_wr_seq.start(null);
 	endtask
 
endclass




