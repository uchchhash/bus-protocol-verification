// Include macros & Import packages
`include "uvm_macros.svh"
import uvm_pkg::*;
import i2c_m_test_pkg::*;

module tb_top;

  // Global Clock Generation
  bit CLK;
  initial forever #((1e9)/(2*`CLK_FREQ*1e6)) CLK = ~CLK;

  // I2C Serial Clock Generation (Standard-Mode 100KHz)
 // bit SCL;
 // initial forever #(5000) SCL = ~SCL;

  // Take Interface Instnce and send the clocks
  i2c_m_interface i2c_vif(CLK);

  // DUT Connection
  i2cSlaveTop DUT ( // Global Signals
                   .clk    (i2c_vif.CLK),
                   .rst    (i2c_vif.RST),
                    // Serial Interface
                   .sda    (i2c_vif.SDA),
                   .scl    (i2c_vif.SCL),
                    // Register Interface
                   .myReg0 (i2c_vif.MYREG0),
                   .myReg1 (i2c_vif.MYREG1),
                   .myReg2 (i2c_vif.MYREG2),
                   .myReg3 (i2c_vif.MYREG3),
                   .myReg4 (i2c_vif.MYREG4),
                   .myReg5 (i2c_vif.MYREG5),
                   .myReg6 (i2c_vif.MYREG6),
                   .myReg7 (i2c_vif.MYREG7)  
                   );
  

  // I2C Bus lines pulled up to VDD  
  pullup(i2c_vif.SCL);
  pullup(i2c_vif.SDA);

  // Send the virtual interface to Agent
  initial begin
     uvm_config_db#(virtual i2c_m_interface)::set(null, "uvm_test_top.env.i2c_m_agnt", "i2c_m_interface", i2c_vif);
     run_test();
  end 
  

endmodule


