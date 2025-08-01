`ifndef XGMII_SEQUENCE_BASE_SV
  `define XGMII_SEQUENCE_BASE_SV

  class xgmii_sequence_base extends uvm_sequence#(xgmii_item_drv);

	xgmii_item_drv item ;

    `uvm_declare_p_sequencer(xgmii_sequencer)
    
    `uvm_object_utils(xgmii_sequence_base)
    
    function new(string name = "");
      	super.new(name);
		
		item = xgmii_item_drv::type_id::create("item");
     endfunction

  



/*task send_crc(virtual xgmii_if vif, bit[31:0] crc);
  bit [63:0] word = {32'h07070707, crc};  // 4 bytes CRC + 4 bytes of IDLE (0x07)
  bit [7:0]  ctrl = 8'b11110000;          // Assume last byte (0xFD) is in CRC word

  @(posedge vif.clk_xgmii_rx);
  vif.xgmii_rxd <= word;
  vif.xgmii_rxc <= ctrl;
endtask

task send_termination(virtual xgmii_if vif, int idle_cycles = 2);
  // Send 0xFD termination code, then IDLE
  @(posedge vif.clk_xgmii_rx);
  vif.xgmii_rxd <= 64'hFD07070707070707;
  vif.xgmii_rxc <= 8'b10000000;

  repeat (idle_cycles) begin
    @(posedge vif.clk_xgmii_rx);
    vif.xgmii_rxd <= 64'h0707070707070707;
    vif.xgmii_rxc <= 8'hFF;
  end
endtask*/
	 
  endclass
`endif	

