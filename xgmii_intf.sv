`ifndef XGMII_INTERFACE_SV
  `define XGMII_INTERFACE_SV
  
interface xgmii_if;
          
	logic clk_xgmii_tx ;
	logic reset_xgmii_tx_n ;

	logic clk_xgmii_rx ;
	logic reset_xgmii_rx_n ;	
		  
    logic [63:0] xgmii_txd ;           
    logic [7:0]  xgmii_txc ;  

	logic [63:0] xgmii_rxd ;           
    logic [7:0]  xgmii_rxc ; 	

   initial begin
    clk_xgmii_tx = 0 ;
    
    forever begin
     
      clk_xgmii_tx = #3.2ns ~clk_xgmii_tx ; 
	
	end
   end


  initial begin
    clk_xgmii_rx = 0 ;
    
    forever begin
     
      clk_xgmii_rx = #3.2ns ~clk_xgmii_rx ; 
	
	end
   end   

endinterface


`endif
