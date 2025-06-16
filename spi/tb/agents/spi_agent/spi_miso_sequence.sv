	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-0 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence0 extends spi_base_sequence0;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence0)

	// Constructor Function
    function new(string name="spi_miso_sequence0");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-0 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-0 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-0 Body Task Finished =====", UVM_HIGH)
    endtask

endclass

	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-1 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence1 extends spi_base_sequence1;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence1)

	// Constructor Function
    function new(string name="spi_miso_sequence1");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-1 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-1 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-1 Body Task Finished =====", UVM_HIGH)
    endtask

endclass



// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-2 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence2 extends spi_base_sequence2;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence2)

	// Constructor Function
    function new(string name="spi_miso_sequence2");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-2 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-2 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-2 Body Task Finished =====", UVM_HIGH)
    endtask

endclass



	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-3 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence3 extends spi_base_sequence3;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence3)

	// Constructor Function
    function new(string name="spi_miso_sequence3");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-3 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-3 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-3 Body Task Finished =====", UVM_HIGH)
    endtask

endclass

	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-4 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence4 extends spi_base_sequence4;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence4)

	// Constructor Function
    function new(string name="spi_miso_sequence4");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-4 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-4 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-4 Body Task Finished =====", UVM_HIGH)
    endtask

endclass

	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-5 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence5 extends spi_base_sequence5;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence5)

	// Constructor Function
    function new(string name="spi_miso_sequence5");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-5 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-5 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-5 Body Task Finished =====", UVM_HIGH)
    endtask

endclass


	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-6 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence6 extends spi_base_sequence6;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence6)

	// Constructor Function
    function new(string name="spi_miso_sequence6");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-6 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-6 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-6 Body Task Finished =====", UVM_HIGH)
    endtask

endclass

	
// ------------------------------------------------ //
// ---------- SPI MISO Sequence for SS-7 ---------- //
// ------------------------------------------------ //	

class spi_miso_sequence7 extends spi_base_sequence7;
     
    // Factory Registration 
    `uvm_object_utils(spi_miso_sequence7)

	// Constructor Function
    function new(string name="spi_miso_sequence7");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-7 Constructed =====", UVM_HIGH)
    endfunction
    
    // Sequence Item
    spi_sequence_item spi_item;
    
    task body();
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-7 Body Task Called =====", UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("mode = %0d, char_len = %0d", mode, char_len), UVM_HIGH)
         `uvm_do_with(spi_item, {spi_item.mode  == local::mode;
                                 spi_item.char_len == local:: char_len;
                                })
        `uvm_info(get_type_name(),"===== SPI MISO Sequence-7 Body Task Finished =====", UVM_HIGH)
    endtask

endclass




