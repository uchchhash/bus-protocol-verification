//----------- SPI Sequence Item for eight slave select lines ---------------//

class spi_sequence_item extends uvm_sequence_item;


      // Constructor Function
      function new(string name= "spi_sequence_item");
          super.new(name);
      //    `uvm_info(get_type_name(), "---- SPI Sequence Item Constructed ----", UVM_HIGH);
      endfunction
      
      // ----- SPI Signals ----- //
      //  Inputs
      rand logic [7:0] slvsel;
      rand logic mosi;	

      // Outputs
      logic miso;
      logic IRQ;

      // Controls
      rand logic [15:0] divider;
      rand logic [6:0] char_len;
      rand logic go_bsy;
      rand logic rx_neg;
      rand logic tx_neg;
      rand logic lsb;
      rand logic ass;
      rand logic ie;
      rand logic [7:0] length;
      rand logic [1:0] mode;
      
      
      // Monitor to SCB
      bit [127:0] SDI;
      bit [127:0] SDO;
      
      rand bit [127:0] miso_reg;
      bit [127:0] nedge_mosi;
      bit [127:0] nedge_miso;
      bit [127:0] pedge_mosi;
      bit [127:0] pedge_miso;
      
      bit unload_done;
      int max_index;
      real sclk_freq;

      constraint spi_modes {mode inside {2'b00, 2'b01};}
      constraint one_slvsel {$countones(slvsel)==1;}
      
//      constraint slv_sel {slvsel inside {8'b00000001};}
      
      
    //  constraint div_range {divider inside {16'h00, 16'h01, 16'h02, 16'h04, 16'h08, 16'h10, 16'h20, 16'h40, 16'h80, 16'h100, 16'h200, 16'h400, 16'h800, 16'h1000, 16'h2000, 16'h4000, 16'h8000};}    
 //     constraint len_range {char_len inside {7'h01, 7'h02, 7'h04, 7'h08, 7'h10, 7'h20, 7'h40, 7'h00};}  
      
     constraint div_range {divider inside {16'h00, 16'h01, 16'h02, 16'h04, 16'h08, 16'h10, 16'h20, 16'h40};} //enam
   	 //constraint miso_range {miso_reg inside {128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA};}    
   
   
   //  constraint len_range {char_len inside {0};} //enam
  //   constraint spi_modes {mode inside {2'b01};}
 //    constraint miso_range {miso_reg inside {128'h0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF};}
    //   constraint miso_range {miso_reg inside {128'h0000000000000000000000000000008F};} 
    //    constraint miso_range {miso_reg inside {128'hFFFD};}
   //  constraint lsb_range {lsb inside {1'b1};}
    // constraint slvsel_range {slvsel inside {8'b00000001};}
       
       
      `uvm_object_utils_begin(spi_sequence_item)
          `uvm_field_int  (mosi, UVM_BIN)
          `uvm_field_int  (miso, UVM_BIN)
          `uvm_field_int  (slvsel,  UVM_ALL_ON)
          `uvm_field_int  (divider,  UVM_ALL_ON)
          `uvm_field_int  (char_len,  UVM_ALL_ON)
          `uvm_field_int  (go_bsy, UVM_BIN)
          `uvm_field_int  (rx_neg, UVM_BIN)
          `uvm_field_int  (tx_neg, UVM_BIN)
          `uvm_field_int  (lsb, UVM_BIN)
          `uvm_field_int  (ass, UVM_BIN)
      `uvm_object_utils_end
      
endclass



/*

65535 is multiplo of 1

65535 is multiplo of 3

65535 is multiplo of 5

65535 is multiplo of 15

65535 is multiplo of 17

65535 is multiplo of 51

65535 is multiplo of 85

65535 is multiplo of 255

65535 is multiplo of 257

65535 is multiplo of 771

65535 is multiplo of 1285

65535 is multiplo of 3855

65535 is multiplo of 4369

65535 is multiplo of 13107

65535 is multiplo of 21845

65535 has 15 positive divisors

*/

