`include "uvm_macros.svh"
import uvm_pkg::*;

interface i2c_m_interface(input CLK);

  // Global Signals
  logic RST; // input

  // Read-Write Registers // Outputs
  logic [7:0] MYREG0; 
  logic [7:0] MYREG1;
  logic [7:0] MYREG2;
  logic [7:0] MYREG3;
  // Read-Only Registers // Inputs
  logic [7:0] MYREG4;
  logic [7:0] MYREG5;
  logic [7:0] MYREG6;
  logic [7:0] MYREG7;


  // Serial Interface
  wire SDA; // inout : Serial Data
  wire SCL; // input : Serial Clock

  // Intermediate variable to drive I2C bus 
  reg SCL_OUT;
  reg SDA_OUT;
  reg SCL_RELEASE;
  reg SDA_RELEASE;
  
  // Open Drain Connection
  // if the bus is released : let it be open ckt
  // if the bus is not released : drive according to SCL_OUT/SDA_OUT
  assign SCL = (SCL_RELEASE == 0) ? SCL_OUT : 1'bz;
  assign SDA = (SDA_RELEASE == 0) ? SDA_OUT : 1'bz;
  
  // Additional Signal for Driver-Monitor Sync
  bit rw_ctrl;

//  // Clock Frequency Measurements
//  real t0;
//  real sclk_period, sclk_freq;
//  always @(CLK) begin
//    if(CLK == 1) begin
//      t0 = $realtime;
//    end
//    else if(CLK == 0) begin
//      sclk_period = ($realtime - t0)*2.0;
//      sclk_period = sclk_period*1e-9;
//      t0 = 0;
//      sclk_freq = (1.0/sclk_period);
//      $display("@[%0t] sclk_period = %0e || sclk_frequency = %0e", $time, sclk_period, sclk_freq);
//    end		
//  end


endinterface
