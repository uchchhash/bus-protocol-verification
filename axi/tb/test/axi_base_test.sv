//====================================================================//
//                         AXI Base Test Class                        //
//====================================================================//

class axi_base_test extends uvm_test;

  // ------------------------------------------------ //
  //               Factory Registration               //
  // ------------------------------------------------ //
  `uvm_component_utils(axi_base_test)

  // ------------------------------------------------ //
  //               Component Declarations             //
  // ------------------------------------------------ //
  environment           env;
  environment_config    env_cfg;
  axi_agent_config      axi_agnt_cfg;

  // AXI Sequences
  axi_reset_sequence      axi_reset_seq;
  axi_write_addr_sequence axi_waddr_seq;
  axi_write_data_sequence axi_wdata_seq;
  axi_read_addr_sequence  axi_raddr_seq;

  // AXI Packet Structures
  aw_struct aw_pkt;
  w_struct  w_pkt;
  ar_struct ar_pkt;

  // Feedback Address Storage
  bit [31:0] feedback_addr[$];

  // ------------------------------------------------ //
  //                    Methods                       //
  // ------------------------------------------------ //
  extern function new(string name = "axi_base_test", uvm_component parent = null);  
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);

  extern task run_reset_sequence;
  extern task run_write_addr_sequence(aw_struct aw_pkt);
  extern task run_write_data_sequence(w_struct w_pkt);   
  extern task run_read_addr_sequence(ar_struct ar_pkt);
  extern task run_write_data_test_sequence(
    input bit [DATA_WIDTH-1:0] wdata,
    input bit [STRB_WIDTH-1:0] wstrb,
    input bit rand_data,
    input bit rand_wstrb,
    input bit has_delay
  );
  extern task run_write_test_sequence(
    input bit [AWID_WIDTH-1:0] awid,
    input bit [ADDR_WIDTH-1:0] awaddr,
    input bit [3:0] awlen,
    input bit [2:0] awsize,
    input bit [1:0] awburst,
    input bit rand_id,
    input bit rand_addr,
    input bit rand_len,
    input bit rand_size,
    input bit rand_burst,
    input bit has_delay
  );
  extern task run_read_test_sequence(
    input bit [ARID_WIDTH-1:0] arid,
    input bit [ADDR_WIDTH-1:0] araddr,
    input bit [3:0] arlen,
    input bit [2:0] arsize,
    input bit [1:0] arburst,
    input bit rand_id,
    input bit rand_addr,
    input bit rand_len,
    input bit rand_size,
    input bit rand_burst,
    input bit has_delay
  );

endclass : axi_base_test


// ------------------------------------------------------------ //
//                     Constructor Function                     //
// ------------------------------------------------------------ //
function axi_base_test::new(string name = "axi_base_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Base Test : Constructed *****", UVM_NONE);
endfunction


// ------------------------------------------------------------ //
//                         Build Phase                          //
// ------------------------------------------------------------ //
function void axi_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "***** AXI Base Test : Inside Build Phase *****", UVM_NONE);

  // Create environment and configuration objects
  env         = environment::type_id::create("env", this);
  env_cfg     = environment_config::type_id::create("env_cfg", this);
  axi_agnt_cfg = axi_agent_config::type_id::create("axi_agnt_cfg", this);

  // Send configurations to the environment and agent using uvm_config_db
  uvm_config_db#(environment_config)::set(this, "env", "env_cfg", env_cfg);
  uvm_config_db#(axi_agent_config)::set(this, "env.axi_agnt", "axi_agnt_cfg", axi_agnt_cfg);
endfunction


// ------------------------------------------------------------ //
//                 End of Elaboration Phase                    //
// ------------------------------------------------------------ //
function void axi_base_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  `uvm_info(get_type_name(), "***** AXI Base Test : End of Elaboration Phase *****", UVM_NONE);
  uvm_top.print_topology();
endfunction


