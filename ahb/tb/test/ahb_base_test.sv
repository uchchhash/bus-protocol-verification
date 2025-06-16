class ahb_base_test extends uvm_test;
  
    `uvm_component_utils(ahb_base_test)
  
    // Environment Instance
    environment env;
    environment_config env_cfg;
  	ahb_agent_config ahb_agnt_cfg;
  

    function new(string name = "ahb_base_test", uvm_component parent = null);
        super.new(name,parent);
        `uvm_info(get_type_name(), "=AHB BASE TEST CONSTRUCTED",UVM_MEDIUM)
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(),"AHB BASE TEST BUILD PHASE STARTED", UVM_MEDIUM)
        env = environment::type_id::create("env", this);
        env_cfg = environment_config::type_id::create("env_cfg", this);    
        uvm_config_db#(environment_config)::set(this, "env", "env_cfg", env_cfg);
        ahb_agnt_cfg = ahb_agent_config::type_id::create("ahb_agnt_cfg", this);
        uvm_config_db#(ahb_agent_config)::set(this, "env.ahb_agnt", "ahb_agnt_cfg", ahb_agnt_cfg);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_type_name(),"AHB Base Test 'END OF ELABORATION' Phase Started", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction
  
/*
    //-------------------- AHB Reset TRANSFER --------------------//
    task ahb_reset();
        ahb_sequence reset_seq;
        reset_seq = ahb_sequence::type_id::create("reset_seq",this);
        reset_seq.has_reset = 1;
        reset_seq.start(env.ahb_agnt.ahb_seqr);
    endtask
*/

  //-------------------- AHB Random TRANSFER --------------------//

  	task ahb_random_wr(input bit bsy, input bit rnd, input bit rnd_test, input int total_rtest);
  		ahb_random_sequence rand_wr_seq;
        rand_wr_seq = ahb_random_sequence::type_id::create("rand_wr_seq", this);
        rand_wr_seq.rnd = rnd;
        rand_wr_seq.bsy = bsy;
        rand_wr_seq.rnd_test = rnd_test;
        rand_wr_seq.total_rtest = total_rtest;
        rand_wr_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask


  
  //-------------------- Single Word TRANSFER --------------------//

  	task ahb_single_word_write(input bit [31:0] start_address, input bit rnd);
  		ahb_write_sequence single_word_write_seq;
        single_word_write_seq = ahb_write_sequence::type_id::create("single_word_write_seq", this);
      	single_word_write_seq.hwrite = 1;
        single_word_write_seq.start_address = start_address;
        single_word_write_seq.hburst = `SINGLE; 
        single_word_write_seq.hsize = `WORD;
        single_word_write_seq.rnd = rnd;
        single_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_single_word_read(input bit [31:0] start_address);
		ahb_read_sequence single_word_read_seq;
        single_word_read_seq= ahb_read_sequence::type_id::create("single_word_read_seq", this);
      	single_word_read_seq.hwrite = 0;
		single_word_read_seq.start_address = start_address;
        single_word_read_seq.hburst = `SINGLE; 
        single_word_read_seq.hsize = `WORD;
        single_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- Single Byte TRANSFER --------------------//

  	task ahb_single_byte_write(input bit [7:0] start_address, input bit rnd);
  		ahb_write_sequence single_byte_write_seq;
        single_byte_write_seq = ahb_write_sequence::type_id::create("single_byte_write_seq", this);
      	single_byte_write_seq.hwrite = 1;
        single_byte_write_seq.start_address = start_address;
        single_byte_write_seq.hburst = `SINGLE; 
        single_byte_write_seq.hsize = `BYTE;
        single_byte_write_seq.rnd = rnd;
        single_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_single_byte_read(input bit [7:0] start_address);
		ahb_read_sequence single_byte_read_seq;
        single_byte_read_seq= ahb_read_sequence::type_id::create("single_byte_read_seq", this);
      	single_byte_read_seq.hwrite = 0;
		single_byte_read_seq.start_address = start_address;
        single_byte_read_seq.hburst = `SINGLE; 
        single_byte_read_seq.hsize = `BYTE;
        single_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- Single Half-Word TRANSFER --------------------//

  	task ahb_single_halfword_write(input bit [15:0] start_address, input bit rnd);
  		ahb_write_sequence single_halfword_write_seq;
        single_halfword_write_seq = ahb_write_sequence::type_id::create("single_halfword_write_seq", this);
        single_halfword_write_seq.hwrite = 1;
        single_halfword_write_seq.start_address = start_address;
        single_halfword_write_seq.hburst = `SINGLE; 
        single_halfword_write_seq.hsize = `HALFWORD;
        single_halfword_write_seq.rnd = rnd;
        single_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_single_halfword_read(input bit [15:0] start_address);
		ahb_read_sequence single_halfword_read_seq;
        single_halfword_read_seq= ahb_read_sequence::type_id::create("single_halfword_read_seq", this);
        single_halfword_read_seq.hwrite = 0;
		single_halfword_read_seq.start_address = start_address;
        single_halfword_read_seq.hburst = `SINGLE; 
        single_halfword_read_seq.hsize = `HALFWORD;
        single_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask


    //-------------------- Single Half-Word TRANSFER --------------------//

  	task ahb_incr4_halfword_write(input bit [15:0] start_address, input bit rnd);
  		ahb_write_sequence incr4_halfword_write_seq;
        incr4_halfword_write_seq = ahb_write_sequence::type_id::create("incr4_halfword_write_seq", this);
        incr4_halfword_write_seq.hwrite = 1;
        incr4_halfword_write_seq.start_address = start_address;
        incr4_halfword_write_seq.hburst = `INCR4; 
        incr4_halfword_write_seq.hsize = `HALFWORD;
        incr4_halfword_write_seq.rnd = rnd;
        incr4_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr4_halfword_read(input bit [15:0] start_address);
		ahb_read_sequence incr4_halfword_read_seq;
        incr4_halfword_read_seq= ahb_read_sequence::type_id::create("incr4_halfword_read_seq", this);
        incr4_halfword_read_seq.hwrite = 0;
		incr4_halfword_read_seq.start_address = start_address;
        incr4_halfword_read_seq.hburst = `INCR4; 
        incr4_halfword_read_seq.hsize = `HALFWORD;
        incr4_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask
  
