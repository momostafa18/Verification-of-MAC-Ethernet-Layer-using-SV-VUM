`ifndef XGMII_ITEM_MONITORING_SV
  `define XGMII_ITEM_MONITORING_SV

  class xgmii_item_mon extends xgmii_item_base;

	
	bit [63:0] xgmii_txd ;           
    bit [7:0]  xgmii_txc ;

	bit [31:0] crc_calculated; 
	bit [2:0]  crc_state;	
	
	bit [3:0]  crc_rx_state;
	bit [31:0] crc_rx_value;	
	
	`uvm_object_utils(xgmii_item_mon)
    
    function new(string name = "");
      super.new(name);

    endfunction
    
  endclass
`endif	


