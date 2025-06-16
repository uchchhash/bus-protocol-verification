`include "uvm_macros.svh"
import uvm_pkg::*;


// Test class instantiates the environment and starts it
class apb_base_test extends uvm_test;
	`uvm_component_utils(apb_base_test)
  
	function new(string name="apb_base_test", uvm_component parent=null);    
    	super.new(name, parent);
    	`uvm_info(get_type_name(), "---- APB BASE Test Constructed ----", UVM_HIGH);  
  	endfunction
  
  	// Environment and sequence_item instances
  
  	env apb_env;
  	virtual apb_interface apb_intf;
 	environment_config env_config;
  	agent_config agnt_config;


	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    	`uvm_info(get_type_name(),"APB BASE Test 'Build Phase' Started", UVM_HIGH);
    	// Create the environment
    	apb_env = env::type_id::create("apb_env", this);
    	// Get virtual interface handle from top level
    	if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_interface", apb_intf))
      		`uvm_fatal("APB BASE TEST", "Did not get virtual interface")
       		// Pass the virtual interface to everything in environment level  
       	uvm_config_db#(virtual apb_interface)::set(this, "apb_env.apb_agnt.*", "apb_interface", apb_intf);
    	
    	env_config = environment_config::type_id::create("env_config", this);    
    	uvm_config_db#(environment_config)::set(this, "apb_env", "environ_config", env_config);
    	
    	agnt_config = agent_config::type_id::create("agnt_config", this);
    	uvm_config_db#(agent_config)::set(this, "apb_env.apb_agnt", "agent_cfg", agnt_config);
	endfunction

   
  
  	task apb_reset();
  		apb_sequence reset_seq;
  		reset_seq = apb_sequence::type_id::create("reset_seq", this);
    	reset_seq.has_reset = 1;
    	reset_seq.start(apb_env.apb_agnt.apb_seqr);
 	endtask
  
	task apb_write(input bit [31:0] address);
  		apb_sequence write_seq;
  		write_seq = apb_sequence::type_id::create("write_seq", this);
    	write_seq.has_write = 1;
  		//  $display("Write Address Received at base ========== %0d ",address );
    	write_seq.address = address;
    	write_seq.start(apb_env.apb_agnt.apb_seqr);
  	endtask
  
	task apb_read(input bit [31:0] address);
		apb_sequence read_seq;
		read_seq= apb_sequence::type_id::create("read_seq", this);
		read_seq.has_read = 1;
		read_seq.address = address;
   		// $display("Read Address Received at base ========== %0d ",address );
    	read_seq.start(apb_env.apb_agnt.apb_seqr);
	endtask
  


endclass
