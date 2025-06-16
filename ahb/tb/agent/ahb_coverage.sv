class ahb_coverage extends uvm_subscriber #(ahb_sequence_item);

  	`uvm_component_utils(ahb_coverage)
 	 uvm_analysis_imp #(ahb_sequence_item, ahb_coverage) analysis_imp_cov;
	ahb_sequence_item t;
	  	
  	covergroup ahb_cov  with function sample(ahb_sequence_item t);
        option.per_instance = 1;
      	reset_cov   : coverpoint t.hresetn    {bins reset_high = {0}; 
                                               bins reset_low = {1};}
      
      	write_cov   : coverpoint t.hwrite     {bins write = {1}; 
                                               bins read = {0};}
      
      	sel_cov     : coverpoint t.hselx       {bins select_high = {1}; 
                                               bins select_low = {0};}

      
      	trans_cov : coverpoint t.htrans {bins idle = {0};
                                       bins busy = {1};
                                       bins nonseq = {2};
                                       bins seq = {3};}
      	
      	burst_cov: coverpoint t.hburst {bins single = {0};
                                       bins incr = {1};
                                       bins wrap4 = {2};
                                      bins incr4 = {3};
                                      bins wrap8 = {4};
                                      bins incr8 = {5};
                                      bins wrap16 = {6};
                                      bins incr16 = {7};}
      
      	size_cov: coverpoint t.hsize {bins size  = {[0:7]};}

      	address_cov : coverpoint t.start_address {bins range [4]={[0:$]};}
                                               
        
        wdata_cov   : coverpoint t.write_data {bins range [4]={[0:$]};}    
                                                                                                                                              
                                                                     
        rdata_cov   : coverpoint t.read_data  {bins range [4]={[0:$]};} 
                                
	endgroup
	 
	 
	
  	function new(string name= "ahb_coverage", uvm_component parent = null);
    	super.new(name, parent);
      `uvm_info(get_type_name(), $sformatf("---- AHB Coverage Constructed ----"), UVM_LOW);
		ahb_cov = new();

  	endfunction

  	
  	 virtual function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
       `uvm_info(get_type_name(), "AHB Coverage 'Build Phase' Started", UVM_LOW);
      	analysis_imp_cov = new("analysis_imp_cov", this);
        t = ahb_sequence_item::type_id::create("t", this);

    endfunction
	
  	function void write(ahb_sequence_item t);
    	ahb_cov.sample(t);
      	//$display("Coverage Got Transaction from Monitor");
        //$display("[@ %0t] HRESP = %0d, HREADY = %0d, HSELx = %0d, HRESETn = %0d, HTRANS = %0d, HSIZE = %0d, HBURST = %0d", $time, t.hresp , t.hready, t.hselx, t.hresetn, t.htrans,t.hsize, t.hburst);
      //	$display("[@ %0t] ADDRESS = %0h, WRITE_DATA = %0h, READ_DATA = %0h",$time, t.start_address, t.write_data, t.read_data);
    endfunction




endclass
