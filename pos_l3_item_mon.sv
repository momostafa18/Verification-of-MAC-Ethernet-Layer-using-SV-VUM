`ifndef POS_L3_ITEM_Monitoring_SV
  `define POS_L3_ITEM_Monitoring_SV

  class pos_l3_item_mon extends pos_l3_item_base;

	logic        pkt_tx_full; 
	logic        pkt_rx_ren ;
	logic [63:0] txdfifo_wdata; 
	logic [7:0]  txdfifo_wstatus; 
	logic        txdfifo_wen; 
    logic        status_txdfifo_ovflow_tog; 
	logic        rxdfifo_ren;
	
	logic [63:0] pkt_rx_data;
	logic        pkt_rx_val;
	logic        pkt_rx_sop;
	logic        pkt_rx_eop;
	logic        pkt_rx_err;
	logic [2:0]  pkt_rx_mod;
	logic        pkt_rx_avail;

	logic        status_rxdfifo_udflow_tog;
	logic	     txdfifo_wfull; 
	logic 		 txdfifo_walmost_full;

	`uvm_object_utils(pos_l3_item_mon)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
  endclass
`endif	
