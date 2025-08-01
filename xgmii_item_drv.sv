`ifndef XGMII_ITEM_DRIVING_SV
  `define XGMII_ITEM_DRIVING_SV

  class xgmii_item_drv extends xgmii_item_base;

	
	rand bit [63:0] xgmii_rxd ;           
    rand bit [7:0]  xgmii_rxc ; 
	rand bit [47:0] DA;
	rand bit [47:0] SA;
	rand bit [15:0] type_len;
	
	constraint valid_type_len {
	(type_len inside {[46:1500]}) || (type_len >= 1536);
}
	
	
	`uvm_object_utils(xgmii_item_drv)
    
    function new(string name = "");
      super.new(name);

    endfunction
    
  endclass
`endif	

