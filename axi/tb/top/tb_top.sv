//==================================================================//
//                         Testbench Top Module                     //
//==================================================================//

`include "uvm_macros.svh"
import uvm_pkg::*;
import axi_test_pkg::*;

module tb_top;

  // AXI Clock Generation (200 MHz by default)
  bit ACLK = 0;
  initial forever #(1e9 / (2 * ACLK_FREQ)) ACLK = ~ACLK;

  // Instantiate AXI Virtual Interface
  axi_interface axi_vif(ACLK);

  //====================== DUT Instantiation ========================//
  EgSlaveAxi DUT (
    // Global Signals
    .ACLK         (ACLK),
    .ARESETn      (axi_vif.ARESETn),

    // Write Address Channel
    .AWID         (axi_vif.AWID),
    .AWADDR       (axi_vif.AWADDR),
    .AWLEN        (axi_vif.AWLEN),
    .AWSIZE       (axi_vif.AWSIZE),
    .AWBURST      (axi_vif.AWBURST),
    .AWVALID      (axi_vif.AWVALID),
    .AWREADY      (axi_vif.AWREADY),

    // Write Data Channel
    .WDATA        (axi_vif.WDATA),
    .WSTRB        (axi_vif.WSTRB),
    .WVALID       (axi_vif.WVALID),
    .WREADY       (axi_vif.WREADY),

    // Write Response Channel
    .BID          (axi_vif.BID),
    .BRESP        (axi_vif.BRESP),
    .BVALID       (axi_vif.BVALID),
    .BREADY       (axi_vif.BREADY),

    // Read Address Channel
    .ARID         (axi_vif.ARID),
    .ARADDR       (axi_vif.ARADDR),
    .ARLEN        (axi_vif.ARLEN),
    .ARSIZE       (axi_vif.ARSIZE),
    .ARBURST      (axi_vif.ARBURST),
    .ARVALID      (axi_vif.ARVALID),
    .ARREADY      (axi_vif.ARREADY),

    // Read Data Channel
    .RID          (axi_vif.RID),
    .RDATA        (axi_vif.RDATA),
    .RRESP        (axi_vif.RRESP),
    .RLAST        (axi_vif.RLAST),
    .RVALID       (axi_vif.RVALID),
    .RREADY       (axi_vif.RREADY),

    // Low Power Interface
    .CSYSREQ      (axi_vif.CSYSREQ),
    .CSYSACK      (axi_vif.CSYSACK),
    .CACTIVE      (axi_vif.CACTIVE),

    // Scan Insertion Pins
    .SCANENABLE   (axi_vif.SCANENABLE),
    .SCANINACLK   (axi_vif.SCANINACLK),
    .SCANOUTACLK  (axi_vif.SCANOUTACLK),

    // Module-Specific Signals
    .SlaveEnum    (axi_vif.SlaveEnum)
  );

  //=================== Assertion Module Binding ===================//
  bind EgSlaveAxi axi4_assert all_inst(.*);

  //================== UVM Test Initialization =====================//
  initial begin
    uvm_config_db#(virtual axi_interface)::set(
      null,
      "uvm_test_top.env.axi_agnt",
      "axi_interface",
      axi_vif
    );
    run_test();
  end

endmodule
