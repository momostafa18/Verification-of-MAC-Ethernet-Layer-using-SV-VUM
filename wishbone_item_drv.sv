`ifndef WISHBONE_ITEM_DRIVING_SV
  `define WISHBONE_ITEM_DRIVING_SV

  class wishbone_item_drv extends wishbone_item_base;


	rand bit  [7:0]  wb_adr_i;
	rand bit  [31:0] wb_dat_i;
	rand bit         wb_we_i;

	`uvm_object_utils(wishbone_item_drv)
    
    function new(string name = "");
      super.new(name);

    endfunction
	
	virtual function string convert2string();
        string result;

		if(wb_we_i)
		result = $sformatf("address: %0d , data: %0x , dir: %0d ", wb_adr_i, wb_dat_i,wb_we_i);
		else 
		result = $sformatf("address: %0d , dir: %0d ", wb_adr_i, wb_we_i);

        return result;
      endfunction
    
  endclass
`endif	

