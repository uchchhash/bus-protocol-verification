interface apb_interface(input PCLK);
	
    // ----- APB Signals ----- //
    //	Inputs
    logic PRESETn; 	   // Active Low Reset
    logic PSEL;            // Select
    logic PENABLE;         // Enable
    logic PWRITE;          // Write/Read Control
    logic [4:0] PADDR;     // Address
    logic [31:0]PWDATA;    // Write Data

    // Outputs
    logic [31:0]PRDATA;    // Read Data
    logic PREADY;          // Ready 
    logic PSLVERR;         // Slave Error
    
    
  	
endinterface
