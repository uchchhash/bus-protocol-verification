`include "uvm_macros.svh"
import uvm_pkg::*;

class agent_config extends uvm_object;
   `uvm_object_utils( agent_config )
 
   uvm_active_passive_enum status = UVM_ACTIVE;

 
   function new(string name = "agent_config");
      super.new(name);
     `uvm_info(get_type_name(), "---- AHB AGNT_CONFIG Constructed ----", UVM_HIGH);
   endfunction
   
   
endclass
