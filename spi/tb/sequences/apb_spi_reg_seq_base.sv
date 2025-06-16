class apb_spi_reg_seq_base extends uvm_sequence#(uvm_sequence_item);

    // Factory Registration
    `uvm_object_utils(apb_spi_reg_seq_base)

    // Register Block Handle
    spi_reg_block spi_rb;
    
    // Required Variables
    uvm_status_e status;
    uvm_reg data_regs[], config_regs[];
    int length;
    int num_regs;
    bit go_bsy_val;
    bit [127:0] data_val, config_val;

	// Required Variables
	rand bit ie;
	rand bit ass;
	rand bit lsb;
	rand bit [1:0] mode;
	rand bit [6:0] char_len;
	rand bit [7:0] slvsel;
	rand bit [15:0] divider;


    // Constructor Function
    function new(string name="apb_spi_reg_seq_base");
        super.new(name);
        //`uvm_info(get_type_name(),"===== SPI Register Sequence Base Constructed =====", UVM_LOW)
    endfunction

    task body();
        //  `uvm_info(get_type_name(), "====  APB-SPI Reg Sequence Base Body Task Called   ====", UVM_MEDIUM)
        //  `uvm_info(get_type_name(), "====  APB-SPI Reg Sequence Base Body Task Finished ====", UVM_MEDIUM)
    endtask

endclass


/*
// --------------------------------------------- //
// ---------- Register Reset Sequence ---------- //
// --------------------------------------------- //

class spi_reg_reset_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(spi_reg_reset_seq)

    // Constructor Function
    function new(string name="spi_reg_reset_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Register Reset Sequence Constructed =====", UVM_HIGH)
    endfunction

    task body();
        `uvm_info(get_type_name(),"===== SPI Register Reset Sequence Body Task Called =====", UVM_HIGH)


        data_regs = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3};
        length = (char_len == 0) ? 128 : char_len;
        num_regs = (length <= 32) ? 0 : (length <= 64) ? 1 : (length <= 96) ? 2 : 3;
        `uvm_info(get_type_name(), $sformatf("Char_Len = %0d, Length = %0d, Maximum Reg Index = %0d", char_len, length, num_regs), UVM_HIGH); 
        for(int i = 0; i <=num_regs; i++)begin
           assert(data_regs[i].randomize());
           data_regs[i].update(status, .path(UVM_FRONTDOOR), .parent(this));
          `uvm_info(get_type_name(), $sformatf("[Tx%0d] Mirror = %0h, Desired = %0h status = %0s", i, data_regs[i].get_mirrored_value(), data_regs[i].get(), status.name), UVM_HIGH); 
        end
        
        
        
        `uvm_info(get_type_name(),"===== SPI Register Reset Sequence Body Task Finished =====", UVM_HIGH)
      endtask

endclass

*/






// ---------------------------------------- //
// ---------- Data Load Sequence ---------- //
// ---------------------------------------- //

class data_load_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(data_load_seq)

    // Constructor Function
    function new(string name="data_load_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Data Load Sequence Constructed =====", UVM_HIGH)
    endfunction

    task body();
        `uvm_info(get_type_name(),"===== SPI Data Load Sequence Body Task Called =====", UVM_HIGH)
        // Set Data Register, Calculate the character length & Select data registers based on length
        data_regs = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3};
        length = (char_len == 0) ? 128 : char_len;
        num_regs = (length <= 32) ? 0 : (length <= 64) ? 1 : (length <= 96) ? 2 : 3;
        `uvm_info(get_type_name(), $sformatf("Char_Len = %0d, Length = %0d, Maximum Reg Index = %0d", char_len, length, num_regs), UVM_HIGH); 
        for(int i = 0; i <=num_regs; i++)begin
           assert(data_regs[i].randomize());
           data_regs[i].update(status, .path(UVM_FRONTDOOR), .parent(this));
		 //  data_regs[i].write(status, .value(32'h00000000));
          //`uvm_info(get_type_name(), $sformatf("[Tx%0d] Mirror = %0h, Desired = %0h status = %0s", i, data_regs[i].get_mirrored_value(), data_regs[i].get(), status.name), UVM_MEDIUM); 
        end
        //data_regs[0].write(status, .value(32'hFFFFFFFF));
        //data_regs[1].write(status, .value(32'hFFFFFFFF));        
        //data_regs[2].write(status, .value(32'hFFFFFFFF));        
        //data_regs[3].write(status, .value(32'hF00FFFFF));
                
        `uvm_info(get_type_name(),"===== SPI Data Load Sequence Body Task Finished =====", UVM_HIGH)
      endtask

endclass



// ------------------------------------------- //
// ---------- Control Load Sequence ---------- //
// ------------------------------------------- //

class control_load_seq extends apb_spi_reg_seq_base;

	// Factory Registration
	`uvm_object_utils(control_load_seq)

	// Constructor Function
	function new(string name="control_load_seq");
		super.new(name);
        `uvm_info(get_type_name(),"===== SPI Control Load Sequence Constructed =====", UVM_HIGH)
	endfunction

	task body();
        `uvm_info(get_type_name(),"===== SPI Control Load Sequence Body Task Called =====", UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("char_len = %0d, mode = %0d, lsb = %0d, ie = %0d, ass = %0d", char_len, mode, lsb, ie, ass), UVM_HIGH); 
		assert(spi_rb.ctrl.randomize() with {spi_rb.ctrl.char_len.value == local::char_len;
											 spi_rb.ctrl.go_bsy.value == 0;
											 spi_rb.ctrl.rx_neg.value == local::mode[0];
											 spi_rb.ctrl.tx_neg.value == !local::mode[0];
											 spi_rb.ctrl.lsb.value == local::lsb;
											 spi_rb.ctrl.ie.value == local::ie;
											 spi_rb.ctrl.ass.value == local::ass;
											});
											spi_rb.ctrl.update(status, .path(UVM_FRONTDOOR), .parent(this));						
        `uvm_info(get_type_name(), $sformatf("[CTRL] Mirror = %0h, Desired = %0h status = %0s", spi_rb.ctrl.get_mirrored_value(), spi_rb.ctrl.get(), status.name), UVM_HIGH); 
        `uvm_info(get_type_name(),"===== SPI Control Load Sequence Body Task Finished =====", UVM_HIGH)
	endtask  

