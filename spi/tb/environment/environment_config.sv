class environment_config extends uvm_object;
 
    `uvm_object_utils(environment_config)	

    function new(string name= "environment_config");
    	super.new(name);
        `uvm_info("get_type_name", "===== APB-SPI Environment Config Constructed =====", UVM_LOW)
    endfunction
  
    bit has_scoreboard = 1;
    bit has_functional_coverage = 1;

    

endclass

