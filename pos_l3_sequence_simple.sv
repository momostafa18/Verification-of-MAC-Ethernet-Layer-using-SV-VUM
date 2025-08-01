`ifndef POS_L3_SEQUENCE_SIMPLE_SV
  `define POS_L3_SEQUENCE_SIMPLE_SV

  class pos_l3_sequence_simple extends pos_l3_sequence_base;

    rand pos_l3_item_drv item;
	
	bit pkt_tx_val = 1 ;
    
    `uvm_object_utils(pos_l3_sequence_simple)
    
    function new(string name = "");
      super.new(name);
      
     item = pos_l3_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
     start_item(item);
	 item.pkt_tx_val 	 = pkt_tx_val ;
	 /*item.txdfifo_rempty = 1 ;*/
	 item.txdfifo_ren    = 1 ;
	 finish_item(item);

  endtask

  endclass
`endif	
