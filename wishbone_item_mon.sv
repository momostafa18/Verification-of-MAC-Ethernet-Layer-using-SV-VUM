`ifndef WISHBONE_ITEM_Monitoring_SV
  `define WISHBONE_ITEM_Monitoring_SV

  class wishbone_item_mon extends wishbone_item_base;

	 bit  [7:0]  wb_adr_o;
	 bit  [31:0] wb_dat_o;
	 bit         wb_we_o;

	`uvm_object_utils(wishbone_item_mon)
    
    function new(string name = "");
      super.new(name);
    endfunction
	
	virtual function string convert2string();

      return $sformatf("[%0t] data: %0x, address: %0d, dir: %0d",
						$time, wb_dat_o, wb_adr_o, wb_we_o);
    endfunction
    
  endclass
`endif	

