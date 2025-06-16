

class i2c_m_coverage extends uvm_subscriber #(i2c_m_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_component_utils(i2c_m_coverage)

  // ------------------------------------- //
  // ------ Data/Component Members  ------ //
  // ------------------------------------- //
  bit [7:0] reg_addr, dev_addr_wr, dev_addr_rd, wdata, rdata;

  // ------------------------------------------- //
  // -------------- Cover Groups --------------- //
  // ------------------------------------------- //
  covergroup i2c_m_cg with function sample(i2c_m_sequence_item t);
    option.per_instance = 1;
    REG_ADDR_CP : coverpoint t.reg_addr {bins rw_addr_range[4] = {[0:3]};
                                        bins ro_addr_range[4] = {[4:7]};}
    WDATA_CP : coverpoint t.wdata {bins wdata_range[5] = {[0:$]};}
    RDATA_CP : coverpoint t.rdata {bins rdata_range[5] = {[0:$]};}
    RO_DATA_CP : coverpoint t.rdata iff (t.ro_test) {bins ro_data4 = {8'h12};
                                                     bins ro_data5 = {8'h34};
                                                     bins ro_data6 = {8'h56};
                                                     bins ro_data7 = {8'h78};}
    DEV_ADDR_WR_CP : coverpoint t.dev_addr_wr {bins dev_addr_wr = {8'h78};}
    DEV_ADDR_RD_CP : coverpoint t.dev_addr_rd {bins dev_addr_rd = {8'h79};}
    RESTART_CP : coverpoint t.assert_restart {bins restart_low = {1'b0};
                                              bins restart_high = {1'b1};}  
    // Write-Cross
    I2C_WRITE_cross : cross REG_ADDR_CP, WDATA_CP, DEV_ADDR_WR_CP {ignore_bins REG_ADDR_ignore = binsof(REG_ADDR_CP.ro_addr_range);}
    // Read-Cross
    I2C_READ_cross  : cross REG_ADDR_CP, RDATA_CP, DEV_ADDR_WR_CP, DEV_ADDR_RD_CP, RESTART_CP {ignore_bins REG_ADDR_ignore = binsof(REG_ADDR_CP.ro_addr_range);}
    
    // Read-Only_Cross
  //  I2C_READ_ONLY_cross : cross REG_ADDR_CP, RO_DATA_CP, DEV_ADDR_WR_CP, DEV_ADDR_RD_CP, RESTART_CP {ignore_bins REG_ADDR_ignore = binsof(REG_ADDR_CP.rw_addr_range);}
    
    // Write-Read-Cross
   // I2C_WRITE_READ_cross : cross I2C_WRITE_cross, I2C_READ_cross;


  endgroup : i2c_m_cg
 


  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  
  function new(string name="i2c_m_coverage", uvm_component parent= null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "***** I2C Master Coverage Constructed *****", UVM_NONE);
    i2c_m_cg = new();    
  endfunction

  // -------------------------------- //
  // --------- Build Phase ---------- //
  // -------------------------------- //

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "***** I2C Master Coverage : Inside Build Phase *****", UVM_NONE);
  endfunction

  // ------------------------------------ //
  // --------- Analysis Export ---------- //
  // ------------------------------------ //

  function void write(i2c_m_sequence_item t);
   // `uvm_info(get_type_name(), "***** I2C Master Coverage : Receiving Item @Analysis Export *****", UVM_NONE);
    //`uvm_info (get_type_name(), $sformatf("Got Items @COV :: %s", t.convert2string), UVM_MEDIUM) 
      i2c_m_cg.sample(t);
      if(t.assert_restart) $display("========================== assert restart ===============================");
  endfunction


endclass

  





























/*



  covergroup i2c_m_cg with function sample(i2c_m_sequence_item t);
    option.per_instance = 1;
    REG_ADDR_CP : coverpoint t.reg_addr iff (t.ctrl ==0) {bins rw_addr_range[4] = {[0:3]};
                                                          bins ro_addr_range[4] = {[4:7]};}
    WDATA_CP : coverpoint t.wdata iff (t.ctrl == 0) {bins wdata_range[5] = {[0:$]};}
    RDATA_CP : coverpoint t.rdata iff (t.ctrl == 0) {bins rdata_range[5] = {[0:$]};}
    RO_DATA_CP : coverpoint t.rdata iff (t.ctrl == 0 && t.ro_test) {bins ro_data4 = {8'h12};
                                                                    bins ro_data5 = {8'h34};
                                                                    bins ro_data6 = {8'h56};
                                                                    bins ro_data7 = {8'h78};}
    DEV_ADDR_WR_CP : coverpoint t.dev_addr_wr iff(t.ctrl == 1)  {bins dev_addr_wr = {8'h78};}
    DEV_ADDR_RD_CP : coverpoint t.dev_addr_rd iff(t.ctrl == 2) {bins dev_addr_rd = {8'h79};}
    RESTART_CP : coverpoint t.assert_restart iff(t.ctrl == 0) {bins restart_low = {1'b0};
                                                               bins restart_high = {1'b1};}    
  endgroup : i2c_m_cg

*/


  //    // Write-Cross
//    I2C_WRITE_cross : cross REG_ADDR_CP, WDATA_CP, DEV_ADDR_WR_CP {ignore_bins REG_ADDR_ignore = binsof(REG_ADDR_CP.ro_addr_range);}
//    // Read-Cross
//    I2C_READ_cross : cross REG_ADDR_CP, RDATA_CP, DEV_ADDR_WR_CP, DEV_ADDR_RD_CP, RESTART_CP;
//
//    // Write-Read-Cross
//    I2C_WRITE_READ_cross : cross I2C_WRITE_cross, I2C_READ_cross;
