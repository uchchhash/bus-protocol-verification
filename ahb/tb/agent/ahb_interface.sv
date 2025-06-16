interface ahb_interface(input HCLK);
  
  	
  	logic HRESETN;	// Active Low Reset
	logic HSEL;	// 
    logic HWRITE;
  	logic [1:0] HTRANS;	
  	logic [2:0] HBURST;	
  	logic [2:0] HSIZE;	
  	logic [`addrWidth-1:0] HADDR;	// Address
  	logic [`dataWidth-1:0] HWDATA;	// Write Data
  
    logic HREADY;
  	logic [1:0] HRESP;
  	logic [`dataWidth-1:0] HRDATA;	// Read Data

    logic HREADY_I = 1'b1; 

    //-- Custom HREADY signal generation----//

  //  `ifdef INCLUDE_HREADY
        always @(negedge HWRITE)begin
            repeat(1000) begin
                repeat(2)@(negedge HCLK);
                HREADY_I = 1'b1;
                @(negedge HCLK);
                HREADY_I = 1'b0;
                repeat(3)@(negedge HCLK);
                HREADY_I = 1'b1;
                repeat(2)@(negedge HCLK);
                HREADY_I = 1'b0;
                repeat(5)@(negedge HCLK);
                HREADY_I = 1'b1;
            end
        end
        always @(negedge HWRITE)begin
            HREADY_I = 1'b1;
            @(negedge HCLK);
            HREADY_I = 1'b0;
            repeat(2)@(negedge HCLK);
            HREADY_I = 1'b1;
        end
  //  `endif

    `ifdef ASSERTS

    //----------------------------------------------------------------------------------------------------------------------//
    //---------------------------------------------- AHB Slave Assertions -------------------------------------------------//
    //---------------------------------------------------------------------------------------------------------------------//


    //-------------------ahb_seq_transfer_chk ----------------------//
    //----> It checks at every posedge of HCLK if,
    //-- HWRITE fells from high to low or roses from low to high &&
    //-- HTRANS is `NONSEQ &&
    //-- HBURST is not `SINGLE at the same clock cycle. then,
    //-- HTRANS becomes `SEQ at the next posedge of HCLK
    //----> Does not check if HRESET is low.
    //---------------------------------------------------------------//

    sequence seq_trans_s;
        HREADY_I && (HBURST `== 3'b000) && (HTRANS == 2'b10);    
    endsequence

    property seq_trans_p;
        disable iff(!HRESETN && !HSEL)
        @(posedge HCLK) (seq_trans_s) |=> (HTRANS == 2'b11);
    endproperty

    ahb_seq_transfer_chk: assert property (seq_trans_p)
      $display("@[%0t][ASSERT][AHB Sequential Transfer CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Sequential Transfer CHK] Assertion Failed", $time);

    


    //-------------------ahb_hready_extend_chk ----------------------//
    //----> It checks at every posedge of HCLK if,
    //-- HREADY fells from high to low then, from the next clock cycle
    //-- HADDR and HWDATA will remain stable until with,
    //-- HREADY rises from low to high.
    //----> Does not check if HRESET is low.
    //---------------------------------------------------------------//

    property hready_p;
        disable iff(!HRESETN)
        @(posedge HCLK) $fell(HREADY_I) && (HSEL) |=> $stable(HADDR) && $stable (HWDATA) until_with ($rose(HREADY_I));    
    endproperty

    ahb_hready_extend_chk: assert property(hready_p)
        $display("[%0t][ASSERT][AHB HREADY extend CHK] Assertion Passed", $time);
        else $display("[%0t][ASSERT][AHB HREADY extend CHK]", $time);

/*
    //-------------------ahb_burst_length_chk ----------------------//
    //----> It checks at every posedge of HCLK if,
    //-- at first clock cycle, HTRANS == `NONSEQ and HBURST == `WRAP4 or `INCR4 and at the next clock cyle, HTRANS == `SEQ then, HTRANS becomes `NONSEQ afet 4 clock cycles.
    //-- at first clock cycle, HTRANS == `NONSEQ and HBURST == `WRAP8 or `INCR8 and at the next clock cyle, HTRANS == `SEQ then, HTRANS becomes `NONSEQ afet 8 clock cycles.
    //-- at first clock cycle, HTRANS == `NONSEQ and HBURST == `WRAP16 or `INCR16 and at the next clock cyle, HTRANS == `SEQ then, HTRANS becomes `NONSEQ afet 16 clock cycles.
    //----> Does not check if HRESET is low.
    //-----------------------------------------------------------------//


    property burst_length4_p;
        disable iff(!HRESETN)
        @(posedge HCLK) ((HBURST == `WRAP4 || HBURST == `INCR4) && HTRANS == `NONSEQ) |=> (HTRANS == `SEQ) ##3 (HTRANS == `NONSEQ);
    endproperty

    property burst_length8_p;
        disable iff(!HRESETN)
        @(posedge HCLK) ((HBURST == `WRAP8 || HBURST == `INCR8) && HTRANS == `NONSEQ) |=> (HTRANS == `SEQ) ##7 (HTRANS == `NONSEQ);
    endproperty

    property burst_length16_p;
        disable iff(!HRESETN)
        @(posedge HCLK) ((HBURST == `WRAP16 || HBURST == `INCR16) && HTRANS == `NONSEQ) |=> (HTRANS == `SEQ) ##15 (HTRANS == `NONSEQ);
    endproperty

    ahb_burst_length4_chk: assert property (burst_length4_p)
      $display("@[%0t][ASSERT][AHB Burst Length4 CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Burst Length CHK] Assertion Failed", $time);

    ahb_burst_length8_chk: assert property (burst_length8_p)
      $display("@[%0t][ASSERT][AHB Burst Length8 CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Burst Length CHK] Assertion Failed", $time);

    ahb_burst_length16_chk: assert property (burst_length16_p)
      $display("@[%0t][ASSERT][AHB Burst Length16 CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Burst Length CHK] Assertion Failed", $time);




    //-----------------------------------------------------------------//
    //-------------------ahb_address_increment_chk ----------------------//
    //----> It checks at every posedge of HCLK if,
    //-- HBURST is equal to `INCR4 or `INCR8 or `INCR16 then,
    //--- If, HSIZE == `WORD: at every clock cycle, HADDR increases by four until HTRANS becomes `NONSEQ
    //--- If, HSIZE == `HALFWORD: at every clock cycle, HADDR increases by two until HTRANS becomes `NONSEQ
    //--- If, HSIZE == `BYTE: at every clock cycle, HADDR increases by one until HTRANS becomes `NONSEQ
    //----> Does not check if HRESET is low.
    //-----------------------------------------------------------------//
    
    property addr_incr_word_p;
        disable iff(!HRESETN)
        @(posedge HCLK) (HBURST[0] && HSIZE == `WORD && HTRANS == `NONSEQ) |=> (HTRANS == `SEQ) |-> (HADDR == $past(HADDR)+4)  until (HTRANS == `NONSEQ); 
    endproperty

    ahb_addr_incr_word_chk: assert property (addr_incr_word_p)
      $display("@[%0t][ASSERT][AHB Address INCR Word CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Address INCR Word CHK] Assertion Failed", $time);

    property addr_incr_halfword_p;
        disable iff(!HRESETN)
        @(posedge HCLK) (HBURST[0] && HSIZE == `HALFWORD && HTRANS == `NONSEQ) |=> (HTRANS == `SEQ) |-> (HADDR == $past(HADDR)+2)  until (HTRANS == `NONSEQ);  
    endproperty

    ahb_addr_incr_halfword_chk: assert property (addr_incr_halfword_p)
      $display("@[%0t][ASSERT][AHB Address INCR Halfword CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Address INCR Halfword CHK] Assertion Failed", $time);

    property addr_incr_byte_p;
        disable iff(!HRESETN)
        @(posedge HCLK) (HBURST[0] && HSIZE == `BYTE && HTRANS == `NONSEQ) |=> (HTRANS == `SEQ) |-> (HADDR == $past(HADDR)+1)  until (HTRANS == `NONSEQ);  
    endproperty

    ahb_addr_incr_byte_chk: assert property (addr_incr_byte_p)
      $display("@[%0t][ASSERT][AHB Address INCR Byte CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Address INCR Byte CHK] Assertion Failed", $time);

*/


/*

    //-----------------------------------------------------------------//
    //-------------------ahb_read_data_chk ----------------------//
    //----> It checks at every posedge of HCLK if,
    //--- If, HSIZE == `WORD & HWRITE == `LOW: HRDATA changes at every clock cycle.
    //--- If, HSIZE == `HALFWORD & HWRITE == `LOW: HRDATA changes at every two clock cycles.
    //--- If, HSIZE == `BYTE & HWRITE == `LOW: HRDATA changes  at every four clock cycles.
    //----> Does not check if HRESET is low.
    //-----------------------------------------------------------------//

    property read_word_p;
        disable iff(!HRESETN)
        @(posedge HCLK) (HWRITE == 0 && HSIZE == `WORD && (HADDR%4 == 0));
    endproperty

    ahb_read_word_chk: assert property (read_word_p)
      $display("@[%0t][ASSERT][AHB Read Word CHK] Assertion Passed", $time);
      else $display("@[%0t][ASSERT][AHB Read Word CHK] Assertion Failed", $time);

*/

  `endif

    //---------------------------------------------------------------------------------------------------------------------------









suppose i have a define : 

`define u_aword(i) u_phychn_inst_``i``__phy_chn_en_u_aword 

and i have a loop like this : 

generate;
    for(chrw_idx; chrw_idx<N; chrw_idx++) begin : aw_chrw_idx
        $sdf_annotate("SDF_FILE_PATH", `u_aword(chrw_idx), "logfile.log", "SDF_TIMING")
    end
endgenerate

now the path sould be : 
u_phychn_inst_0__phy_chn_en_u_aword
u_phychn_inst_1__phy_chn_en_u_aword

but i am getting an error and path is being like this : 

u_phychn_inst_chrw_idx__phy_chn_en_u_aword


whats the issue here?





























/*

    // Custom Signals for Assertion Practice //
    logic a = 0;
    logic b = 0;
    logic c = 1;
    logic d = 1;
    logic e = 0;
    
    // Required Signals Generation //
    always@(negedge HCLK) begin
        a = 0;
        @(negedge HCLK);
        a = 1;
        d = 0;
        repeat(2) @(negedge HCLK);
        b = 1;
        d = 1;
        repeat(2) @(negedge HCLK);
        b = 0;
        e = 0;
        @(negedge HCLK);
        e = 1;
        @(negedge HCLK);
        c = 0;
        d = 0;
        e = 0;
        @(negedge HCLK);
        c = 1;
        e = 1;
    end



    //------------------------------------------------------------------------------------------------//
    //---------------------------------- CONCURRENT ASSERTIONS ---------------------------------------//
    //------------------------------------------------------------------------------------------------//


    //---------------------------- Simple Sequence---------------------------//
    // Check if HRESP is Zero at every clock cycle //
    sequence hresp_seq;
        @(posedge HCLK) !HRESP;
    endsequence
    
    property hresp_prop; 
        hresp_seq;
    endproperty
    
 //   hresp_chk: assert property (hresp_prop)
 //       $display("@[%0t][ASSERT][HRESP] Assertion Passed", $time);
  //      else $display("@[%0t][ASSERT][HRESP] Assertion Failed", $time);

    //------------------- Sequence with edge definitions and logical relationships-----------------//
    // Check if Hready is stable throughout the simulation //
    sequence hready_seq;
        @(posedge HCLK) $stable(HREADY);
    endsequence
    
    property hready_prop; 
        hready_seq;
    endproperty
    
 //   hready_chk: assert property (hready_prop)
  //      $display("@[%0t][ASSERT][HREADY] Assertion Passed", $time);
   //     else $display("@[%0t][ASSERT][HREADY] Assertion Failed", $time);

    // Check at every clk edge HSEL rose/stable and HWRITE rose/fall from zero to one together or not //
    sequence hsel_hwrite_seq;
        @(posedge HCLK) (($rose(HSEL) || $stable(HSEL)) && ($rose(HWRITE) || $fell(HWRITE)));
    endsequence

    
    property hsel_hwrite_prop; 
        hsel_hwrite_seq;
    endproperty
    
  //  hsel_hwrite_chk: assert property (hsel_hwrite_prop)
   //     $display("@[%0t][ASSERT][HSEL/HWRITE] Assertion Passed", $time);
    //    else $display("@[%0t][ASSERT][HSEL/HWRITE] Assertion Failed", $time);

    //--------------------- Sequence Expressions ----------------------------------------//
    // Sequence to check stabe value //
    sequence stable_seq(in);
        @(posedge HCLK) $stable(in);
    endsequence

    // reuse of the sequence //
    sequence stable_seq_hready;
        stable_seq(HREADY);
    endsequence

    sequence stable_seq_hresp;
        stable_seq(HRESP);
    endsequence
    
    property stable_prop_hready;
       stable_seq_hready;    
    endproperty

    property stable_prop_hresp;
       stable_seq_hresp;    
    endproperty

  //  stable_hready_chk: assert property (stable_prop_hready)
  //      $display("@[%0t][ASSERT][STABLE] Assertion Passed", $time);
   //     else $display("@[%0t][ASSERT][STABLE] Assertion Failed", $time);

  //  stable_hresp_chk: assert property (stable_prop_hresp)
   //     $display("@[%0t][ASSERT][STABLE] Assertion Passed", $time);
    //    else $display("@[%0t][ASSERT][STABLE] Assertion Failed", $time);



    //--------------------- Sequence with timing Relationship ----------------------------------------//
    
    // Assertion to Check at every clock cycle,
    // if a is low then follow the sequence: 
    // a becomes high after one clock cycle
    // b becomes high after two clock cycles
    // b becomes low after three clock cycles
    // c becomes low after one clock cycle
    // c becomes high after one clock cycle
    sequence abc_seq;
        !a ##1 a ##2 b ##3 !b ##1 !c ##1 c;    
    endsequence

    property abc_prop;
        @(posedge HCLK) if(!a) abc_seq;
    endproperty
  
  //  abc_chk: assert property (abc_prop)
 //       $display("@[%0t][ASSERT][ABC] Assertion Passed", $time);
  //      else $display("@[%0t][ASSERT][ABC] Assertion Failed", $time);  

    //--------------------- Forbiding Sequence ----------------------------------------//
    sequence ab_forbid_seq;
         a ##1 b;    
    endsequence

    property ab_forbid_prop;
        @(posedge HCLK) if($rose(a)) not ab_forbid_seq;
    endproperty
  
 //   ab_forbid_chk: assert property (ab_forbid_prop)
  //      $display("@[%0t][ASSERT][AB_FORBID] Assertion Passed", $time);
  //      else $display("@[%0t][ASSERT][AB_FORBID] Assertion Failed", $time);  

    //--------------- Implication Operator -------------------------------------------------//
    // ------ Overlapped Implication ---------------------------------------------- //
    property cd_ovrlapped_imp_prop1;
        @(posedge HCLK) !c |-> !d;    
    endproperty

  //  cd_overlapped_imp_chk1: assert property (cd_ovrlapped_imp_prop1)
    //    $display("@[%0t][ASSERT][AB_FORBID] Assertion Passed", $time);
    //    else $display("@[%0t][ASSERT][AB_FORBID] Assertion Failed", $time); 


    property cd_ovrlapped_imp_prop2;
        @(posedge HCLK) !c ##0 !d;
    endproperty

  //  cd_overlapped_imp_chk2: assert property (cd_ovrlapped_imp_prop2)
     //   $display("@[%0t][ASSERT][AB_FORBID] Assertion Passed", $time);
     //   else $display("@[%0t][ASSERT][AB_FORBID] Assertion Failed", $time); 


    property cd_ovrlapped_imp_prop3;
        @(posedge HCLK) !c |-> ##0 !d;
    endproperty

  //  cd_overlapped_imp_chk3: assert property (cd_ovrlapped_imp_prop3)
     //   $display("@[%0t][ASSERT][AB_FORBID] Assertion Passed", $time);
    //    else $display("@[%0t][ASSERT][AB_FORBID] Assertion Failed", $time); 



    // ----------------------- Non-Overlapped Implication ------------------------------- //
    property de_non_ovrlapped_imp_prop1;
        @(posedge HCLK) e |=> !(d && e) |=> e;    
    endproperty

    de_non_overlapped_imp_chk1: assert property (de_non_ovrlapped_imp_prop1)
        $display("@[%0t][ASSERT][] Assertion Passed", $time);
        else $display("@[%0t][ASSERT][] Assertion Failed", $time); 


    property de_non_ovrlapped_imp_prop2;
        @(posedge HCLK) e ##1 !(d && e) ##1 e;    
    endproperty

    de_non_overlapped_imp_chk2: assert property (de_non_ovrlapped_imp_prop2)
        $display("@[%0t][ASSERT][] Assertion Passed", $time);
        else $display("@[%0t][ASSERT][] Assertion Failed", $time); 


    property de_non_ovrlapped_imp_prop3;
        @(posedge HCLK) e |=> ##0 !(d && e) |=> ##0 e;    
    endproperty

    de_non_overlapped_imp_chk3: assert property (de_non_ovrlapped_imp_prop3)
        $display("@[%0t][ASSERT][] Assertion Passed", $time);
        else $display("@[%0t][ASSERT][] Assertion Failed", $time);

    // --------------------- Implication with sequence as antecedent ---------------------- //
    sequence ab_sequence;
        @(posedge HCLK) a ##2 b;
    endsequence 
  
    sequence de_sequence;
         @(posedge HCLK) e ##3 !(d && e) ##1 e; 
    endsequence  

    property abde_imp_prop;
        ab_sequence |->  de_sequence;
    endproperty

    property abde_imp_prop2;
        ab_sequence |->  de_sequence;
    endproperty


    abde_imp_chk: assert property (abde_imp_prop)
        $display("@[%0t][ASSERT][] Assertion Passed", $time);
        else $display("@[%0t][ASSERT][] Assertion Failed", $time);


    abde_imp_chk2: assert property (abde_imp_prop2)
        $display("@[%0t][ASSERT][] Assertion Passed", $time);
        else $display("@[%0t][ASSERT][] Assertion Failed", $time);

*/

  
endinterface
