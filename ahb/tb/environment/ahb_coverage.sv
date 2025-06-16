class ahb_coverage extends uvm_subscriber #(ahb_sequence_item);

    `uvm_component_utils(ahb_coverage)
    uvm_analysis_imp #(ahb_sequence_item, ahb_coverage) analysis_imp_mntr2cov;
    ahb_sequence_item t;

    /*

    covergroup ahb_cov  with function sample(ahb_sequence_item t);
        option.per_instance = 1;
        hready_cov : coverpoint t.hready {bins hready_high = {1};
        ignore_bins hready_low = {0};} 
        hresp_cov: coverpoint t.hresp { bins OKAY = {0};
        ignore_bins ERROR = {1};
        ignore_bins RETRY = {2};
        ignore_bins IDLE = {3};}

        sel_cov     : coverpoint t.hselx       {bins select_high = {1}; 
                                                bins select_low = {0};}

        reset_cov   : coverpoint t.hresetn    {bins reset_high = {0}; 
                                                bins reset_low = {1};}

        hwrite_cov   : coverpoint t.hwrite     {bins write = {1}; 
                                                bins read = {0};}


        trans_cov : coverpoint t.htrans {ignore_bins idle = {0};
                                        ignore_bins busy = {1};
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

        address_cov : coverpoint t.start_address {bins range [2]={[0:$]};}    


        wdata_cov   : coverpoint t.write_data {bins range [2]={[0:$]};}    
                                                                          

        rdata_cov   : coverpoint t.read_data  {bins range [2]={[0:$]};} 

    endgroup

    */

    function new(string name= "ahb_coverage", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(),"==== AHB 'Coverage' Constructed ====", UVM_MEDIUM);
        //ahb_cov = new();
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "AHB Coverage 'Build Phase' Started", UVM_MEDIUM);
        analysis_imp_mntr2cov = new("analysis_imp_mntr2cov", this);
        t = ahb_sequence_item::type_id::create("t", this);
    endfunction

    function void write(ahb_sequence_item t);
        `uvm_info (get_type_name(), ">>>>> Coverage Got Transaction From Monitor <<<<<", UVM_HIGH);
      //  ahb_cov.sample(t);
    endfunction



endclass
