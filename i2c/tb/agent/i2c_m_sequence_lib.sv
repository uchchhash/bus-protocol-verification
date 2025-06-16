

class i2c_m_reset_sequence extends i2c_m_sequence_base #(i2c_m_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(i2c_m_reset_sequence)

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  function new(string name= "i2c_m_reset_sequence");
    super.new(name);
  endfunction

  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    `uvm_info(get_type_name(), "***** I2C Master Reset Sequence : Body Task Started  *****", UVM_MEDIUM);
    `uvm_do_with(i2c_item, {i2c_item.assert_reset  == 1'b1;})
    `uvm_info(get_type_name(), "***** I2C Master Reset Sequence : Body Task Finished *****", UVM_MEDIUM);
  endtask
    
endclass


class i2c_m_write_sequence extends i2c_m_sequence_base #(i2c_m_sequence_item);


  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(i2c_m_write_sequence)

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  function new(string name = "i2c_m_write_sequence");
    super.new(name);
  endfunction

  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    //`uvm_info(get_type_name(), "***** I2C Master Write Sequence : Body Task Called *****", UVM_MEDIUM)
    // Randomize with constraints
    `uvm_do_with(i2c_item, {i2c_item.assert_reset   == 0;
                            i2c_item.assert_write   == 1;
                            i2c_item.assert_read    == 0;
                            (local::rand_num  == 0) -> i2c_item.num_writes     == local::num_writes;
                            (local::rand_addr == 0) -> i2c_item.reg_addr       == local::reg_addr;                            
                            (local::rand_data == 0) -> i2c_item.write_data     == local::write_data;
                            })
    //`uvm_info(get_type_name(), "***** I2C Master Write Sequence : Body Task Finished *****", UVM_MEDIUM)
  endtask

endclass



class i2c_m_read_sequence extends i2c_m_sequence_base #(i2c_m_sequence_item);


  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_object_utils(i2c_m_read_sequence)

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  function new(string name = "i2c_m_read_sequence");
    super.new(name);
  endfunction

  // -------------------------------- //
  // ----- Sequence : Body Task ----- //
  // -------------------------------- //
  task body();
    //`uvm_info(get_type_name(), "***** I2C Master Read Sequence : Body Task Called *****", UVM_MEDIUM)
    
    // Randomize with constraints    
    `uvm_do_with(i2c_item, {i2c_item.assert_reset   == 0;
                            i2c_item.assert_write   == 0;
                            i2c_item.assert_read    == 1;
                            i2c_item.ro_test        == local::ro_test;
                            (local::rand_type == 0) -> i2c_item.assert_restart == local::assert_restart;
                            (local::rand_num  == 0) -> i2c_item.num_reads      == local::num_reads;
                            (local::rand_addr == 0) -> i2c_item.reg_addr       == local::reg_addr;
                            })
    //`uvm_info(get_type_name(), "***** I2C Master Read Sequence : Body Task Finished *****", UVM_MEDIUM)
  endtask

endclass

