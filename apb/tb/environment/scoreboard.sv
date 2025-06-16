`include "uvm_macros.svh"
import uvm_pkg::*;


`uvm_analysis_imp_decl(_port_drvr)
`uvm_analysis_imp_decl(_port_mntr)

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)
    
    apb_sequence_item exp_q [$];
    apb_sequence_item act_q [$];
    
    apb_sequence_item exp_store;
    apb_sequence_item act_store;
    
    uvm_analysis_imp_port_drvr #(apb_sequence_item, scoreboard) analysis_imp_drvr; 
    uvm_analysis_imp_port_mntr #(apb_sequence_item, scoreboard) analysis_imp_mntr;
    
    int pass_count;
	int fail_count;

  
  	function new(string name="scoreboard", uvm_component parent= null);
    	super.new(name, parent);
    	`uvm_info(get_type_name(), "---- APB Scoreboard Constructed ----", UVM_HIGH);
	
    endfunction
  
  
  	virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
      	`uvm_info(get_type_name(), "APB Scoreboard 'Build Phase' Started", UVM_HIGH);
      	analysis_imp_drvr = new("analysis_imp_drvr", this);
        analysis_imp_mntr = new("analysis_imp_mntr", this);
        exp_store = new();
		act_store = new();
  	
    endfunction
  
  
  	virtual function void connect_phase(uvm_phase phase);
    	super.connect_phase(phase);
    	`uvm_info(get_type_name(), "APB Scoreboard 'Connect Phase' Started", UVM_HIGH);    
  	endfunction
  	
  	
    virtual function void write_port_drvr (apb_sequence_item exp_item);
     //  `uvm_info (get_type_name(), "SCB got transaction from Driver", UVM_LOW);
    //	$display("Exp_Data = %0h , Exp_Address = %0h ", exp_item.write_data, exp_item.address);
        exp_q.push_front(exp_item);
    endfunction
    
    
    virtual function void  write_port_mntr (apb_sequence_item act_item);
    //	`uvm_info (get_type_name(), "SCB got transaction from Monitor", UVM_LOW);
    //	$display("Act_Data = %0h , Act_Address = %0h ", act_item.read_data, act_item.address);
       	act_q.push_front(act_item);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
    	super.run_phase(phase);
    	`uvm_info(get_type_name(),"APB Scoreboard 'Run Phase' Started", UVM_HIGH);
    	forever begin 		
                wait(exp_q.size() == 1)
                wait(act_q.size() == 1)
			    exp_store = exp_q.pop_back();
			    act_store = act_q.pop_back();
				if(exp_store.write_data == act_store.read_data && exp_store.address == act_store.address) begin
					$display("  PASS:: Exp_Data = %0h , Exp_Address = %0h  ||  Act_Data = %0h , Act_Address = %0h", exp_store.write_data, exp_store.address, act_store.read_data, act_store.address);
					pass_count = pass_count+1;
				end

				else begin
					$display("  PASS:: Exp_Data = %0h , Exp_Address = %0h  ||  Act_Data = %0h , Act_Address = %0h", exp_store.write_data, exp_store.address, act_store.read_data, act_store.address);
					fail_count = fail_count+1;
				end
		    end
    endtask
    
    virtual function void report_phase(uvm_phase phase);
    	$display("------------------------ SUMMARY REPORT ----------------------");
		$display("Total Test: %0d || Total Pass: %0d || Total Fail: %0d", pass_count+fail_count,  pass_count, fail_count);
		$display("------------------------- END SUMMARY -------------------------"); 
    endfunction

endclass
