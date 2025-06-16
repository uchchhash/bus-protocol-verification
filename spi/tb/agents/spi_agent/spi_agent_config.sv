
//--------- SPI Agent Config for SS line 0 -----------------//
class spi_agent_config0 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config0)
    
    // Constructor Function
    function new(string name = "spi_agent_config0");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config0 Constructed ====", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b11111110;
    bit ass;
    bit ie;
    bit [6:0] char_len;
    bit [15:0] divider;
    
endclass


//--------- SPI Agent Config for SS line 1 -----------------//
class spi_agent_config1 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config1)
    
    // Constructor Function
    function new(string name = "spi_agent_config1");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config1 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b11111101;
    bit ass;
    bit ie;
    bit [6:0] char_len;
    bit [15:0] divider;
     
endclass


//--------- SPI Agent Config for SS line 2 -----------------//
class spi_agent_config2 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config2)
    
    // Constructor Function
    function new(string name = "spi_agent_config2");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config2 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b11111011;
    bit ass;
    bit ie;
    bit [6:0] char_len;
    bit [15:0] divider;
       
endclass


//--------- SPI Agent Config for SS line 3 -----------------//
class spi_agent_config3 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config3)
    
    // Constructor Function
    function new(string name = "spi_agent_config3");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config3 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b11110111;
    bit ass;
    bit ie;
    bit [6:0] char_len;
    bit [15:0] divider;
          
endclass

//--------- SPI Agent Config for SS line 4 -----------------//
class spi_agent_config4 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config4)
    
    // Constructor Function
    function new(string name = "spi_agent_config4");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config4 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b11101111;
    bit ass;
    bit ie;
    bit [6:0] char_len;
    bit [15:0] divider;
         
endclass


//--------- SPI Agent Config for SS line 5 -----------------//
class spi_agent_config5 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config5)
    
    // Constructor Function
    function new(string name = "spi_agent_config5");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config5 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b11011111;
    bit ass;
    bit ie;
    bit [6:0] char_len;   
    bit [15:0] divider;
          
endclass


//--------- SPI Agent Config for SS line 6 -----------------//
class spi_agent_config6 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config6)
    
    // Constructor Function
    function new(string name = "spi_agent_config6");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config6 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b10111111;
    bit ass;
    bit ie;
    bit [6:0] char_len;   
    bit [15:0] divider;
         
endclass

//--------- SPI Agent Config for SS line 7 -----------------//
class spi_agent_config7 extends uvm_object;
    
    // Factory Registration
    `uvm_object_utils(spi_agent_config7)
    
    // Constructor Function
    function new(string name = "spi_agent_config7");
        super.new(name);
        `uvm_info(get_type_name(), "==== spi_agent_config7 constructed", UVM_MEDIUM);
    endfunction

    uvm_active_passive_enum status = UVM_ACTIVE;
    
    // Configurable Variables
    bit [1:0] mode;
    bit [7:0] slvsel = 8'b01111111;
    bit ass;
    bit ie;
    bit [6:0] char_len;   
    bit [15:0] divider;
              
endclass



