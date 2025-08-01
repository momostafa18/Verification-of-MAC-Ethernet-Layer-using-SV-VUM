`ifndef XGMII_SEQUENCE_SIMPLE_SV
  `define XGMII_SEQUENCE_SIMPLE_SV

  class xgmii_sequence_simple extends xgmii_sequence_base;

    rand xgmii_item_drv item;
    
    `uvm_object_utils(xgmii_sequence_simple)
    
    function new(string name = "");
      super.new(name);
      
     item = xgmii_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
     start_item(item);
	 finish_item(item);

  endtask

  endclass
`endif	

