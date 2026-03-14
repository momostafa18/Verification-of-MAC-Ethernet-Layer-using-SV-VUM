`ifndef POS_L3_ITEM_BASE_SV
  `define POS_L3_ITEM_BASE_SV

  class pos_l3_item_base extends uvm_sequence_item;

	bit        pkt_tx_val;
	bit        pkt_tx_sop; 
	bit 	   pkt_tx_eop; 
	bit [2:0]  pkt_tx_mod; 
	bit [63:0] pkt_tx_data;
	
	
	/*bit txdfifo_rempty ;*/
	bit txdfifo_ren ;
	bit txdfifo_rempty ;
	
	`uvm_object_utils(pos_l3_item_base)

    function new(string name = "");
      super.new(name);
    endfunction
    
  endclass
`endif	
