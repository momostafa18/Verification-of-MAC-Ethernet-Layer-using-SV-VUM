`ifndef WISHBONE_REG_ADAPTER_SV
  `define WISHBONE_REG_ADAPTER_SV

  class wishbone_reg_adapter extends uvm_reg_adapter;
    
    `uvm_object_utils(wishbone_reg_adapter)
    
    function new(string name = "");
      super.new(name);  
    endfunction
    
    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      wishbone_item_mon item_mon;
	  wishbone_item_drv item_drv;
      
      if($cast(item_mon, bus_item)) begin
        rw.kind 	= item_mon.wb_we_o == 1 ? UVM_WRITE : UVM_READ;
        
        rw.addr   	= item_mon.wb_adr_o;
        rw.data   	= item_mon.wb_dat_o;
      end
	  else if($cast(item_drv, bus_item)) begin
        rw.kind 	= item_drv.wb_we_i == 1 ? UVM_WRITE : UVM_READ;
        
        rw.addr   	= item_drv.wb_adr_i;
        rw.data   	= item_drv.wb_dat_i;
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Class not supported: %0s", bus_item.get_type_name()))
      end
      
    endfunction
    
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
      wishbone_item_drv item = wishbone_item_drv::type_id::create("item");
      
      void'(item.randomize() with {
        item.wb_we_i  == (rw.kind == UVM_WRITE) ? 1 : 0;
        item.wb_dat_i == rw.data;
        item.wb_adr_i == rw.addr;
      });
      
      return item;
    endfunction
    
  endclass

`endif