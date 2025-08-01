`ifndef POS_L3_INTERFACE_SV
  `define POS_L3_INTERFACE_SV
  
interface pos_l3_if;
   
    logic        clk_156m25; 
	logic        reset_156m25_n;
   
   //------------------------ Outputs ---------------------//
	logic        rxdfifo_ren;
   
	logic [63:0] pkt_rx_data;
	logic        pkt_rx_val;
	logic        pkt_rx_sop;
	logic        pkt_rx_eop;
	logic        pkt_rx_err;
	logic [2:0]  pkt_rx_mod;
	logic        pkt_rx_avail;
	logic        pkt_tx_full;

	logic        status_rxdfifo_udflow_tog;
	
	//------------------------ Inputs ---------------------//

	logic [63:0] pkt_tx_data; 
	logic        pkt_tx_val;
	logic        pkt_tx_sop; 
	logic 		 pkt_tx_eop; 
	logic [2:0]  pkt_tx_mod; 
	logic	     txdfifo_wfull; 
	logic 		 txdfifo_walmost_full;
	logic        pkt_rx_ren ;
	
	
	/*logic 		 txdfifo_rempty ;*/
	bit        txdfifo_ren;
	bit 	   txdfifo_rempty;
	
  //clock generation
  initial begin
    clk_156m25 = 0 ;
    
    forever begin
     
      clk_156m25 = #3.2ns ~clk_156m25 ; 
	
	end
   end
   

endinterface


`endif