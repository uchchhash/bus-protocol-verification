

class axi_coverage extends uvm_subscriber #(axi_sequence_item);

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- // 
  `uvm_component_utils(axi_coverage)

  // ------------------------------------- //
  // ------ Data/Component Members  ------ //
  // ------------------------------------- //
  
  // ------------------------------------------- //
  // -------------- Cover Groups --------------- //
  // ------------------------------------------- //

	covergroup axi_cov with function sample(axi_sequence_item t);
		option.per_instance = 1;
		// ------------------------------------------------- //
		// --------------- Handshake Signals --------------- //
		// ------------------------------------------------- //
    AWREADY_cp : coverpoint t.awready {bins AWREADY_high  = {1'b1};
                                       bins AWREADY_low   = {1'b0};}
    AWVALID_cp : coverpoint t.awvalid {bins AWVALID_high  = {1'b1};
                                       bins AWVALID_low   = {1'b0};}
    WREADY_cp  : coverpoint t.wready  {bins WREADY_high   = {1'b1};
                                       bins WREADY_low    = {1'b0};}
    WVALID_cp  : coverpoint t.wvalid  {bins WVALID_high   = {1'b1};
                                       bins WVALID_low    = {1'b0};}
    BREADY_cp  : coverpoint t.bready  {bins BREADY_high   = {1'b1};
                                       bins BREADY_low    = {1'b0};}
    BVALID_cp  : coverpoint t.bvalid  {bins BVALID_high   = {1'b1};
                                       bins BVALID_low    = {1'b0};}
    ARREADY_cp : coverpoint t.arready {bins ARREADY_high  = {1'b1};
                                       bins ARREADY_low   = {1'b0};}
    ARVALID_cp : coverpoint t.arvalid {bins ARVALID_high  = {1'b1};
                                       bins ARVALID_low   = {1'b0};}
    RREADY_cp  : coverpoint t.rready  {bins RREADY_high   = {1'b1};
                                       bins RREADY_low    = {1'b0};}
    RVALID_cp  : coverpoint t.rvalid  {bins RVALID_high   = {1'b1};
                                       bins RVALID_low    = {1'b0};}
		// ------------------------------------------------- //
		// ------------- Write-Address Signals ------------- //
		// ------------------------------------------------- //
    AWID_cp    : coverpoint t.awid    {bins range [16]    = {[0:15]};}
    AWADDR_cp  : coverpoint t.awaddr  {bins range [10]    = {[0:$]};}
    AWLEN_cp   : coverpoint t.awlen   {bins range [16]    = {[0:15]};}
    AWSIZE_cp  : coverpoint t.awsize  {bins AWSIZE_b1     = {BYTE_1};
                                       bins AWSIZE_b2     = {BYTE_2};
                                       bins AWSIZE_b4     = {BYTE_4};}
    AWBURST_cp : coverpoint t.awburst {bins AWBURST_fixed = {FIXED};
                                       bins AWBURST_incr  = {INCR};
                                       bins AWBURST_wrap  = {WRAP};}

		// ------------------------------------------------- //
		// -------------- Write-Data Signals --------------- //
		// ------------------------------------------------- //
    WDATA_cp  : coverpoint t.wdata  {bins range [10]  = {[0:$]};}
    WSTRB_cp  : coverpoint t.wstrb  {bins range [16]  = {[0:15]};}
		// ------------------------------------------------- //
		// ------------ Write-Response Signals ------------- //
		// ------------------------------------------------- //
    BRESP_cp  : coverpoint t.bresp  {bins BRESP_okay   = {OKAY};
                                     bins BRESP_exokay = {EXOKAY};
                                     bins BRESP_slverr = {SLVERR};
                                     bins BRESP_decerr = {DECERR};}
		// ------------------------------------------------- //
		// ------------- Read-Address Signals -------------- //
		// ------------------------------------------------- //
    ARID_cp    : coverpoint t.arid    {bins range [16]    = {[0:15]};}
    ARADDR_cp  : coverpoint t.araddr  {bins range [10]    = {[0:$]};}
    ARLEN_cp   : coverpoint t.arlen   {bins range [16]    = {[0:15]};}
    ARSIZE_cp  : coverpoint t.arsize  {bins ARSIZE_b1     = {BYTE_1};
                                       bins ARSIZE_b2     = {BYTE_2};
                                       bins ARSIZE_b4     = {BYTE_4};}
    ARBURST_cp : coverpoint t.arburst {bins ARBURST_fixed = {FIXED};
                                       bins ARBURST_incr  = {INCR};
                                       bins ARBURST_wrap  = {WRAP};}
		// ------------------------------------------------- //
		// -------------- Read-Data Signals ---------------- //
		// ------------------------------------------------- //
    RDATA_cp  : coverpoint t.rdata  {bins range [10]   = {[0:$]};}
    RRESP_cp  : coverpoint t.rresp  {bins RRESP_okay   = {OKAY};
                                     bins RRESP_exokay = {EXOKAY};
                                     bins RRESP_slverr = {SLVERR};
                                     bins RRESP_decerr = {DECERR};}
    RLAST_cp  : coverpoint t.rlast  {bins RLAST_low    = {1'b1};
                                     bins RLAST_high   = {1'b0};}


		// ------------------------------------------------ //
		// ------------ Read-Write-Cross-Cov -------------- //
		// ------------------------------------------------ //
		


	endgroup



  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //
  
  
  function new(string name="axi_coverage", uvm_component parent= null);
    super.new(name, parent);
		axi_cov = new();
    `uvm_info(get_type_name(), "***** AXI Coverage Constructed *****", UVM_NONE);
  endfunction

  // -------------------------------- //
  // --------- Build Phase ---------- //
  // -------------------------------- //

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "***** AXI Coverage : Inside Build Phase *****", UVM_NONE);
  endfunction

  // ------------------------------------ //
  // --------- Analysis Export ---------- //
  // ------------------------------------ //

  function void write(axi_sequence_item t);
   // `uvm_info(get_type_name(), "***** AXI Coverage : Receiving Item @Analysis Export *****", UVM_NONE);
    //`uvm_info (get_type_name(), $sformatf("Got Items @COV :: %s", t.convert2string), UVM_MEDIUM) 
		axi_cov.sample(t);
  endfunction


endclass

