interface apb_interface(input clk);

    // input / output / inout port declaration
    
    logic PRESETn;
    logic [31:0] PADDR;
    logic PSEL;
    logic PENABLE;
    logic PWRITE;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;
    
    
    
	
	sequence psel_seq;
  		$rose(PSEL);
   endsequence
    
   sequence enable_seq;
  		##1 PENABLE;
   endsequence
    
   sequence seq_3;
    	##1 $fell(PSEL && PENABLE);
   endsequence

	
   property psel_enable;
  		@(negedge clk) psel_seq |-> enable_seq |-> seq_3;
   endproperty
	
	assertion_psel_enable : assert property(psel_enable)
    $display("Assertion Passed @[%0t]", $time);
    else $display("Assertion Failed @[%0t]", $time);
    

endinterface
