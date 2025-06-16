`include "uvm_macros.svh"
import uvm_pkg::*;

class apb_coverage extends uvm_subscriber #(apb_sequence_item);

	`uvm_component_utils(apb_coverage)
	uvm_analysis_imp #(apb_sequence_item, apb_coverage) analysis_imp_cov;
	apb_sequence_item t;
	
	
	  	
  	covergroup apb_cov  with function sample(apb_sequence_item t);
        option.per_instance = 1;
        
		write_cov   : coverpoint t.PWRITE     {bins write = {1}; 
                                               bins read = {0};}    
                                                   
		enable_cov  : coverpoint t.PENABLE    {bins enable_high = {1}; 
                                               bins enable_low = {0};}
        
		sel_cov     : coverpoint t.PSEL       {bins select_high = {1}; 
                                               bins select_low = {0};}
        
	    reset_cov   : coverpoint t.PRESETn    {bins reset_high = {0}; 
                                               bins reset_low = {1};}
        
		address_cov : coverpoint t.address    {bins address_low = {[0:99]}; 
                                               bins address_high = {[100:$]};}
                                               
        
        wdata_cov   : coverpoint t.write_data {bins range [4]={[0:$]};}    
                                                                                                                                              
                                                                     
        rdata_cov   : coverpoint t.read_data  {bins range [4]={[0:$]};}  
                                                                                                           

        cross_read : cross rdata_cov, reset_cov, sel_cov, enable_cov, write_cov {ignore_bins pwrite_ignore  = binsof(write_cov.write);
                                                                                 ignore_bins penable_ignore = binsof(enable_cov.enable_low);
                                                                                 ignore_bins sel_ignore     = binsof(sel_cov.select_low);
                                                                                 ignore_bins reset_ignore   = binsof(reset_cov.reset_high);}  
                                                                                 							   
                                                                                 							                                    
        cross_write : cross wdata_cov, reset_cov, sel_cov, enable_cov, write_cov {ignore_bins pwrite_ignore  = binsof(write_cov.read);
                                                                                 ignore_bins penable_ignore = binsof(enable_cov.enable_low);
                                                                                 ignore_bins sel_ignore     = binsof(sel_cov.select_low);
                                                                                 ignore_bins reset_ignore   = binsof(reset_cov.reset_high);}                                   
	 endgroup
	 
	 
	
	function new(string name= "apb_coverage", uvm_component parent = null);
    	super.new(name, parent);
		`uvm_info(get_type_name(), $sformatf("---- APB Coverage Constructed ----"), UVM_HIGH);
		apb_cov = new();

  	endfunction

  	
  	 virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
      	`uvm_info(get_type_name(), "APB Coverage 'Build Phase' Started", UVM_HIGH);
      	analysis_imp_cov = new("analysis_imp_cov", this);
        t = apb_sequence_item::type_id::create("t", this);

    endfunction
		
	
    function void write (apb_sequence_item t);	
        $display("COVERAGE got transaction from Monitor");
    	$display("PWRITE = %0d , PENABLE = %0d , PSEL = %0d, PRESETn = %0d , WRITE_DATA = %0h, ADDRESS = %0h, READ_DATA = %0h", t.PWRITE, t.PENABLE, t.PSEL, t.PRESETn, t.write_data, t.address, t.read_data);
        apb_cov.sample(t);
    endfunction



endclass
