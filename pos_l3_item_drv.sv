`ifndef POS_L3_ITEM_DRIVING_SV
  `define POS_L3_ITEM_DRIVING_SV

  class pos_l3_item_drv extends pos_l3_item_base;

	
	bit        pkt_tx_val;
	bit        pkt_tx_sop; 
	bit 	   pkt_tx_eop; 
	bit [2:0]  pkt_tx_mod; 


	bit [63:0]  rxdfifo_rdata;
	bit [7:0]   rxdfifo_rstatus;
	bit         rxdfifo_rempty;
	bit         rxdfifo_ralmost_empty;

	rand bit         pkt_rx_ren;

	`uvm_object_utils(pos_l3_item_drv)
    
    function new(string name = "");
      super.new(name);

    endfunction
    
  endclass
`endif	
