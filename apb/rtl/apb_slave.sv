/*
                      -----------
    paddr[31:0]  ===>|           |
    pwdata[31:0] ===>|           |
    pwrite       --->|           |===> prdata[31:0] 
    psel         --->| APB SLAVE |
    penable      --->|           |
    pclk         --->|           |
    rst_n        --->|           |
                      -----------
*/
module apb_slave#(addrWidth = 32,dataWidth = 32)
(
    input                        pclk,
    input                        rst_n,
    input        [addrWidth-1:0] paddr,
    input                        pwrite,
    input                        psel,
    input                        penable,
    input        [dataWidth-1:0] pwdata,
    output logic [dataWidth-1:0] prdata
);

    logic [dataWidth-1:0] mem [256];
    logic [1:0] apb_st;
    const logic [1:0] SETUP = 0;
    const logic [1:0] W_ENABLE = 1;
    const logic [1:0] R_ENABLE = 2;
    
    // SETUP -> ENABLE
    always @(negedge rst_n or posedge pclk) begin
        if (rst_n == 0) begin
            apb_st <= 0;
            prdata <= 32'hFEDC_BA98;
        end   
        else begin
            case (apb_st)
                SETUP    :  begin
                                // clear the prdata
                                prdata <= 32'hFEDC_BA98;
                                // Move to ENABLE when the psel is asserted
                                if (psel && !penable) begin
                                    if (pwrite) begin
                                        apb_st <= W_ENABLE;
                                    end
                                    else begin
                                        apb_st <= R_ENABLE;
                                    end
                                end
                            end
    
                W_ENABLE :  begin
                                // write pwdata to memory
                                if (psel && penable && pwrite) begin
                                    mem[paddr] <= pwdata;
                                end
    
                                // return to SETUP
                                apb_st <= SETUP;
                            end
    
                R_ENABLE :  begin
                                // read prdata from memory
                                if (psel && penable && !pwrite) begin
                                    prdata <= mem[paddr];
                                end
    
                                // return to SETUP
                                apb_st <= SETUP;
                            end
            endcase
        end
    end 
endmodule