endclass


// ------------------------------------------- //
// ---------- Divider Load Sequence ---------- //
// ------------------------------------------- //
	
class divider_load_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(divider_load_seq)

    // Constructor Function
    function new(string name="divider_load_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Divider Load Sequence Constructed =====", UVM_HIGH)
    endfunction

    task body();
        `uvm_info(get_type_name(),"===== SPI Divider Load Sequence Body Task Called =====", UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Divider = %0d", divider), UVM_HIGH); 
        spi_rb.divider.write(status, .value(divider));
        `uvm_info(get_type_name(), $sformatf("[DIV] Mirror = %0h, Desired = %0h status = %0s", spi_rb.divider.get_mirrored_value(), spi_rb.divider.get(), status.name), UVM_HIGH); 
        `uvm_info(get_type_name(),"===== SPI Divider Load Sequence Body Task Finished =====", UVM_HIGH)
    endtask 

endclass
	
	
// ------------------------------------------- //
// ---------- Slave Select Sequence ---------- //
// ------------------------------------------- //	

class slave_select_seq extends apb_spi_reg_seq_base;
    
    // Factory Registration
    `uvm_object_utils(slave_select_seq)

    // Constructor Function
    function new(string name="slave_select_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Slave Select Sequence Constructed =====", UVM_HIGH)
    endfunction

    task body();
        `uvm_info(get_type_name(),"===== SPI Slave Select Body Task Called =====", UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("SLVSEL = %b", slvsel), UVM_HIGH); 
        spi_rb.ss.write(status, .value(slvsel));
        `uvm_info(get_type_name(), $sformatf("[SS] Mirror = %0b, Desired = %0b status = %0s", spi_rb.ss.get_mirrored_value(), spi_rb.ss.get(), status.name), UVM_HIGH); 
        `uvm_info(get_type_name(),"===== SPI Slave Select Body Task Finised =====", UVM_HIGH)
    endtask  

endclass



// ----------------------------------------- //
// ---------- Control Go Sequence ---------- //
// ----------------------------------------- //

class control_go_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(control_go_seq)

    // Constructor Function
    function new(string name="control_go_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Go Sequence Constructed =====", UVM_HIGH)
    endfunction

    task body();
        `uvm_info(get_type_name(),"===== SPI Go Sequence Body Task Called =====", UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("[Before][Go] Mirror = %0d, Desired = %0d, status = %0s", spi_rb.ctrl.go_bsy.get_mirrored_value(),spi_rb.ctrl.go_bsy.get(),status.name), UVM_HIGH); 
        // Set and Update the GO Bsy Value
        spi_rb.ctrl.go_bsy.set(.value(1));
        spi_rb.ctrl.update(status, .path(UVM_FRONTDOOR), .parent(this));
        `uvm_info(get_type_name(), $sformatf("[After][Go] Mirror = %0d, Desired = %0d, status = %0s", spi_rb.ctrl.go_bsy.get_mirrored_value(),spi_rb.ctrl.go_bsy.get(),status.name), UVM_HIGH); 
        `uvm_info(get_type_name(),"===== SPI Go Sequence Body Task Finished =====", UVM_HIGH)
    endtask  

endclass


// ------------------------------------------ //
// ---------- SPI Polling Sequence ---------- //
// ------------------------------------------ //

