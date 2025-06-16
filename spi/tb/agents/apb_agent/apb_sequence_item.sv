
class apb_sequence_item extends uvm_sequence_item;

    // Constructor
    function new(string name= "apb_sequence_item");
        super.new(name);
     //   `uvm_info(get_type_name(), "---- APB Sequence Item Constructed ----", UVM_HIGH);
    endfunction
    
    // ----- APB Signals ----- //
    //	Inputs
    rand logic presetn; 	   
    rand logic psel;            
    rand logic penable;         
    rand logic pwrite;        
    rand logic [4:0]  write_addr;
    rand logic [4:0]  read_addr;
    rand logic [31:0] write_data;
    
    // Outputs
    logic [31:0] read_data;
    logic pready;
    logic pslverr;
  
  	// 
  	bit IRQ;
  	bit IRQ_assert, IRQ_clear;
  	
  	rand bit has_reset;
  
    `uvm_object_utils_begin(apb_sequence_item)
        `uvm_field_int  (write_addr, UVM_ALL_ON)
        `uvm_field_int  (write_data,    UVM_ALL_ON)
        `uvm_field_int  (read_addr,  UVM_ALL_ON)
        `uvm_field_int  (read_data,     UVM_ALL_ON)
        `uvm_field_int  (presetn, UVM_BIN)
        `uvm_field_int  (psel, UVM_BIN)
        `uvm_field_int  (penable, UVM_BIN)
        `uvm_field_int  (pwrite, UVM_BIN)
        `uvm_field_int  (pready, UVM_BIN)
        `uvm_field_int  (pslverr, UVM_BIN)
    `uvm_object_utils_end

    function void sender(input string itemType, input string sender, input string receiver); 
         $display("-----------------------------------------------------------------------");   
         $display("@[%0t] ---- %s Sending %s item to %s ||-->>", $time, sender, itemType, receiver);
         $display("-----------------------------------------------------------------------");
    endfunction

    function void receiver(input string itemType, input string receiver, input string sender); 
         $display("-----------------------------------------------------------------------");   
         $display("@[%0t] ---- %s Receiving %s item from %s ||-->>", $time, receiver, itemType, sender);
         $display("-----------------------------------------------------------------------");
    endfunction
  
endclass

