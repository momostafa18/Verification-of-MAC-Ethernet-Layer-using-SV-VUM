`ifndef XGMII_SEQUENCE_DATA_SV
  `define XGMII_SEQUENCE_DATA_SV

  class xgmii_sequence_data extends xgmii_sequence_base;

    rand xgmii_item_drv item ;
	
	int unsigned num_cycles ;
	
	rand bit [63:0]  data ;

    `uvm_object_utils(xgmii_sequence_data)
    
    function new(string name = "");
      super.new(name);
      item = xgmii_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
   num_cycles = (item.type_len + 7) / 8;
   $display ("rrrrrrrrrrrrrrrr %0d" , item.type_len);
   $display ("rrrrrrrrrrrrrrrr %0d" , num_cycles);
   for (int i = 0 ; i < num_cycles ; i++) begin	
		 start_item(item);
		 void'(item.randomize());
		 send_payload();
		 finish_item(item);
	 end

  endtask
  
  task send_payload();
		item.xgmii_rxc <= 8'h00;
		item.xgmii_rxd <= data; // IDLE codes 
endtask

  endclass
`endif	



