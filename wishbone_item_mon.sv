`ifndef WISHBONE_ITEM_Monitoring_SV
  `define WISHBONE_ITEM_Monitoring_SV

  class wishbone_item_mon extends wishbone_item_base;

	`uvm_object_utils(wishbone_item_mon)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
  endclass
`endif	

