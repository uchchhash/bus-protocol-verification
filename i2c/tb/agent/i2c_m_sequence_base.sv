

class i2c_m_sequence_base #(type T = int) extends uvm_sequence#(T);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_param_utils(i2c_m_sequence_base#(T))

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  i2c_m_sequence_item i2c_item;

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // Additional items for data & address 
  byte i2c_data;    
  bit [31:0] data_bytes;


  // Flags to Control the Test Flow
  bit assert_reset;
  bit assert_write;
  bit assert_read;
  bit assert_restart;
  bit re_start;
  bit rw_ctrl;
  int num_writes;
  int num_reads;
  bit ro_test;

  // Additional items for data & address 
  bit [31:0] write_data;
  bit [7:0]  reg_addr;
  
  // Flags for randomization
  bit rand_data;
  bit rand_addr;
  bit rand_num;
  bit rand_type;

  // ---------------------------------------------- //
  // ----- Methods of I2C Slave Base Sequence ----- //
  // ---------------------------------------------- //
  extern function new(string name = "i2c_m_sequence_base");	
  extern task body;
  
endclass


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_sequence_base::new(string name = "i2c_m_sequence_base");
  super.new(name);
 // `uvm_info(get_type_name(), "***** I2C Slave Base Sequence : Constructed *****", UVM_NONE);	
endfunction	


// -------------------------------- //
// ----- Sequence : Body Task ----- //
// -------------------------------- //
task i2c_m_sequence_base::body();
  `uvm_info(get_type_name(), "***** I2C Slave Base Sequence : Body Task Started  *****", UVM_MEDIUM);
  `uvm_info(get_type_name(), "***** I2C Slave Base Sequence : Body Task Finished *****", UVM_MEDIUM);		
endtask	



