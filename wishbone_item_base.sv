`ifndef WISHBONE_ITEM_BASE_SV
  `define WISHBONE_ITEM_BASE_SV

  class wishbone_item_base extends uvm_sequence_item;

	`uvm_object_utils(wishbone_item_base)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
  endclass
`endif	

