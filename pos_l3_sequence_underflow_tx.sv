
`ifndef POS_L3_SEQUENCE_UNDERFLOW_TX_SV
  `define POS_L3_SEQUENCE_UNDERFLOW_TX_SV

  class pos_l3_sequence_underflow_tx extends pos_l3_sequence_base;
    
	rand pos_l3_item_drv item;
    
    `uvm_object_utils(pos_l3_sequence_underflow_tx)
    
    function new(string name = "");
      super.new(name);
	  
	  item = pos_l3_item_drv::type_id::create("item");
    endfunction
   
  //Body Task
  task body;

     start_item(item);
	 item.txdfifo_ren       = 1 ;
	 item.txdfifo_rempty    = 1 ;
	 finish_item(item);
	 
	 
    endtask
    
    

  endclass
`endif	
