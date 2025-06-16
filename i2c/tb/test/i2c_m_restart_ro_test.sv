


class i2c_m_restart_ro_test extends i2c_m_base_test;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(i2c_m_restart_ro_test)

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // Data & Address
  int num_reads = 4;
  bit [7:0] reg_addr = 4;


  // -------------------------------- //
  // ----- Methods of Register_Write_Read Test ---- //
  // -------------------------------- //
  extern function new(string name = "i2c_m_restart_ro_test", uvm_component parent = null);	
  extern task run_phase(uvm_phase phase);

endclass : i2c_m_restart_ro_test


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function i2c_m_restart_ro_test::new(string name = "i2c_m_restart_ro_test", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** I2C RW Register Sigle Write-Read Test Constructed *****", UVM_NONE);	
endfunction


// -------------------------------- //
// ---------- Run Phase ----------- //
// -------------------------------- //

task i2c_m_restart_ro_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info(get_type_name(), "***** I2C RW Register Single Write-Read Test : Run Phase Started  *****", UVM_MEDIUM);	
 
  run_i2c_reset_sequence();
  repeat(100) begin
    run_i2c_ro_sequence(.num_reads(num_reads), .rand_num(1), .reg_addr(reg_addr), .rand_addr(1), .assert_restart(1), .rand_type(0));
  end

  `uvm_info(get_type_name(), "***** I2C RW Register Single Write-Read Test : Run Phase Finished *****", UVM_MEDIUM);	
  phase.drop_objection(this);
endtask

