`ifndef XGMII_ITEM_BASE_SV
  `define XGMII_ITEM_BASE_SV

  class xgmii_item_base extends uvm_sequence_item;

	`uvm_object_utils(xgmii_item_base)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
  endclass
`endif	

