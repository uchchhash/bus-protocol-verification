//--------- SPI Sequencer for SS line 0 ------------//
class spi_sequencer0 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer0)

    // Constructor Function
    function new(string name="spi_sequencer0", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-0 Constructed =====", UVM_LOW)
    endfunction
   
endclass


//--------- SPI Sequencer for SS line 1 ------------//
class spi_sequencer1 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer1)

	// COnstructor Function
    function new(string name="spi_sequencer1", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-1 Constructed =====", UVM_LOW)
    endfunction

endclass


//--------- SPI Sequencer for SS line 2 ------------//
class spi_sequencer2 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer2)

	// COnstructor Function
    function new(string name="spi_sequencer2", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-2 Constructed =====", UVM_LOW)
    endfunction

endclass



//--------- SPI Sequencer for SS line 3 ------------//
class spi_sequencer3 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer3)

    // Constructor Function
    function new(string name="spi_sequencer3", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-3 Constructed =====", UVM_LOW)
    endfunction
   
endclass


//--------- SPI Sequencer for SS line 4 ------------//
class spi_sequencer4 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer4)

    // Constructor Function
    function new(string name="spi_sequencer4", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-4 Constructed =====", UVM_LOW)
    endfunction
   
endclass



//--------- SPI Sequencer for SS line 5 ------------//
class spi_sequencer5 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer5)

    // Constructor Function
    function new(string name="spi_sequencer5", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-5 Constructed =====", UVM_LOW)
    endfunction
   
endclass


//--------- SPI Sequencer for SS line 6 ------------//
class spi_sequencer6 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer6)

    // Constructor Function
    function new(string name="spi_sequencer6", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-6 Constructed =====", UVM_LOW)
    endfunction
   
endclass


//--------- SPI Sequencer for SS line 7 ------------//
class spi_sequencer7 extends uvm_sequencer #(spi_sequence_item);
    
    // Factory Registration
    `uvm_component_utils(spi_sequencer7)

    // Constructor Function
    function new(string name="spi_sequencer7", uvm_component parent=null);
        super.new(name, parent);
        `uvm_info("get_type_name", "===== SPI Sequencer-7 Constructed =====", UVM_LOW)
    endfunction
   
endclass


