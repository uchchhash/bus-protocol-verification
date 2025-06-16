

package spi_reg_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

   /* DEFINE REGISTER CLASSES */

   //--------------------------------------------------------------------
   // Class: rxtx0_reg
   // 
   // RXTX0
   //--------------------------------------------------------------------

    class rxtx0_reg extends uvm_reg;

        rand uvm_reg_field F;

        virtual function void build();
            F = uvm_reg_field::type_id::create("F");
            F.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
        endfunction

        `uvm_register_cb(rxtx0_reg, uvm_reg_cbs) 
        `uvm_set_super_type(rxtx0_reg, uvm_reg)
        `uvm_object_utils(rxtx0_reg)

        function new(input string name="rxtx0_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction : new

    endclass : rxtx0_reg

   //--------------------------------------------------------------------
   // Class: rxtx1_reg
   // 
   // RXTX1
   //--------------------------------------------------------------------

    class rxtx1_reg extends uvm_reg;

        rand uvm_reg_field F;

        virtual function void build();
            F = uvm_reg_field::type_id::create("F");
            F.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
        endfunction

        `uvm_register_cb(rxtx1_reg, uvm_reg_cbs) 
        `uvm_set_super_type(rxtx1_reg, uvm_reg)
        `uvm_object_utils(rxtx1_reg)

        function new(input string name="rxtx1_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction : new
    
    endclass : rxtx1_reg


   //--------------------------------------------------------------------
   // Class: rxtx2_reg
   // 
   // RXTX2
   //--------------------------------------------------------------------

   class rxtx2_reg extends uvm_reg;

        rand uvm_reg_field F;

        virtual function void build();
            F = uvm_reg_field::type_id::create("F");
            F.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
        endfunction

        `uvm_register_cb(rxtx2_reg, uvm_reg_cbs) 
        `uvm_set_super_type(rxtx2_reg, uvm_reg)
        `uvm_object_utils(rxtx2_reg)

        function new(input string name="rxtx2_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction : new

    endclass : rxtx2_reg



   //--------------------------------------------------------------------
   // Class: rxtx3_reg
   // 
   // RXTX3
   //--------------------------------------------------------------------

    class rxtx3_reg extends uvm_reg;

        rand uvm_reg_field F;

        virtual function void build();
            F = uvm_reg_field::type_id::create("F");
            F.configure(this, 32, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
        endfunction

        `uvm_register_cb(rxtx3_reg, uvm_reg_cbs) 
        `uvm_set_super_type(rxtx3_reg, uvm_reg)
        `uvm_object_utils(rxtx3_reg)

        function new(input string name="rxtx3_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction : new

    endclass : rxtx3_reg
    


   //--------------------------------------------------------------------
   // Class: divider_reg
   // 
   // Divider
   //--------------------------------------------------------------------


    class divider_reg extends uvm_reg;

        rand uvm_reg_field ratio;
        rand uvm_reg_field reserved;

        virtual function void build();
            ratio = uvm_reg_field::type_id::create("ratio");
            ratio.configure(this, 16, 0, "RW", 0, 16'hFFFF, 1, 1, 1);
            reserved = uvm_reg_field::type_id::create("reserved");
            reserved.configure(this, 16, 16, "RO", 0, 16'h0000, 1, 1, 1);
        endfunction
           
        `uvm_register_cb(divider_reg, uvm_reg_cbs) 
        `uvm_set_super_type(divider_reg, uvm_reg)
        `uvm_object_utils(divider_reg)

        function new(input string name="divider_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction : new

    endclass : divider_reg

   //--------------------------------------------------------------------
   // Class: ss_reg
   // 
   // Status
   //--------------------------------------------------------------------


    class ss_reg extends uvm_reg;

        rand uvm_reg_field cs;
        rand uvm_reg_field reserved;

        virtual function void build();
            cs = uvm_reg_field::type_id::create("cs");
            cs.configure(this, 8, 0, "RW", 1, 8'h00, 1, 1, 1);
            reserved = uvm_reg_field::type_id::create("reserved");
            reserved.configure(this, 24, 8, "RO", 0, 24'h0000, 1, 1, 1);
        endfunction

        `uvm_register_cb(ss_reg, uvm_reg_cbs) 
        `uvm_set_super_type(ss_reg, uvm_reg)
        `uvm_object_utils(ss_reg)

        function new(input string name="ss_reg");
            super.new(name, 32, UVM_NO_COVERAGE);
        endfunction : new
    endclass : ss_reg




   //--------------------------------------------------------------------
   // Class: ctrl_reg
   // 
   // Control Status Register
   //--------------------------------------------------------------------

    class ctrl_reg extends uvm_reg;

        rand uvm_reg_field char_len;
        rand uvm_reg_field reserved;
        rand uvm_reg_field reserved2;
        rand uvm_reg_field go_bsy;
        rand uvm_reg_field rx_neg;
        rand uvm_reg_field tx_neg;
        rand uvm_reg_field lsb;
        rand uvm_reg_field ie;
        rand uvm_reg_field ass;

        virtual function void build();
            char_len = uvm_reg_field::type_id::create("char_len");
            char_len.configure(this, 7, 0, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>0, 1, 1, 1);
            reserved2 = uvm_reg_field::type_id::create("reserved2");
            reserved2.configure(this, 1, 7, "RO", 0, 1'b0, 1, 1, 1);
            go_bsy = uvm_reg_field::type_id::create("go_bsy");
            go_bsy.configure(this, 1, 8, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>8, 1, 1, 1);
            rx_neg = uvm_reg_field::type_id::create("rx_neg");
            rx_neg.configure(this, 1, 9, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>9, 1, 1, 1);
            tx_neg = uvm_reg_field::type_id::create("tx_neg");
            tx_neg.configure(this, 1, 10, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>10, 1, 1, 1);
            lsb = uvm_reg_field::type_id::create("lsb");
            lsb.configure(this, 1, 11, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>11, 1, 1, 1);
            ie = uvm_reg_field::type_id::create("ie");
            ie.configure(this, 1, 12, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>12, 1, 1, 1);
            ass = uvm_reg_field::type_id::create("ass");
            ass.configure(this, 1, 13, "RW", 0, `UVM_REG_DATA_WIDTH'h0>>13, 1, 1, 1);
            reserved = uvm_reg_field::type_id::create("reserved");
            reserved.configure(this, 18, 14, "RO", 0, 32'h00, 1, 1, 1);
            //wr_cg.set_inst_name($sformatf("%s.wcov", get_full_name()));
            //rd_cg.set_inst_name($sformatf("%s.rcov", get_full_name()));
        endfunction
/*
        covergroup wr_cg;
            option.per_instance=1;
            char_len : coverpoint char_len.value[6:0];
            go_bsy : coverpoint go_bsy.value[0:0];
            rx_neg : coverpoint rx_neg.value[0:0];
            tx_neg : coverpoint tx_neg.value[0:0];
            lsb : coverpoint lsb.value[0:0];
            ie : coverpoint ie.value[0:0];
            ass : coverpoint ass.value[0:0];
        endgroup

        covergroup rd_cg;
            option.per_instance=1;
            char_len : coverpoint char_len.value[6:0];
            go_bsy : coverpoint go_bsy.value[0:0];
            rx_neg : coverpoint rx_neg.value[0:0];
            tx_neg : coverpoint tx_neg.value[0:0];
            lsb : coverpoint lsb.value[0:0];
            ie : coverpoint ie.value[0:0];
            ass : coverpoint ass.value[0:0];
        endgroup

        protected virtual function void sample(uvm_reg_data_t  data, byte_en, bit is_read, uvm_reg_map map);
            super.sample(data, byte_en, is_read, map);
            if(!is_read) wr_cg.sample();
            if(is_read) rd_cg.sample();
        endfunction
*/
        `uvm_register_cb(ctrl_reg, uvm_reg_cbs) 
        `uvm_set_super_type(ctrl_reg, uvm_reg)
        `uvm_object_utils(ctrl_reg)

        function new(input string name="ctrl_reg");
            super.new(name, 32, build_coverage(UVM_CVR_FIELD_VALS));
           // wr_cg=new;
           // rd_cg=new;
        endfunction : new

    endclass : ctrl_reg


   /* BLOCKS */

   //--------------------------------------------------------------------
   // Class: spi_reg_block
   // 
   //--------------------------------------------------------------------

	class spi_reg_block extends uvm_reg_block;

		rand rxtx0_reg rxtx0; // RXTX0
		rand rxtx1_reg rxtx1; // RXTX1
		rand rxtx2_reg rxtx2; // RXTX2
		rand rxtx3_reg rxtx3; // RXTX3
		rand ctrl_reg ctrl; // Control Status Register
		rand divider_reg divider; // Divider
		rand ss_reg ss; // Status
		uvm_reg_map spi_reg_block_map;

		`uvm_object_utils(spi_reg_block)
		
		function new(input string name="spi_reg_block");
			super.new(name, build_coverage(UVM_CVR_ADDR_MAP));
		endfunction : new
		
		
		virtual function void build();  

			// Now create all registers
			rxtx0 = rxtx0_reg::type_id::create("rxtx0", , get_full_name());
			rxtx1 = rxtx1_reg::type_id::create("rxtx1", , get_full_name());
			rxtx2 = rxtx2_reg::type_id::create("rxtx2", , get_full_name());
			rxtx3 = rxtx3_reg::type_id::create("rxtx3", , get_full_name());
			ctrl = ctrl_reg::type_id::create("ctrl", , get_full_name());
			divider = divider_reg::type_id::create("divider", , get_full_name());
			ss = ss_reg::type_id::create("ss", , get_full_name());

			// Now build the registers. Set parent and hdl_paths
			rxtx0.configure(this, null, "");
			rxtx0.build();
			rxtx0.add_hdl_path_slice("rx", 0, 32);

			rxtx1.configure(this, null, "");
			rxtx1.build();
			rxtx1.add_hdl_path_slice("rx", 32, 32);


			rxtx2.configure(this, null, "");
			rxtx2.build();
			rxtx2.add_hdl_path_slice("rx", 64, 32);

			rxtx3.configure(this, null, "");
			rxtx3.build();
			rxtx3.add_hdl_path_slice("rx", 0, 96, 32);

			ctrl.configure(this, null, "");
			ctrl.build();
			ctrl.add_hdl_path_slice("ctrl", 0, ctrl.get_n_bits());

			divider.configure(this, null, "");
			divider.build();
			divider.add_hdl_path_slice("divider", 0, divider.get_n_bits());

			ss.configure(this, null, "");
			ss.build();
			ss.add_hdl_path_slice("ss", 0, ss.get_n_bits());

			// Now define address mappings
			spi_reg_block_map = create_map("spi_reg_block_map", 0, 4, UVM_LITTLE_ENDIAN, 1);
			default_map = spi_reg_block_map;

			spi_reg_block_map.add_reg(rxtx0, `UVM_REG_ADDR_WIDTH'h0, "RW");
			spi_reg_block_map.add_reg(rxtx1, `UVM_REG_ADDR_WIDTH'h4, "RW");
			spi_reg_block_map.add_reg(rxtx2, `UVM_REG_ADDR_WIDTH'h8, "RW");
			spi_reg_block_map.add_reg(rxtx3, `UVM_REG_ADDR_WIDTH'hc, "RW");
			spi_reg_block_map.add_reg(ctrl, `UVM_REG_ADDR_WIDTH'h10, "RW");
			spi_reg_block_map.add_reg(divider, `UVM_REG_ADDR_WIDTH'h14, "RW");
			spi_reg_block_map.add_reg(ss, `UVM_REG_ADDR_WIDTH'h18, "RW");
			add_hdl_path("hdl_top.DUT");
			lock_model();
		endfunction


	endclass : spi_reg_block

endpackage

