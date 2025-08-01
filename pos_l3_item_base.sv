`ifndef POS_L3_ITEM_BASE_SV
  `define POS_L3_ITEM_BASE_SV

  class pos_l3_item_base extends uvm_sequence_item;

	/*bit txdfifo_rempty ;*/
	bit txdfifo_ren ;
	bit txdfifo_rempty ;
	
	`uvm_object_utils(pos_l3_item_base)

    function new(string name = "");
      super.new(name);
    endfunction
    
  endclass
`endif	
