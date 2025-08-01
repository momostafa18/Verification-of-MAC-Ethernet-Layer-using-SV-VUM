`ifndef XGMII_SEQUENCE_IDLE_SV
  `define XGMII_SEQUENCE_IDLE_SV

  class xgmii_sequence_idle extends xgmii_sequence_base;

    xgmii_item_drv item ;

    `uvm_object_utils(xgmii_sequence_idle)
    
    function new(string name = "");
      super.new(name);
      item = xgmii_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
     start_item(item);
	 idle_drive();
	 finish_item(item);

  endtask
  
  task idle_drive();
		item.xgmii_rxc <= 8'hff;
		item.xgmii_rxd <= 64'h0707070707070707; // IDLE codes
	  
  endtask

  endclass
`endif	