// ------------------------------------------------------------ //
//              Individual Sequence Control Tasks              //
// ------------------------------------------------------------ //

task axi_base_test::run_reset_sequence;
  axi_reset_seq = axi_reset_sequence::type_id::create("axi_reset_seq");
  axi_reset_seq.start(env.axi_agnt.axi_seqr);
endtask

task axi_base_test::run_write_addr_sequence(aw_struct aw_pkt);
  axi_waddr_seq = axi_write_addr_sequence::type_id::create("axi_waddr_seq");
  axi_waddr_seq.aw_pkt = aw_pkt;
  axi_waddr_seq.start(env.axi_agnt.axi_seqr);
endtask

task axi_base_test::run_write_data_sequence(w_struct w_pkt);
  axi_wdata_seq = axi_write_data_sequence::type_id::create("axi_wdata_seq");
  axi_wdata_seq.w_pkt = w_pkt;
  axi_wdata_seq.start(env.axi_agnt.axi_seqr);
endtask

task axi_base_test::run_read_addr_sequence(ar_struct ar_pkt);
  axi_raddr_seq = axi_read_addr_sequence::type_id::create("axi_raddr_seq");
  axi_raddr_seq.ar_pkt = ar_pkt;
  axi_raddr_seq.start(env.axi_agnt.axi_seqr);
endtask

task axi_base_test::run_write_test_sequence(
  input bit [AWID_WIDTH-1:0] awid,
  input bit [ADDR_WIDTH-1:0] awaddr,
  input bit [3:0] awlen,
  input bit [2:0] awsize,
  input bit [1:0] awburst,
  input bit rand_id,
  input bit rand_addr,
  input bit rand_len,
  input bit rand_size,
  input bit rand_burst,
  input bit has_delay
);
  aw_pkt.awid       = awid;
  aw_pkt.awaddr     = awaddr;
  aw_pkt.awlen      = awlen;
  aw_pkt.awsize     = awsize;
  aw_pkt.awburst    = awburst;
  aw_pkt.rand_id    = rand_id;
  aw_pkt.rand_addr  = rand_addr;
  aw_pkt.rand_len   = rand_len;
  aw_pkt.rand_size  = rand_size;
  aw_pkt.rand_burst = rand_burst;
  aw_pkt.has_delay  = has_delay;
  run_write_addr_sequence(aw_pkt);
endtask : run_write_test_sequence

task axi_base_test::run_read_test_sequence(
  input bit [ARID_WIDTH-1:0] arid,
  input bit [ADDR_WIDTH-1:0] araddr,
  input bit [3:0] arlen,
  input bit [2:0] arsize,
  input bit [1:0] arburst,
  input bit rand_id,
  input bit rand_addr,
  input bit rand_len,
  input bit rand_size,
  input bit rand_burst,
  input bit has_delay
);
  ar_pkt.arid       = arid;
  ar_pkt.araddr     = araddr;
  ar_pkt.arlen      = arlen;
  ar_pkt.arsize     = arsize;
  ar_pkt.arburst    = arburst;
  ar_pkt.rand_id    = rand_id;
  ar_pkt.rand_addr  = rand_addr;
  ar_pkt.rand_len   = rand_len;
  ar_pkt.rand_size  = rand_size;
  ar_pkt.rand_burst = rand_burst;
  ar_pkt.has_delay  = has_delay;
  run_read_addr_sequence(ar_pkt);
endtask : run_read_test_sequence

task axi_base_test::run_write_data_test_sequence(
  input bit [DATA_WIDTH-1:0] wdata,
  input bit [STRB_WIDTH-1:0] wstrb,
  input bit rand_data,
  input bit rand_wstrb,
  input bit has_delay
);
  w_pkt.wdata      = wdata;
  w_pkt.wstrb      = wstrb;
  w_pkt.rand_data  = rand_data;
  w_pkt.rand_wstrb = rand_wstrb;
  w_pkt.has_delay  = has_delay;
  run_write_data_sequence(w_pkt);
endtask
