class apb2reg_adapter extends uvm_reg_adapter;

    //---------- Factory Registration ----------//
    `uvm_object_utils(apb2reg_adapter)

    //---------- Constructor ----------//
    function new (string name = "apb2reg_adapter");
        super.new(name);
        supports_byte_enable = 1;
        provides_responses = 0;
    endfunction: new

    //---------- reg2bus ----------//
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        apb_sequence_item apb_item;
       //`uvm_info(get_type_name(), "<<----- APB2REG Adapter 'reg2bus' method called ----->>", UVM_LOW);
        apb_item = apb_sequence_item::type_id::create("apb_item");
        apb_item.pwrite = (rw.kind == UVM_READ) ? 1'b0:1'b1;
        if(rw.kind == UVM_READ) begin
          apb_item.read_addr = rw.addr;
          apb_item.read_data = rw.data;
         // `uvm_info(get_type_name, $sformatf("[<- reg2bus ->] PWRITE = %0d || RADDR = %0h, RDATA = %0h",  apb_item.pwrite, apb_item.read_addr, apb_item.read_data), UVM_LOW);
        end
        if(rw.kind != UVM_READ) begin
          apb_item.write_addr = rw.addr;
          apb_item.write_data = rw.data;
          //`uvm_info(get_type_name, $sformatf("[<- reg2bus ->] PWRITE = %0d || WADDR = %0h, WDATA = %0h", apb_item.pwrite, apb_item.write_addr, apb_item.write_data), UVM_LOW);
        end
        return apb_item;
    endfunction

    
    //---------- bus2reg ----------//
    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        apb_sequence_item apb_item;
       //`uvm_info(get_type_name(), "<<----- APB2REG Adapter 'bus2reg' method called ----->>", UVM_LOW);
        if (!$cast(apb_item, bus_item)) begin
            `uvm_fatal("NOT_BUS_TYPE","Provided bus_item is not of the correct type")
            return;
        end
        if(apb_item.pwrite == 1'b1) begin
            rw.kind = UVM_WRITE;
            rw.addr = apb_item.write_addr;
            rw.data = apb_item.write_data;
           // `uvm_info(get_type_name, $sformatf("[<- bus2reg ->] KIND = UVM_WRITE || BUS_ADDR = %0h, BUS_DATA = %0h || REG_ADDR = %0h, REG_DATA = %0h", apb_item.write_addr, apb_item.write_data, rw.addr, rw.data), UVM_LOW);
        end
        if(apb_item.pwrite == 1'b0) begin
            rw.kind = UVM_READ;
            rw.addr = apb_item.read_addr;
            rw.data = apb_item.read_data;
            //`uvm_info(get_type_name, $sformatf("[<- bus2reg ->] KIND = UVM_READ  || BUS_ADDR = %0h, BUS_DATA = %0h || REG_ADDR = %0h, REG_DATA = %0h", apb_item.read_addr, apb_item.read_data, rw.addr, rw.data), UVM_LOW);
        end
       rw.status = UVM_IS_OK;
    endfunction

endclass



