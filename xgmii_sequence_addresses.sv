`ifndef XGMII_SEQUENCE_ADDRESSES_SV
  `define XGMII_SEQUENCE_ADDRESSES_SV

  class xgmii_sequence_addresses extends xgmii_sequence_base;

    rand xgmii_item_drv item ;
	
	rand bit [15:0]  data_part ;
	
	rand bit [63:0]  data ;
	
	int unsigned num_cycles ;

	bit pauseYES;

    `uvm_object_utils(xgmii_sequence_addresses)
    
    function new(string name = "");
      super.new(name);
      item = xgmii_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
  
  	 void'(item.randomize());
	 
	 num_cycles = (item.type_len + 7) / 8;
	 
     start_item(item);
	 send_destination_address();
	 finish_item(item);
	 
	 start_item(item);
	 send_source_address();
	 finish_item(item);
	 
	 if(item.type_len < 1500 ) begin
		for (int i = 0 ; i < num_cycles ; i++) begin	
		 start_item(item);
		 void'(randomize(data));	 
		 send_payload();
		 finish_item(item);
		 end
	 end
	 else begin
		for (int i = 0 ; i < 6 ; i++) begin	
		 start_item(item);
		 void'(randomize(data));	 
		 send_payload();
		 finish_item(item);
		 end
	 end

  endtask
  
  task send_destination_address();
	  item.xgmii_rxd[47:0]  <= item.DA;
	  item.xgmii_rxd[63:48] <= item.SA[15:0]; 
	  item.xgmii_rxc        <= 8'h00;    // All data
  endtask
  
  task send_source_address();
	  item.xgmii_rxd[31:0]   <= item.SA[47:16];
	  
	  
	  if(!pauseYES) begin
	  item.xgmii_rxd[47:32]  <= item.type_len; 
	  item.xgmii_rxd[63:48]  <= data_part; 
	  end
	  else begin
	  item.xgmii_rxd[47:32]  <= 'h8808; 
	  item.xgmii_rxd[63:48]  <= 'h0001; 
	  end
	  
	  item.xgmii_rxc         <= 8'h00;    // All data
 endtask
 
task send_payload();
	 if(!pauseYES) begin
		item.xgmii_rxc <= 8'h00;
		item.xgmii_rxd <= data; // IDLE codes 
		end
		else begin
		item.xgmii_rxd[15:0] <= 'h00FF; // IDLE codes 
		
		end
endtask
 

  endclass
`endif	




