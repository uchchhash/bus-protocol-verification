


class i2c_m_sequence_item extends uvm_sequence_item;

  // -------------------------------- //
  // ----- Factory Registration ----- //
  // -------------------------------- //
  `uvm_object_utils(i2c_m_sequence_item)

  // -------------------------------- //
  // ----- Constructor Function ----- //
  // -------------------------------- //    
  function new(string name= "i2c_m_sequence_item");
    super.new(name);
  endfunction

  // Global Signals
  rand logic RST; // input

  // Serial Interface
  rand logic SDA; // inout : Serial Data
  rand logic SCL; // input : Serial Clock

  // Read-Write Registers // Outputs
  logic [7:0] MYREG0; 
  logic [7:0] MYREG1;
  logic [7:0] MYREG2;
  logic [7:0] MYREG3;

  // Read-Only Registers // Inputs
  rand logic [7:0] MYREG4;
  rand logic [7:0] MYREG5;
  rand logic [7:0] MYREG6;
  rand logic [7:0] MYREG7;

 
  // Additional items for data & address 
  rand byte i2c_data;    
  rand logic [31:0] data_bytes;

  logic [31:0] rdata_bytes;
  logic [7:0] wdata, rdata;

  rand logic re_start;
  rand logic rw_ctrl;


  // Exteral Control Signal 
  // Control Monitor-SCB-COV sync
  int ctrl;
  // if ctrl == 0 // write-read-data
  // if ctrl == 1 // addrdev_addr_wr
  // if ctrl == 2 // dev_addr_rd


  // Flags to Control the Test Flow
  rand logic assert_reset;
  rand logic assert_write;
  rand logic assert_read;
  rand logic assert_restart;
  rand int num_writes;
  rand int num_reads;
  rand logic ro_test;

  // Additional items for data & address 
  logic [63:0] read_data;  
  rand logic [31:0] write_data;
  rand logic [7:0]  dev_addr_wr;
  rand logic [7:0]  dev_addr_rd;
  rand logic [7:0]  reg_addr;
  
  // Flags for randomization
  rand logic rand_data;
  rand logic rand_addr;
  rand logic rand_num;
  rand logic rand_type;

  // Constraints
 // constraint reg_addr_constraint    { reg_addr    inside {[0:7]};}  
  constraint dev_addr_wr_constraint { dev_addr_wr inside {8'h78};}
  constraint dev_addr_rd_constraint { dev_addr_rd inside {8'h79};}
  constraint num_writes_constraint  { num_writes  inside {[1:4]};}
  constraint num_reads_constraint   { num_reads   inside {[1:8]};}
  
  constraint reg_addr_constraint { (assert_write) -> reg_addr inside {[0:3]};
                                   (assert_read)  -> reg_addr inside {[0:7]};
                                 }

  constraint wreg_addr_constraint { (num_writes == 1) -> reg_addr inside {[0:3]};
                                    (num_writes == 2) -> reg_addr inside {[0:2]};
                                    (num_writes == 3) -> reg_addr inside {[0:1]};
                                    (num_writes == 4) -> reg_addr inside {[0:0]};
                                 }
  constraint rreg_addr_constraint { (num_reads == 1) -> reg_addr inside {[0:7]};
                                    (num_reads == 2) -> reg_addr inside {[0:6]};
                                    (num_reads == 3) -> reg_addr inside {[0:5]};
                                    (num_reads == 4) -> reg_addr inside {[0:4]};
                                    (num_reads == 5) -> reg_addr inside {[0:3]};
                                    (num_reads == 6) -> reg_addr inside {[0:2]};
                                    (num_reads == 7) -> reg_addr inside {[0:1]};
                                    (num_reads == 8) -> reg_addr inside {[0:0]};                                    
                                 }





  // this is my two rand variables
  // reg_addr should be inside 0 to 7
  //constraint reg_addr_constraint    { reg_addr    inside {[0:7]};}

 // constraint num_writes

  // number of writes should depend on reg_addr like this :
  // if reg_addr = n // num_writes should be :
  // reg_addr = 0 // num_writes = max(8)
  // reg_addr = 1 // num_writes = max(7)
  // reg_addr = 2 // num_writes = max(6) 
  // reg_addr = 3 // num_writes = max(5)  
  // reg_addr = 4 // num_writes = max(4) 
  // reg_addr = 5 // num_writes = max(3)  
  // reg_addr = 6 // num_writes = max(2) 
  // reg_addr = 7 // num_writes = max(1)   


function string convert2string();
  string string_item;
  string_item = super.convert2string();
  $sformat(string_item, "%s\n =============================================", string_item);  
  $sformat(string_item, "%s\n || control-sig            = [%0d] ", string_item, ctrl);  
  $sformat(string_item, "%s\n || assert_reset           = [%0d] ", string_item, assert_reset);
  $sformat(string_item, "%s\n || assert_write           = [%0d] ", string_item, assert_write);
  $sformat(string_item, "%s\n || assert_read            = [%0d] ", string_item, assert_read);
  $sformat(string_item, "%s\n || assert_restart         = [%0d] ", string_item, assert_restart);
  $sformat(string_item, "%s\n || read only test         = [%0d] ", string_item, ro_test);  
  $sformat(string_item, "%s\n || number_of_writes       = [%0d] ", string_item, num_writes);
  $sformat(string_item, "%s\n || number_of_reads        = [%0d] ", string_item, num_reads);
  $sformat(string_item, "%s\n || rand_data              = [%0d] ", string_item, num_reads);
  $sformat(string_item, "%s\n || rand_addr              = [%0d] ", string_item, num_reads);
  $sformat(string_item, "%s\n || rand_num               = [%0d] ", string_item, num_reads);
  $sformat(string_item, "%s\n || rand_type              = [%0d] ", string_item, num_reads);
  $sformat(string_item, "%s\n || dev_addr_write         = [%0h] ", string_item, dev_addr_wr);
  $sformat(string_item, "%s\n || dev_addr_read          = [%0h] ", string_item, dev_addr_rd);  
  $sformat(string_item, "%s\n || register_address       = [%0h] ", string_item, reg_addr);
  $sformat(string_item, "%s\n || write_data[3][2][1][0] = [%h][%h][%h][%h] ", string_item, write_data[31:24], write_data[23:16], write_data[15:8], write_data[7:0]);
  $sformat(string_item, "%s\n || read_data[3][2][1][0]  = [%h][%h][%h][%h] ", string_item, read_data[31:24], read_data[23:16], read_data[15:8], read_data[7:0]);  
  $sformat(string_item, "%s\n || read_data[7][6][5][4]  = [%h][%h][%h][%h] ", string_item, read_data[63:56], read_data[55:48], read_data[47:40], read_data[39:32]);
  $sformat(string_item, "%s\n =============================================", string_item);    
  return string_item;
endfunction



endclass






/*

constraint addr_range
{
(atype == low ) -> addr inside { [0 : 15] };
(atype == mid ) -> addr inside { [16 : 127]};
(atype == high) -> addr inside {[128 : 255]};
}

  constraint reg_addr_constraint { (assert_write == 1'b1) reg_addr inside {[0:7]}
                                 }


  constraint wreg_addr_constraint {reg_addr inside {}}



*/