class spi_polling_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(spi_polling_seq)
   

    // Constructor Function
    function new(string name="spi_polling_seq_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Polling Sequence Constructed =====", UVM_HIGH)
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"===== SPI Polling Sequence Body Task Called =====", UVM_HIGH)
        //`uvm_info(get_type_name(), $sformatf("[Before][Go] Mirror = %0d, Desired = %0d, status = %0s", spi_rb.ctrl.go_bsy.get_mirrored_value(),spi_rb.ctrl.go_bsy.get(),status.name), UVM_MEDIUM); 
      	// Poll the Go Busy Signal
        while(spi_rb.ctrl.go_bsy.value == 1) begin
            spi_rb.ctrl.go_bsy.read(status, .value(go_bsy_val), .parent(this));
        	//`uvm_info(get_type_name(), $sformatf("[During][Go] Mirror = %0d, Desired = %0d, status = %0s", spi_rb.ctrl.go_bsy.get_mirrored_value(),spi_rb.ctrl.go_bsy.get(),status.name), UVM_MEDIUM); 
        end
        //`uvm_info(get_type_name(), $sformatf("[After][Go] Mirror = %0d, Desired = %0d, status = %0s", spi_rb.ctrl.go_bsy.get_mirrored_value(),spi_rb.ctrl.go_bsy.get(),status.name), UVM_MEDIUM); 
        `uvm_info(get_type_name(),"===== SPI Polling Sequence Body Task Finished =====", UVM_HIGH)
    endtask  

endclass


// --------------------------------------------- //
// ---------- Slave DeSelect Sequence ---------- //
// --------------------------------------------- //

class slave_deselect_seq extends apb_spi_reg_seq_base;
   
    // Factory Registration
    `uvm_object_utils(slave_deselect_seq)

    // Constructor Function
    function new(string name="slave_deselect_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Slave De-Select Sequence Constructed =====", UVM_HIGH)
    endfunction

     task body();
        `uvm_info(get_type_name(),"===== SPI Slave De-Select Sequence Body Task Called =====", UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("[Before][SS] Mirror = %0b, Desired = %0b status = %0s", spi_rb.ss.get_mirrored_value(), spi_rb.ss.get(), status.name), UVM_HIGH); 
        spi_rb.ss.write(status, .value(0)); 
        `uvm_info(get_type_name(), $sformatf("[After][SS] Mirror = %0b, Desired = %0b status = %0s", spi_rb.ss.get_mirrored_value(), spi_rb.ss.get(), status.name), UVM_HIGH); 
        `uvm_info(get_type_name(),"===== SPI Slave De-Select Sequence Body Task Finished =====", UVM_HIGH)
    endtask  
    
endclass



// ------------------------------------------ //
// ---------- Data Unload Sequence ---------- //
// ------------------------------------------ //

class data_unload_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(data_unload_seq)

    // Constructor Function
    function new(string name="data_unload_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Data Unload Sequence Constructed =====", UVM_HIGH)
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"===== SPI Data Unload Sequence Body Task Called =====", UVM_HIGH)
        // Set Data Register, Calculate the character length & Select data registers based on length
        data_regs = '{spi_rb.rxtx0, spi_rb.rxtx1, spi_rb.rxtx2, spi_rb.rxtx3};
        length = (char_len == 0) ? 128 : char_len;
        num_regs = (length <= 32) ? 0 : (length <= 64) ? 1 : (length <= 96) ? 2 : 3;
        //`uvm_info(get_type_name(), $sformatf("Char_Len = %0d, Length = %0d, Maximum Reg Index = %0d", char_len, length, num_regs), UVM_MEDIUM); 
        for(int i = 0; i <=num_regs; i++)begin
            data_regs[i].read(status, .value(data_val), .parent(this));
        end     
     //`uvm_info(get_type_name(), $sformatf("[Rx0] Mirror = %0h, Desired = %0h status = %0s", data_regs[0].get_mirrored_value(), data_regs[0].get(), status.name), UVM_MEDIUM);          
     //`uvm_info(get_type_name(), $sformatf("[Rx1] Mirror = %0h, Desired = %0h status = %0s", data_regs[1].get_mirrored_value(), data_regs[1].get(), status.name), UVM_MEDIUM);          
     //`uvm_info(get_type_name(), $sformatf("[Rx2] Mirror = %0h, Desired = %0h status = %0s", data_regs[2].get_mirrored_value(), data_regs[2].get(), status.name), UVM_MEDIUM);         
     //`uvm_info(get_type_name(), $sformatf("[Rx3] Mirror = %0h, Desired = %0h status = %0s", data_regs[3].get_mirrored_value(), data_regs[3].get(), status.name), UVM_MEDIUM);          
        `uvm_info(get_type_name(),"===== SPI Data Unload Sequence Body Task Finished =====", UVM_HIGH)
      endtask
endclass


// -------------------------------------------- //
// ---------- Config Unload Sequence ---------- //
// -------------------------------------------- //

class config_unload_seq extends apb_spi_reg_seq_base;

    // Factory Registration
    `uvm_object_utils(config_unload_seq)

    // Constructor Function
    function new(string name="config_unload_seq");
        super.new(name);
        `uvm_info(get_type_name(),"===== SPI Config Unload Sequence Constructed =====", UVM_HIGH)
    endfunction
    
    task body();
        `uvm_info(get_type_name(),"===== SPI Config Unload Sequence Body Task Called =====", UVM_HIGH)
		config_regs = '{spi_rb.ss, spi_rb.ctrl, spi_rb.divider};
        for(int i = 0; i <=2; i++)begin
            config_regs[i].read(status, .value(config_val), .parent(this));
        end             
        `uvm_info(get_type_name(),"===== SPI Config Unload Sequence Body Task Finished =====", UVM_HIGH)
      endtask

endclass


