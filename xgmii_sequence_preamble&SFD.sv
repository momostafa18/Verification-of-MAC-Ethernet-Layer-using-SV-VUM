`ifndef XGMII_SEQUENCE_PREAMBLE_AND_START_FRAME_DELIMITER_SV
  `define XGMII_SEQUENCE_PREAMBLE_AND_START_FRAME_DELIMITER_SV

  class xgmii_sequence_preamble_and_start_frame_delimiter extends xgmii_sequence_base;

    xgmii_item_drv item ;

    `uvm_object_utils(xgmii_sequence_preamble_and_start_frame_delimiter)
    
    function new(string name = "");
      super.new(name);
      item = xgmii_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
     start_item(item);
	 send_preamble_sfd();
	 finish_item(item);

  endtask
  
  task send_preamble_sfd();
	  item.xgmii_rxd <= 64'hD5555555555555FB; // 7x Preamble (0x55), 1x SFD (0xFB)
	  item.xgmii_rxc <= 8'b00000001;          // Last byte (SFD) is control
	endtask

  endclass
`endif	