/*

 //-------------------- Single Word TRANSFER --------------------//

  	task ahb_single_word_write(input bit [31:0] start_address, input bit rnd);
  		ahb_sequence single_word_write_seq;
        single_word_write_seq = ahb_sequence::type_id::create("single_word_write_seq", this);
      	single_word_write_seq.hwrite = 1;
        single_word_write_seq.start_address = start_address;
        single_word_write_seq.hburst = `SINGLE; 
        single_word_write_seq.hsize = `WORD;
        single_word_write_seq.rnd = rnd;
        single_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_single_word_read(input bit [31:0] start_address);
		ahb_sequence single_word_read_seq;
        single_word_read_seq= ahb_sequence::type_id::create("single_word_read_seq", this);
      	single_word_read_seq.hwrite = 0;
		single_word_read_seq.start_address = start_address;
        single_word_read_seq.hburst = `SINGLE; 
        single_word_read_seq.hsize = `WORD;
        single_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- Single Byte TRANSFER --------------------//

  	task ahb_single_byte_write(input bit [7:0] start_address, input bit rnd);
  		ahb_sequence single_byte_write_seq;
        single_byte_write_seq = ahb_sequence::type_id::create("single_byte_write_seq", this);
      	single_byte_write_seq.hwrite = 1;
        single_byte_write_seq.start_address = start_address;
        single_byte_write_seq.hburst = `SINGLE; 
        single_byte_write_seq.hsize = `BYTE;
        single_byte_write_seq.rnd = rnd;
        single_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_single_byte_read(input bit [7:0] start_address);
		ahb_sequence single_byte_read_seq;
        single_byte_read_seq= ahb_sequence::type_id::create("single_byte_read_seq", this);
      	single_byte_read_seq.hwrite = 0;
		single_byte_read_seq.start_address = start_address;
        single_byte_read_seq.hburst = `SINGLE; 
        single_byte_read_seq.hsize = `BYTE;
        single_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- Single Half-Word TRANSFER --------------------//

  	task ahb_single_halfword_write(input bit [15:0] start_address, input bit rnd);
  		ahb_sequence single_halfword_write_seq;
        single_halfword_write_seq = ahb_sequence::type_id::create("single_halfword_write_seq", this);
        single_halfword_write_seq.hwrite = 1;
        single_halfword_write_seq.start_address = start_address;
        single_halfword_write_seq.hburst = `SINGLE; 
        single_halfword_write_seq.hsize = `HALFWORD;
        single_halfword_write_seq.rnd = rnd;
        single_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_single_halfword_read(input bit [15:0] start_address);
		ahb_sequence single_halfword_read_seq;
        single_halfword_read_seq= ahb_sequence::type_id::create("single_halfword_read_seq", this);
        single_halfword_read_seq.hwrite = 0;
		single_halfword_read_seq.start_address = start_address;
        single_halfword_read_seq.hburst = `SINGLE; 
        single_halfword_read_seq.hsize = `HALFWORD;
        single_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask
    
   //-------------------- INCR Word TRANSFER --------------------//

  	task ahb_incr_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr_word_write_seq;
        incr_word_write_seq = ahb_sequence::type_id::create("incr_word_write_seq", this);
        incr_word_write_seq.hwrite = 1;
        incr_word_write_seq.start_address = start_address;
        incr_word_write_seq.hburst = `INCR; 
        incr_word_write_seq.hsize = `WORD;
        incr_word_write_seq.bsy = bsy;
        incr_word_write_seq.rnd = rnd;
        incr_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence incr_word_read_seq;
        incr_word_read_seq= ahb_sequence::type_id::create("incr_word_read_seq", this);
        incr_word_read_seq.hwrite = 0;
		incr_word_read_seq.start_address = start_address;
        incr_word_read_seq.hburst = `INCR; 
        incr_word_read_seq.hsize = `WORD;
        incr_word_read_seq.bsy = bsy;
        incr_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- INCR Byte TRANSFER --------------------//

  	task ahb_incr_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr_byte_write_seq;
        incr_byte_write_seq = ahb_sequence::type_id::create("incr_byte_write_seq", this);
        incr_byte_write_seq.hwrite = 1;
        incr_byte_write_seq.start_address = start_address;
        incr_byte_write_seq.hburst = `INCR; 
        incr_byte_write_seq.hsize = `BYTE;
        incr_byte_write_seq.bsy = bsy;
        incr_byte_write_seq.rnd = rnd;
        incr_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence incr_byte_read_seq;
        incr_byte_read_seq= ahb_sequence::type_id::create("incr_byte_read_seq", this);
        incr_byte_read_seq.hwrite = 0;
		incr_byte_read_seq.start_address = start_address;
        incr_byte_read_seq.hburst = `INCR; 
        incr_byte_read_seq.hsize = `BYTE;
        incr_byte_read_seq.bsy = bsy;
        incr_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- INCR Half-Word TRANSFER --------------------//

  	task ahb_incr_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr_halfword_write_seq;
        incr_halfword_write_seq = ahb_sequence::type_id::create("incr_halfword_write_seq", this);
        incr_halfword_write_seq.hwrite = 1;
        incr_halfword_write_seq.start_address = start_address;
        incr_halfword_write_seq.hburst = `INCR; 
        incr_halfword_write_seq.hsize = `HALFWORD;
        incr_halfword_write_seq.bsy = bsy;
        incr_halfword_write_seq.rnd = rnd;
        incr_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence incr_halfword_read_seq;
        incr_halfword_read_seq= ahb_sequence::type_id::create("incr_halfword_read_seq", this);
        incr_halfword_read_seq.hwrite = 0;
		incr_halfword_read_seq.start_address = start_address;
        incr_halfword_read_seq.hburst = `INCR; 
        incr_halfword_read_seq.hsize = `HALFWORD;
        incr_halfword_read_seq.bsy = bsy;
        incr_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask
  
    
   //-------------------- incr4 Word TRANSFER --------------------//

  	task ahb_incr4_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr4_word_write_seq;
        incr4_word_write_seq = ahb_sequence::type_id::create("incr4_word_write_seq", this);
        incr4_word_write_seq.hwrite = 1;
        incr4_word_write_seq.start_address = start_address;
        incr4_word_write_seq.hburst = `INCR4; 
        incr4_word_write_seq.hsize = `WORD;
        incr4_word_write_seq.bsy = bsy;
        incr4_word_write_seq.rnd = rnd;
        incr4_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr4_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence incr4_word_read_seq;
        incr4_word_read_seq= ahb_sequence::type_id::create("incr4_word_read_seq", this);
        incr4_word_read_seq.hwrite = 0;
		incr4_word_read_seq.start_address = start_address;
        incr4_word_read_seq.hburst = `INCR4; 
        incr4_word_read_seq.hsize = `WORD;
        incr4_word_read_seq.bsy = bsy;
        incr4_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- incr4 Byte TRANSFER --------------------//

  	task ahb_incr4_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr4_byte_write_seq;
        incr4_byte_write_seq = ahb_sequence::type_id::create("incr4_byte_write_seq", this);
        incr4_byte_write_seq.hwrite = 1;
        incr4_byte_write_seq.start_address = start_address;
        incr4_byte_write_seq.hburst = `INCR4; 
        incr4_byte_write_seq.hsize = `BYTE;
        incr4_byte_write_seq.bsy = bsy;
        incr4_byte_write_seq.rnd = rnd;
        incr4_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr4_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence incr4_byte_read_seq;
        incr4_byte_read_seq= ahb_sequence::type_id::create("incr4_byte_read_seq", this);
        incr4_byte_read_seq.hwrite = 0;
		incr4_byte_read_seq.start_address = start_address;
        incr4_byte_read_seq.hburst = `INCR4; 
        incr4_byte_read_seq.hsize = `BYTE;
        incr4_byte_read_seq.bsy = bsy;
        incr4_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- incr4 Half-Word TRANSFER --------------------//

  	task ahb_incr4_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr4_halfword_write_seq;
        incr4_halfword_write_seq = ahb_sequence::type_id::create("incr4_halfword_write_seq", this);
        incr4_halfword_write_seq.hwrite = 1;
        incr4_halfword_write_seq.start_address = start_address;
        incr4_halfword_write_seq.hburst = `INCR4; 
        incr4_halfword_write_seq.hsize = `HALFWORD;
        incr4_halfword_write_seq.bsy = bsy;
        incr4_halfword_write_seq.rnd = rnd;
        incr4_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr4_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence incr4_halfword_read_seq;
        incr4_halfword_read_seq= ahb_sequence::type_id::create("incr4_halfword_read_seq", this);
        incr4_halfword_read_seq.hwrite = 0;
		incr4_halfword_read_seq.start_address = start_address;
        incr4_halfword_read_seq.hburst = `INCR4; 
        incr4_halfword_read_seq.hsize = `HALFWORD;
        incr4_halfword_read_seq.bsy = bsy;
        incr4_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask


 //-------------------- incr8 Word TRANSFER --------------------//

  	task ahb_incr8_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr8_word_write_seq;
        incr8_word_write_seq = ahb_sequence::type_id::create("incr8_word_write_seq", this);
        incr8_word_write_seq.hwrite = 1;
        incr8_word_write_seq.start_address = start_address;
        incr8_word_write_seq.hburst = `INCR8; 
        incr8_word_write_seq.hsize = `WORD;
        incr8_word_write_seq.bsy = bsy;
        incr8_word_write_seq.rnd = rnd;
        incr8_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr8_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence incr8_word_read_seq;
        incr8_word_read_seq= ahb_sequence::type_id::create("incr8_word_read_seq", this);
        incr8_word_read_seq.hwrite = 0;
		incr8_word_read_seq.start_address = start_address;
        incr8_word_read_seq.hburst = `INCR8; 
        incr8_word_read_seq.hsize = `WORD;
        incr8_word_read_seq.bsy = bsy;
        incr8_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask


    //-------------------- incr8 Byte TRANSFER --------------------//

  	task ahb_incr8_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr8_byte_write_seq;
        incr8_byte_write_seq = ahb_sequence::type_id::create("incr8_byte_write_seq", this);
        incr8_byte_write_seq.hwrite = 1;
        incr8_byte_write_seq.start_address = start_address;
        incr8_byte_write_seq.hburst = `INCR8; 
        incr8_byte_write_seq.hsize = `BYTE;
        incr8_byte_write_seq.bsy = bsy;
        incr8_byte_write_seq.rnd = rnd;
        incr8_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr8_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence incr8_byte_read_seq;
        incr8_byte_read_seq= ahb_sequence::type_id::create("incr8_byte_read_seq", this);
        incr8_byte_read_seq.hwrite = 0;
		incr8_byte_read_seq.start_address = start_address;
        incr8_byte_read_seq.hburst = `INCR8; 
        incr8_byte_read_seq.hsize = `BYTE;
        incr8_byte_read_seq.bsy = bsy;
        incr8_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- incr8 Half-Word TRANSFER --------------------//

  	task ahb_incr8_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr8_halfword_write_seq;
        incr8_halfword_write_seq = ahb_sequence::type_id::create("incr8_halfword_write_seq", this);
        incr8_halfword_write_seq.hwrite = 1;
        incr8_halfword_write_seq.start_address = start_address;
        incr8_halfword_write_seq.hburst = `INCR8; 
        incr8_halfword_write_seq.hsize = `HALFWORD;
        incr8_halfword_write_seq.bsy = bsy;
        incr8_halfword_write_seq.rnd = rnd;
        incr8_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr8_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence incr8_halfword_read_seq;
        incr8_halfword_read_seq= ahb_sequence::type_id::create("incr8_halfword_read_seq", this);
        incr8_halfword_read_seq.hwrite = 0;
		incr8_halfword_read_seq.start_address = start_address;
        incr8_halfword_read_seq.hburst = `INCR8; 
        incr8_halfword_read_seq.hsize = `HALFWORD;
        incr8_halfword_read_seq.bsy = bsy;
        incr8_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

 //-------------------- incr16 Word TRANSFER --------------------//

  	task ahb_incr16_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr16_word_write_seq;
        incr16_word_write_seq = ahb_sequence::type_id::create("incr16_word_write_seq", this);
        incr16_word_write_seq.hwrite = 1;
        incr16_word_write_seq.start_address = start_address;
        incr16_word_write_seq.hburst = `INCR16; 
        incr16_word_write_seq.hsize = `WORD;
        incr16_word_write_seq.bsy = bsy;
        incr16_word_write_seq.rnd = rnd;
        incr16_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr16_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence incr16_word_read_seq;
        incr16_word_read_seq= ahb_sequence::type_id::create("incr16_word_read_seq", this);
        incr16_word_read_seq.hwrite = 0;
		incr16_word_read_seq.start_address = start_address;
        incr16_word_read_seq.hburst = `INCR16; 
        incr16_word_read_seq.hsize = `WORD;
        incr16_word_read_seq.bsy = bsy;
        incr16_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- incr16 Byte TRANSFER --------------------//

  	task ahb_incr16_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr16_byte_write_seq;
        incr16_byte_write_seq = ahb_sequence::type_id::create("incr16_byte_write_seq", this);
        incr16_byte_write_seq.hwrite = 1;
        incr16_byte_write_seq.start_address = start_address;
        incr16_byte_write_seq.hburst = `INCR16; 
        incr16_byte_write_seq.hsize = `BYTE;
        incr16_byte_write_seq.bsy = bsy;
        incr16_byte_write_seq.rnd = rnd;
        incr16_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr16_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence incr16_byte_read_seq;
        incr16_byte_read_seq= ahb_sequence::type_id::create("incr16_byte_read_seq", this);
        incr16_byte_read_seq.hwrite = 0;
		incr16_byte_read_seq.start_address = start_address;
        incr16_byte_read_seq.hburst = `INCR16; 
        incr16_byte_read_seq.hsize = `BYTE;
        incr16_byte_read_seq.bsy = bsy;
        incr16_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- incr16 Half-Word TRANSFER --------------------//

  	task ahb_incr16_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence incr16_halfword_write_seq;
        incr16_halfword_write_seq = ahb_sequence::type_id::create("incr16_halfword_write_seq", this);
        incr16_halfword_write_seq.hwrite = 1;
        incr16_halfword_write_seq.start_address = start_address;
        incr16_halfword_write_seq.hburst = `INCR16; 
        incr16_halfword_write_seq.hsize = `HALFWORD;
        incr16_halfword_write_seq.bsy = bsy;
        incr16_halfword_write_seq.rnd = rnd;
        incr16_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_incr16_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence incr16_halfword_read_seq;
        incr16_halfword_read_seq= ahb_sequence::type_id::create("incr16_halfword_read_seq", this);
        incr16_halfword_read_seq.hwrite = 0;
		incr16_halfword_read_seq.start_address = start_address;
        incr16_halfword_read_seq.hburst = `INCR16; 
        incr16_halfword_read_seq.hsize = `HALFWORD;
        incr16_halfword_read_seq.bsy = bsy;
        incr16_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask
  
    
   //-------------------- wrap4 Word TRANSFER --------------------//

  	task ahb_wrap4_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap4_word_write_seq;
        wrap4_word_write_seq = ahb_sequence::type_id::create("wrap4_word_write_seq", this);
        wrap4_word_write_seq.hwrite = 1;
        wrap4_word_write_seq.start_address = start_address;
        wrap4_word_write_seq.hburst = `WRAP4; 
        wrap4_word_write_seq.hsize = `WORD;
        wrap4_word_write_seq.bsy = bsy;
        wrap4_word_write_seq.rnd = rnd;
        wrap4_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap4_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence wrap4_word_read_seq;
        wrap4_word_read_seq= ahb_sequence::type_id::create("wrap4_word_read_seq", this);
		wrap4_word_read_seq.hwrite = 0;
		wrap4_word_read_seq.start_address = start_address;
        wrap4_word_read_seq.hburst = `WRAP4; 
        wrap4_word_read_seq.hsize = `WORD;
        wrap4_word_read_seq.bsy = bsy;
        wrap4_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- wrap4 Byte TRANSFER --------------------//

  	task ahb_wrap4_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap4_byte_write_seq;
        wrap4_byte_write_seq = ahb_sequence::type_id::create("wrap4_byte_write_seq", this);
        wrap4_byte_write_seq.hwrite = 1;
        wrap4_byte_write_seq.start_address = start_address;
        wrap4_byte_write_seq.hburst = `WRAP4; 
        wrap4_byte_write_seq.hsize = `BYTE;
        wrap4_byte_write_seq.bsy = bsy;
        wrap4_byte_write_seq.rnd = rnd;
        wrap4_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap4_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence wrap4_byte_read_seq;
        wrap4_byte_read_seq= ahb_sequence::type_id::create("wrap4_byte_read_seq", this);
        wrap4_byte_read_seq.hwrite = 0;
		wrap4_byte_read_seq.start_address = start_address;
        wrap4_byte_read_seq.hburst = `WRAP4; 
        wrap4_byte_read_seq.hsize = `BYTE;
        wrap4_byte_read_seq.bsy = bsy;
        wrap4_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- wrap4 Half-Word TRANSFER --------------------//

  	task ahb_wrap4_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap4_halfword_write_seq;
        wrap4_halfword_write_seq = ahb_sequence::type_id::create("wrap4_halfword_write_seq", this);
        wrap4_halfword_write_seq.hwrite = 1;
        wrap4_halfword_write_seq.start_address = start_address;
        wrap4_halfword_write_seq.hburst = `WRAP4; 
        wrap4_halfword_write_seq.hsize = `HALFWORD;
        wrap4_halfword_write_seq.bsy = bsy;
        wrap4_halfword_write_seq.rnd = rnd;
        wrap4_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap4_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence wrap4_halfword_read_seq;
        wrap4_halfword_read_seq= ahb_sequence::type_id::create("wrap4_halfword_read_seq", this);
        wrap4_halfword_read_seq.hwrite = 0;
		wrap4_halfword_read_seq.start_address = start_address;
        wrap4_halfword_read_seq.hburst = `WRAP4; 
        wrap4_halfword_read_seq.hsize = `HALFWORD;
        wrap4_halfword_read_seq.bsy = bsy;
        wrap4_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

//-------------------- wrap8 Word TRANSFER --------------------//

  	task ahb_wrap8_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap8_word_write_seq;
        wrap8_word_write_seq = ahb_sequence::type_id::create("wrap8_word_write_seq", this);
        wrap8_word_write_seq.hwrite = 1;
        wrap8_word_write_seq.start_address = start_address;
        wrap8_word_write_seq.hburst = `WRAP8; 
        wrap8_word_write_seq.hsize = `WORD;
        wrap8_word_write_seq.bsy = bsy;
        wrap8_word_write_seq.rnd = rnd;
        wrap8_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap8_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence wrap8_word_read_seq;
        wrap8_word_read_seq= ahb_sequence::type_id::create("wrap8_word_read_seq", this);
		wrap8_word_read_seq.hwrite = 0;
		wrap8_word_read_seq.start_address = start_address;
        wrap8_word_read_seq.hburst = `WRAP8; 
        wrap8_word_read_seq.hsize = `WORD;
        wrap8_word_read_seq.bsy = bsy;
        wrap8_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- wrap8 Byte TRANSFER --------------------//

  	task ahb_wrap8_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap8_byte_write_seq;
        wrap8_byte_write_seq = ahb_sequence::type_id::create("wrap8_byte_write_seq", this);
        wrap8_byte_write_seq.hwrite = 1;
        wrap8_byte_write_seq.start_address = start_address;
        wrap8_byte_write_seq.hburst = `WRAP8; 
        wrap8_byte_write_seq.hsize = `BYTE;
        wrap8_byte_write_seq.bsy = bsy;
        wrap8_byte_write_seq.rnd = rnd;
        wrap8_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap8_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence wrap8_byte_read_seq;
        wrap8_byte_read_seq= ahb_sequence::type_id::create("wrap8_byte_read_seq", this);
        wrap8_byte_read_seq.hwrite = 0;
		wrap8_byte_read_seq.start_address = start_address;
        wrap8_byte_read_seq.hburst = `WRAP8; 
        wrap8_byte_read_seq.hsize = `BYTE;
        wrap8_byte_read_seq.bsy = bsy;
        wrap8_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- wrap8 Half-Word TRANSFER --------------------//

  	task ahb_wrap8_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap8_halfword_write_seq;
        wrap8_halfword_write_seq = ahb_sequence::type_id::create("wrap8_halfword_write_seq", this);
        wrap8_halfword_write_seq.hwrite = 1;
        wrap8_halfword_write_seq.start_address = start_address;
        wrap8_halfword_write_seq.hburst = `WRAP8; 
        wrap8_halfword_write_seq.hsize = `HALFWORD;
        wrap8_halfword_write_seq.bsy = bsy;
        wrap8_halfword_write_seq.rnd = rnd;
        wrap8_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap8_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence wrap8_halfword_read_seq;
        wrap8_halfword_read_seq= ahb_sequence::type_id::create("wrap8_halfword_read_seq", this);
        wrap8_halfword_read_seq.hwrite = 0;
		wrap8_halfword_read_seq.start_address = start_address;
        wrap8_halfword_read_seq.hburst = `WRAP8; 
        wrap8_halfword_read_seq.hsize = `HALFWORD;
        wrap8_halfword_read_seq.bsy = bsy;
        wrap8_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

//-------------------- wrap16 Word TRANSFER --------------------//

  	task ahb_wrap16_word_write(input bit [31:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap16_word_write_seq;
        wrap16_word_write_seq = ahb_sequence::type_id::create("wrap16_word_write_seq", this);
        wrap16_word_write_seq.hwrite = 1;
        wrap16_word_write_seq.start_address = start_address;
        wrap16_word_write_seq.hburst = `WRAP16; 
        wrap16_word_write_seq.hsize = `WORD;
        wrap16_word_write_seq.bsy = bsy;
        wrap16_word_write_seq.rnd = rnd;
        wrap16_word_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap16_word_read(input bit [31:0] start_address, input bit bsy);
		ahb_sequence wrap16_word_read_seq;
        wrap16_word_read_seq= ahb_sequence::type_id::create("wrap16_word_read_seq", this);
		wrap16_word_read_seq.hwrite = 0;
		wrap16_word_read_seq.start_address = start_address;
        wrap16_word_read_seq.hburst = `WRAP16; 
        wrap16_word_read_seq.hsize = `WORD;
        wrap16_word_read_seq.bsy = bsy;
        wrap16_word_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- wrap16 Byte TRANSFER --------------------//

  	task ahb_wrap16_byte_write(input bit [7:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap16_byte_write_seq;
        wrap16_byte_write_seq = ahb_sequence::type_id::create("wrap16_byte_write_seq", this);
        wrap16_byte_write_seq.hwrite = 1;
        wrap16_byte_write_seq.start_address = start_address;
        wrap16_byte_write_seq.hburst = `WRAP16; 
        wrap16_byte_write_seq.hsize = `BYTE;       
        wrap16_byte_write_seq.bsy = bsy;
        wrap16_byte_write_seq.rnd = rnd;
        wrap16_byte_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap16_byte_read(input bit [7:0] start_address, input bit bsy);
		ahb_sequence wrap16_byte_read_seq;
        wrap16_byte_read_seq= ahb_sequence::type_id::create("wrap16_byte_read_seq", this);
        wrap16_byte_read_seq.hwrite = 0;
		wrap16_byte_read_seq.start_address = start_address;
        wrap16_byte_read_seq.hburst = `WRAP16; 
        wrap16_byte_read_seq.hsize = `BYTE;
        wrap16_byte_read_seq.bsy = bsy;
        wrap16_byte_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

    //-------------------- wrap16 Half-Word TRANSFER --------------------//

  	task ahb_wrap16_halfword_write(input bit [15:0] start_address, input bit bsy, input bit rnd);
  		ahb_sequence wrap16_halfword_write_seq;
        wrap16_halfword_write_seq = ahb_sequence::type_id::create("wrap16_halfword_write_seq", this);
        wrap16_halfword_write_seq.hwrite = 1;
        wrap16_halfword_write_seq.start_address = start_address;
        wrap16_halfword_write_seq.hburst = `WRAP16; 
        wrap16_halfword_write_seq.hsize = `HALFWORD;
        wrap16_halfword_write_seq.bsy = bsy;
        wrap16_halfword_write_seq.rnd = rnd;
        wrap16_halfword_write_seq.start(env.ahb_agnt.ahb_seqr);
  	endtask
 
  	task ahb_wrap16_halfword_read(input bit [15:0] start_address, input bit bsy);
		ahb_sequence wrap16_halfword_read_seq;
        wrap16_halfword_read_seq= ahb_sequence::type_id::create("wrap16_halfword_read_seq", this);
        wrap16_halfword_read_seq.hwrite = 0;
		wrap16_halfword_read_seq.start_address = start_address;
        wrap16_halfword_read_seq.hburst = `WRAP16; 
        wrap16_halfword_read_seq.hsize = `HALFWORD;
        wrap16_halfword_read_seq.bsy = bsy;
        wrap16_halfword_read_seq.start(env.ahb_agnt.ahb_seqr);
	endtask

*/
  
endclass
	
	
