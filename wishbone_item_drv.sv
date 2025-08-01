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
    
  endclass
`endif	

