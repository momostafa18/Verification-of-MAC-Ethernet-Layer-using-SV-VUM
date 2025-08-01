
`include "ethernet_tst_pkg.sv"


module TestBench();

  import ethernet_test_pkg::*;
  import uvm_pkg::*; 
  
  
  pos_l3_if 	pos_l3_vif() ;
  xgmii_if  	xgmii_vif() ;
  wishbone_intf	wb_vif();

xge_mac dut    (
.clk_156m25      (pos_l3_vif.clk_156m25),                // To rx_dq0 of rx_dequeue.v, ...
.clk_xgmii_rx    (xgmii_vif.clk_xgmii_rx),               // To rx_eq0 of rx_enqueue.v, ...
.clk_xgmii_tx    (xgmii_vif.clk_xgmii_tx),               // To tx_dq0 of tx_dequeue.v, ...
.pkt_rx_ren	     (pos_l3_vif.pkt_rx_ren),                // To rx_dq0 of rx_dequeue.v
.pkt_tx_data	 (pos_l3_vif.pkt_tx_data),               // To tx_eq0 of tx_enqueue.v
.pkt_tx_eop		 (pos_l3_vif.pkt_tx_eop),                // To tx_eq0 of tx_enqueue.v
.pkt_tx_mod		 (pos_l3_vif.pkt_tx_mod),                // To tx_eq0 of tx_enqueue.v
.pkt_tx_sop      (pos_l3_vif.pkt_tx_sop),                // To tx_eq0 of tx_enqueue.v
.pkt_tx_val      (pos_l3_vif.pkt_tx_val),                // To tx_eq0 of tx_enqueue.v
.reset_156m25_n  (pos_l3_vif.reset_156m25_n),            // To rx_dq0 of rx_dequeue.v, ...
.reset_xgmii_rx_n(xgmii_vif.reset_xgmii_rx_n),           // To rx_eq0 of rx_enqueue.v, ...
.reset_xgmii_tx_n(xgmii_vif.reset_xgmii_tx_n),           // To tx_dq0 of tx_dequeue.v, ...
.wb_adr_i		 (wb_vif.wb_adr_i),                      // To wishbone_if0 of wishbone_if.v
.wb_clk_i		 (wb_vif.wb_clk_i),                      // To sync_clk_wb0 of sync_clk_wb.v, ...
.wb_cyc_i		 (wb_vif.wb_cyc_i),                      // To wishbone_if0 of wishbone_if.v
.wb_dat_i		 (wb_vif.wb_dat_i),                      // To wishbone_if0 of wishbone_if.v
.wb_rst_i		 (wb_vif.wb_rst_i),                      // To sync_clk_wb0 of sync_clk_wb.v, ...
.wb_stb_i		 (wb_vif.wb_stb_i),                      // To wishbone_if0 of wishbone_if.v
.wb_we_i		 (wb_vif.wb_we_i),                       // To wishbone_if0 of wishbone_if.v
.xgmii_rxc	     (xgmii_vif.xgmii_rxc),                  // To rx_eq0 of rx_enqueue.v
.xgmii_rxd		 (xgmii_vif.xgmii_rxd),                  // To rx_eq0 of rx_enqueue.v

.pkt_rx_avail	 (pos_l3_vif.pkt_rx_avail),              // From rx_dq0 of rx_dequeue.v
.pkt_rx_data	 (pos_l3_vif.pkt_rx_data),               // From rx_dq0 of rx_dequeue.v
.pkt_rx_eop	     (pos_l3_vif.pkt_rx_eop),                // From rx_dq0 of rx_dequeue.v
.pkt_rx_err		 (pos_l3_vif.pkt_rx_err),                // From rx_dq0 of rx_dequeue.v
.pkt_rx_mod		 (pos_l3_vif.pkt_rx_mod),                // From rx_dq0 of rx_dequeue.v
.pkt_rx_sop  	 (pos_l3_vif.pkt_rx_sop),                // From rx_dq0 of rx_dequeue.v
.pkt_rx_val  	 (pos_l3_vif.pkt_rx_val),                // From rx_dq0 of rx_dequeue.v
.pkt_tx_full 	 (pos_l3_vif.pkt_tx_full),               // From tx_eq0 of tx_enqueue.v
.wb_ack_o    	 (wb_vif.wb_ack_o),                      // From wishbone_if0 of wishbone_if.v
.wb_dat_o   	 (wb_vif.wb_dat_o),                      // From wishbone_if0 of wishbone_if.v
.wb_int_o    	 (wb_vif.wb_int_o),                      // From wishbone_if0 of wishbone_if.v
.xgmii_txc       (xgmii_vif.xgmii_txc),                  // From tx_dq0 of tx_dequeue.v
.xgmii_txd  	 (xgmii_vif.xgmii_txd)
  
);


initial begin
force dut.tx_dq0.txdfifo_ren    	= pos_l3_vif.txdfifo_ren  ;
force dut.tx_dq0.txdfifo_rempty    	= pos_l3_vif.txdfifo_rempty  ;

#3000ns

release dut.tx_dq0.txdfifo_ren ;
release dut.tx_dq0.txdfifo_rempty ;
end

initial begin
    pos_l3_vif.reset_156m25_n = 0;

    // Wait for 30 clock cycles
    repeat (10) @(posedge pos_l3_vif.clk_156m25);
    pos_l3_vif.reset_156m25_n = 1;
end

initial begin
    xgmii_vif.reset_xgmii_rx_n = 0;

    // Wait for 30 clock cycles
    repeat (10) @(posedge xgmii_vif.clk_xgmii_rx);
    xgmii_vif.reset_xgmii_rx_n = 1;
end

initial begin
    xgmii_vif.reset_xgmii_tx_n = 0;

    // Wait for 30 clock cycles
    repeat (10) @(posedge xgmii_vif.clk_xgmii_tx);
    xgmii_vif.reset_xgmii_tx_n = 1;
end

initial begin
    wb_vif.wb_rst_i = 1;

    // Wait for 30 clock cycles
    repeat (10) @(posedge wb_vif.wb_clk_i);
    wb_vif.wb_rst_i = 0;
end


  initial begin
	uvm_config_db#(virtual pos_l3_if)::set(null, "*", "vif", pos_l3_vif);
	uvm_config_db#(virtual xgmii_if) ::set(null, "*", "vif", xgmii_vif);
	uvm_config_db#(virtual wishbone_intf) ::set(null, "*", "vif", wb_vif);
	
	run_test ("xgmii_ethernet_test_random");
  end
  
   

endmodule
