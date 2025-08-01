`ifndef WISHBONE_INTERFACE_SV
  `define WISHBONE_INTERFACE_SV
  
interface wishbone_intf;
   
    logic         wb_clk_i;
	logic         wb_rst_i;

	logic  [7:0]  wb_adr_i;
	logic  [31:0] wb_dat_i;
	logic         wb_we_i;
	logic         wb_stb_i;
	logic         wb_cyc_i;

	logic [31:0]  wb_dat_o;
	logic         wb_ack_o;
	logic         wb_int_o;

	logic         status_crc_error;
	logic         status_fragment_error;
	   
	logic         status_txdfifo_ovflow;

	logic         status_txdfifo_udflow;

	logic         status_rxdfifo_ovflow;

	logic         status_rxdfifo_udflow;

	logic         status_pause_frame_rx;

	logic         status_local_fault;
	logic         status_remote_fault;

	logic        ctrl_tx_enable;
	
	initial begin
    wb_clk_i = 0 ;
    
    forever begin
     
      wb_clk_i = #3.2ns ~wb_clk_i ; 
	
	end
   end



endinterface


`endif
