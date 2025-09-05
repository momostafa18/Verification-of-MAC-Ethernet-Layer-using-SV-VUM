`ifndef XGMII_SEQUENCE_BASE_SV
  `define XGMII_SEQUENCE_BASE_SV

  class xgmii_sequence_base extends uvm_sequence#(xgmii_item_drv);

	rand xgmii_item_drv item ;

    `uvm_declare_p_sequencer(xgmii_sequencer)
    
    `uvm_object_utils(xgmii_sequence_base)
    
    function new(string name = "");
      	super.new(name);
		
		item = xgmii_item_drv::type_id::create("item");
     endfunction

	 
  endclass
`endif	

