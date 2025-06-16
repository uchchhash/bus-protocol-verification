
class axi_predictor extends uvm_component;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_component_utils(axi_predictor)

  // -------------------------------- //
  // ------ Component Members  ------ //
  // -------------------------------- //
  axi_sequence_item axi_item, aw_item, w_item;
  uvm_tlm_analysis_fifo #(axi_sequence_item) mntr2pred_fifo;      // Monitor to Predictor
  uvm_analysis_port #(axi_sequence_item) analysis_port_pred2scb;  // Monitor to Predictor

  // -------------------------------- //
  // -------- Data Members  --------- //
  // -------------------------------- //
  // index_type axi_mem value_type;
  //bit [31:0] axi_mem [0:4095]; 
  bit [31:0] axi_mem [int] = '{default: 32'b0}; // Associative array with DATA as value, ADDR as index
  
  
  mailbox #(logic [ BID_WIDTH-1:0])  b_tags_mb;  // List (mailbox) of write-response tags that needs to be received
  mailbox #(logic [ARID_WIDTH-1:0]) ar_tags_mb;  // List (mailbox) of read-address tags that needs to be send 

  axi_sequence_item aw_outstanding[MAX_OUTSTANDING][$];  // List of AW-channel outstandings
  axi_sequence_item  w_outstanding[MAX_OUTSTANDING][$];  // List of  W-channel outstandings
  axi_sequence_item  b_outstanding[MAX_OUTSTANDING][$];  // List of  W-channel outstandings
  axi_sequence_item ar_outstanding[MAX_OUTSTANDING][$];  // List of AR-channel outstandings

  logic [AWID_WIDTH-1:0] awid_tag; // Store the AWID
  logic [ BID_WIDTH-1:0]  bid_tag; // Store the  BID 
  logic [ARID_WIDTH-1:0] arid_tag; // Store the ARID
  
  // Nth Address Calculation
  bit [ADDR_WIDTH-1:0] addr, addr_n, start_addr, aligned_addr;
  bit [ADDR_WIDTH-1:0] awaddr_queue [$], araddr_queue [$], nth_addr_queue [$];
  bit [3:0] len;
  bit [3:0] size;
  bit [1:0] burst;
  int burst_length, number_bytes;
  int N, temp_val1, temp_val2, temp_val3, temp_val4;
  int wrap_boundary, wrap_limit, wrap_iter;
  bit has_wrapped;
  
  // STROBE Calculation & Filter
  bit [STRB_WIDTH-1:0] generated_strb, provided_strb, filtered_strb;
  bit [STRB_WIDTH-1:0] strb_queue [$], wstrb_queue [$], rstrb_queue [$], effective_strb_queue [$];
  int data_bus_bytes;
  int lower_byte_lane, upper_byte_lane;  
  int lower_index, upper_index;
  // DATA Filter
  bit [DATA_WIDTH-1:0] provided_data;
  bit [DATA_WIDTH-1:0] filtered_data;

  // ------------------------------------ //
  // ----- Methods of AXI predictor ----- //
  // ------------------------------------ //
  extern function new(string name = "axi_predictor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task get_aw_signals(axi_sequence_item axi_item);
  extern task get_w_signals(axi_sequence_item axi_item);
  extern task get_b_signals(axi_sequence_item axi_item);
  extern task get_ar_signals(axi_sequence_item axi_item);
  extern task write_to_mem;
  extern task read_from_mem;

  extern function void calc_nth_addr(input bit [ADDR_WIDTH-1:0] addr, input bit [3:0] len, input bit [3:0] size, input bit [1:0] burst, output bit [ADDR_WIDTH-1:0] nth_addr_queue [$]);
  extern function void calc_strb    (input bit [ADDR_WIDTH-1:0] addr, input bit [3:0] len, input bit [3:0] size, input bit [1:0] burst, input bit [ADDR_WIDTH-1:0] nth_addr_queue [$], output bit [STRB_WIDTH-1:0] strb_queue [$]);
  extern function void filter_strb  (input bit [STRB_WIDTH-1:0] generated_strb, input bit [STRB_WIDTH-1:0] provided_strb, output bit [STRB_WIDTH-1:0] filtered_strb);
  extern function void filter_data  (input bit [STRB_WIDTH-1:0] strb, input bit [DATA_WIDTH-1:0] provided_data, output bit [DATA_WIDTH-1:0] filtered_data);

endclass : axi_predictor


// -------------------------------- //
// ----- Constructor Function ----- //
// -------------------------------- //

function axi_predictor::new(string name = "axi_predictor", uvm_component parent = null);
  super.new(name, parent);
  `uvm_info(get_type_name(), "***** AXI Predictor Constructed *****", UVM_NONE);
endfunction

// -------------------------------- //
// --------- Build Phase ---------- //
// -------------------------------- //
function void axi_predictor::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "***** AXI Predictor : Inside Build Phase *****", UVM_NONE);
  mntr2pred_fifo = new("mntr2pred_fifo", this);
  analysis_port_pred2scb  = new("analysis_port_pred2scb", this);  
  b_tags_mb  = new();	
  ar_tags_mb = new();
endfunction


task axi_predictor::run_phase(uvm_phase phase);
  super.run_phase(phase);
    forever begin
      mntr2pred_fifo.get(axi_item);
      if(axi_item.awvalid && axi_item.awready) 	    get_aw_signals(axi_item);
      else if(axi_item.wvalid && axi_item.wready)   get_w_signals(axi_item);
      else if(axi_item.bvalid && axi_item.bready)   get_b_signals(axi_item);
      else if(axi_item.arvalid && axi_item.arready) get_ar_signals(axi_item);

      fork 
      	write_to_mem;
      	read_from_mem;
      join_none

  end
endtask


// --------------------------- Get AW Channel Signals --------------------------- //
// ----- Receive the AW Channel Signals when AWVALID/AWREADY Handshake Occurs
// ----- Store it to Outstanding array with AWID as index 
// ------------------------------------------------------------------------------ //

task axi_predictor::get_aw_signals(axi_sequence_item axi_item);
  //`uvm_info(get_type_name(), $sformatf("[AW] AWID = %0d || AWADDR = %0d", axi_item.awid, axi_item.awaddr), UVM_HIGH) 
  aw_outstanding[axi_item.awid].push_back(axi_item);
  awid_tag = axi_item.awid;
endtask


// --------------------------- Get W Channel Signals --------------------------- //
// ----- Receive the W Channel Signals when WVALID/WREADY Handshake Occurs
// ----- Store it to Outstanding array with WID as index 
// ----------------------------------------------------------------------------- //

task axi_predictor::get_w_signals(axi_sequence_item axi_item);
  //`uvm_info(get_type_name(), $sformatf("[ W] WDATA = %0h || WSTRB = %4b ",  axi_item.wdata, axi_item.wstrb), UVM_HIGH)
  w_outstanding[awid_tag].push_back(axi_item);
endtask


// --------------------------- Get B Channel Signals --------------------------- //
// ----- Receive the B Channel Signals when BVALID/BREADY Handshake Occurs
// ----- Store it to Outstanding array with BID as index 
// ----- Put the BID-tag into Mailbox
// ----------------------------------------------------------------------------- //

task axi_predictor::get_b_signals(axi_sequence_item axi_item);
  //`uvm_info(get_type_name(), $sformatf("[ B] BID = %0d || BRESP = %0d", axi_item.bid, axi_item.bresp), UVM_HIGH)
  b_outstanding[axi_item.bid].push_back(axi_item);
  b_tags_mb.put(axi_item.bid);
endtask


// --------------------------- Get AR Channel Signals --------------------------- //
// ----- Receive the AR Channel Signals when ARVALID/ARREADY Handshake Occurs
// ----- Store it to Outstanding array with ARID as index 
// ----------------------------------------------------------------------------- //

task axi_predictor::get_ar_signals(axi_sequence_item axi_item);
  //`uvm_info(get_type_name(), $sformatf("[AR] ARID = %0d || ARADDR = %0d", axi_item.arid, axi_item.araddr), UVM_HIGH)
  ar_outstanding[axi_item.arid].push_back(axi_item);
  ar_tags_mb.put(axi_item.arid);
endtask


task axi_predictor::write_to_mem;
  // Get BID from mailbox (Write Response completed)
  b_tags_mb.get(bid_tag);

  // Extract AW item for this BID
  axi_item = aw_outstanding[bid_tag].pop_front();
  if (axi_item == null) `uvm_fatal(get_type_name(), "********** No AW-outstanding Item Found **********");

  // Prepare address and strobe vectors
  calc_nth_addr(axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst, awaddr_queue);
  calc_strb    (axi_item.awaddr, axi_item.awlen, axi_item.awsize, axi_item.awburst, awaddr_queue, wstrb_queue);

  // Summary Log Header
  `uvm_info(get_type_name(), "===========================================================================================================", UVM_HIGH)
  `uvm_info(get_type_name(), $sformatf("[Initiating Write Transfer] :: AWID = %0d || AWADDR = %0d || AWLEN = %0d || AWSIZE = %s || AWBURST = %s",
    axi_item.awid, axi_item.awaddr, axi_item.awlen,
    (axi_item.awsize == BYTE_1) ? "BYTE_1" : (axi_item.awsize == BYTE_2) ? "BYTE_2" : "BYTE_4",
    (axi_item.awburst == INCR) ? "INCR" : (axi_item.awburst == WRAP) ? "WRAP" : "FIXED"), UVM_HIGH)
  `uvm_info(get_type_name(), "===========================================================================================================", UVM_HIGH)

  for (int i = 0; i <= axi_item.awlen; i++) begin
    // Get write item
    w_item = w_outstanding[bid_tag].pop_front();
    if (w_item == null) `uvm_fatal(get_type_name(), "********** No W-outstanding Item Found **********");

    // Filter STRB and DATA
    filter_strb(wstrb_queue.pop_front(), w_item.wstrb, filtered_strb);
    filter_data(filtered_strb, w_item.wdata, filtered_data);

    // Update target address
    axi_item.awaddr = awaddr_queue.pop_front();

    // Write to memory based on size
    case (axi_item.awsize)
      BYTE_1: begin
        axi_mem[axi_item.awaddr] = filtered_data[7:0];
        `uvm_info(get_type_name(), $sformatf("[BYTE-1][Mem-Write] axi_mem[%0d] = %0h", axi_item.awaddr, axi_mem[axi_item.awaddr]), UVM_HIGH)
      end
      BYTE_2: begin
        axi_mem[axi_item.awaddr]     = filtered_data[7:0];
        axi_mem[axi_item.awaddr + 1] = filtered_data[15:8];
        `uvm_info(get_type_name(), $sformatf("[BYTE-2][Mem-Write] axi_mem[%0d:%0d] = %0h", axi_item.awaddr, axi_item.awaddr+1, filtered_data[15:0]), UVM_HIGH)
      end
      BYTE_4: begin
        axi_mem[axi_item.awaddr]     = filtered_data[7:0];
        axi_mem[axi_item.awaddr + 1] = filtered_data[15:8];
        axi_mem[axi_item.awaddr + 2] = filtered_data[23:16];
        axi_mem[axi_item.awaddr + 3] = filtered_data[31:24];
        `uvm_info(get_type_name(), $sformatf("[BYTE-4][Mem-Write] axi_mem[%0d:%0d] = %0h", axi_item.awaddr, axi_item.awaddr+3, filtered_data[31:0]), UVM_HIGH)
      end
    endcase
  end
endtask

    
task axi_predictor::read_from_mem;
  // Get ARID from mailbox (Read Address processed)
  ar_tags_mb.get(arid_tag);

  // Extract AR item
  axi_item = ar_outstanding[arid_tag].pop_front();
  if (axi_item == null) `uvm_fatal(get_type_name(), "********** No AR-outstanding Item Found **********");

  // Calculate read addresses
  calc_nth_addr(axi_item.araddr, axi_item.arlen, axi_item.arsize, axi_item.arburst, araddr_queue);

  for (int i = 0; i <= axi_item.arlen; i++) begin
    axi_item.awaddr = araddr_queue.pop_front();

    // Read memory based on size
    case (axi_item.arsize)
      BYTE_1: begin
        axi_item.wdata[7:0]  = axi_mem[axi_item.awaddr];
        axi_item.wdata[31:8] = '0;
        `uvm_info(get_type_name(), $sformatf("[BYTE-1][Mem-READ] axi_mem[%0d] = %0h", axi_item.awaddr, axi_item.wdata[7:0]), UVM_HIGH)
      end
      BYTE_2: begin
        axi_item.wdata[7:0]   = axi_mem[axi_item.awaddr];
        axi_item.wdata[15:8]  = axi_mem[axi_item.awaddr + 1];
        axi_item.wdata[31:16] = '0;
        `uvm_info(get_type_name(), $sformatf("[BYTE-2][Mem-READ] axi_mem[%0d:%0d] = %0h", axi_item.awaddr, axi_item.awaddr+1, axi_item.wdata[15:0]), UVM_HIGH)
      end
      BYTE_4: begin
        axi_item.wdata[7:0]   = axi_mem[axi_item.awaddr];
        axi_item.wdata[15:8]  = axi_mem[axi_item.awaddr + 1];
        axi_item.wdata[23:16] = axi_mem[axi_item.awaddr + 2];
        axi_item.wdata[31:24] = axi_mem[axi_item.awaddr + 3];
        `uvm_info(get_type_name(), $sformatf("[BYTE-4][Mem-READ] axi_mem[%0d:%0d] = %0h", axi_item.awaddr, axi_item.awaddr+3, axi_item.wdata[31:0]), UVM_HIGH)
      end
    endcase

    // Forward to scoreboard
    analysis_port_pred2scb.write(axi_item);
  end
endtask


// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- //
// --------------------------------------------------------------------------- Helper Methods --------------------------------------------------------------------------- //
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- //


//--------------------------------------- Calculate Aligned Address ----------------------------------------------------------- //
// ***** Aligned_Address = (INT(Start_Address / Number_Bytes) ) × Number_Bytes.
// ***** Inputs : awaddr : start_address 
// ***** Inputs : awsize : calculate number of bytes per transfer (2**awsize)
// --------------------------------------- Calculate Nth Addresses ------------------------------------------------------------- //
// ***** Calculate the Nth addresses : each address per transfer 
// ***** Address_N :: (Address of the Nth Transfer) :: N = transfer number
// ***** For FIXED Transfer =======================>>
// ***** address is same for each transfer :: Address_N :: Start_Address 
// ***** For INCR Transfer ========================>>
// ***** address increases :: Address_N = Aligned_Address + (N - 1) × Number_Bytes
// ***** For WRAP Transfer ========================>>
// ***** Wrap_Boundary = (INT(Start_Address / (Number_Bytes × Burst_Length))) × (Number_Bytes × Burst_Length)
// ***** Burst_Length = AxLEN + 1
// ***** Wrap_Limit =  Wrap_Boundary + (Number_Bytes × Burst_Length)
// ***** if WRAPPED :: (if Address_N = Wrap_Limit)
// ***** for the current transfer: Address_N = Wrap_Boundary
// ***** for any subsequent transfers: Address_N = Start_Address + ((N - 1) × Number_Bytes) - (Number_Bytes × Burst_Length)
// ***** if NOT WRAPPED :: Address_N = Aligned_Address + (N - 1) × Number_Bytes
// ***** Inputs :: awaddr, awsize, awlen, awburst, aligned_addr
// ---------------------------------------------------------------------------------------------------------------------------- //

function void axi_predictor::calc_nth_addr(
  input  bit [ADDR_WIDTH-1:0] addr,
  input  bit [3:0] len,
  input  bit [3:0] size,
  input  bit [1:0] burst,
  output bit [ADDR_WIDTH-1:0] nth_addr_queue[$]
);
  start_addr     = addr;
  burst_length   = len + 1;
  number_bytes   = 2 ** size;

  aligned_addr   = (start_addr / number_bytes) * number_bytes;
  wrap_boundary  = (start_addr / (number_bytes * burst_length)) * (number_bytes * burst_length);
  wrap_limit     = wrap_boundary + (number_bytes * burst_length);

  has_wrapped    = 0;
  wrap_iter      = 0;

  for (int i = 0; i < burst_length; i++) begin
    N = i + 1;
    case (burst)
      FIXED: addr_n = start_addr;
      INCR : addr_n = aligned_addr + (N - 1) * number_bytes;
      WRAP : begin
        addr_n = aligned_addr + (N - 1) * number_bytes;
        if (addr_n == wrap_limit || has_wrapped) begin
          addr_n = (wrap_iter == 0) ? wrap_boundary
                                    : start_addr + ((N - 1) * number_bytes) - (number_bytes * burst_length);
          has_wrapped = 1;
          wrap_iter++;
        end
      end
      default: addr_n = start_addr;
    endcase
    nth_addr_queue.push_back(addr_n);
  end
endfunction



// --------------------------------------- Calculate Active Byte Lanes ------------------------------------------------- //
// ***** For the Fisrt Transfer:
// ----- Lower_Byte_Lane = Start_Address-(INT(Start_Address/Data_Bus_Bytes))*Data_Bus_Bytes
// ----- Upper_Byte_Lane = Aligned_Address + (Number_Bytes -1)-(INT(Start_Address/Data_Bus_Bytes))*Data_Bus_Bytes
// ***** For the Rest of the Transfer:
// ----- Lower_Byte_Lane = Address_N - (INT(Address_N/Data_Bus_Bytes))*Data_Bus_Bytes
// ----- Upper_Byte_Lane = Lower_Byte_Lane + Number_Bytes -1
// --------------------------------------- Calculate Write STROBE ------------------------------------------------------ //
// ***** WSTRB[n] corresponds to WDATA[(8n)+7:(8n)] :: WDATA[(8*UBL)+7:(8*LBL)]
// ***** LBL : Lower Byte Lane ; UBL : Upper Byte Lane
// --------------------------------------------------------------------------------------------------------------------- //

function void axi_predictor::calc_strb(
  input  bit [ADDR_WIDTH-1:0] addr,
  input  bit [3:0] len,
  input  bit [3:0] size,
  input  bit [1:0] burst,
  input  bit [ADDR_WIDTH-1:0] nth_addr_queue[$],
  output bit [STRB_WIDTH-1:0] strb_queue[$]
);
  start_addr      = addr;
  data_bus_bytes  = BUS_WIDTH;
  number_bytes    = 2 ** size;
  burst_length    = len + 1;
  aligned_addr    = (start_addr / number_bytes) * number_bytes;

  for (int i = 0; i < burst_length; i++) begin
    addr_n = nth_addr_queue.pop_front();
    int bus_index = (i == 0 || burst == FIXED) ? (start_addr / data_bus_bytes)
                                               : (addr_n / data_bus_bytes);

    lower_byte_lane = (i == 0 || burst == FIXED)
                      ? start_addr - (bus_index * data_bus_bytes)
                      : addr_n     - (bus_index * data_bus_bytes);
    upper_byte_lane = lower_byte_lane + number_bytes - 1;

    generated_strb = '0;
    for (int b = lower_byte_lane; b <= upper_byte_lane; b++)
      generated_strb[b] = 1;

    strb_queue.push_back(generated_strb);
  end
endfunction



// --------------------------------------- Filter Write STROBE ------------------------------------------------- //
// ********** Filter the Input WSTRB with expected WSTRB 
// ********** Determine the actual WSTRB to be driven 
// ********** Bitwise AND Operation of Generated (Actual) WSTRB and provided WSTRB from sequence
// ---------------------------------------------------------------------------------------------------------------- //

function void axi_predictor::filter_strb(
  input  bit [STRB_WIDTH-1:0] generated_strb,
  input  bit [STRB_WIDTH-1:0] provided_strb,
  output bit [STRB_WIDTH-1:0] filtered_strb
);
  filtered_strb = generated_strb & provided_strb;
endfunction



// ----------------------------------------------------------------------------------------------------------------- //
// --------------------------------------- Filter the WDATA/RDATA -------------------------------------------------- //
// ----------------------------------------------------------------------------------------------------------------- //

function void axi_predictor::filter_data(
  input  bit [STRB_WIDTH-1:0] strb,
  input  bit [DATA_WIDTH-1:0] provided_data,
  output bit [DATA_WIDTH-1:0] filtered_data
);
  filtered_data = 32'b0;
  for (int i = 0; i < STRB_WIDTH; i++) begin
    if (strb[i])
      filtered_data[i*8 +: 8] = provided_data[i*8 +: 8];
  end
endfunction



