`ifndef ETHERNET_SCOREBOARD_SV
  `define ETHERNET_SCOREBOARD_SV
 
  class ethernet_scoreboard extends uvm_scoreboard;
  
    `uvm_component_utils(ethernet_scoreboard)

	ethernet_env_config env_config;

	pos_l3_item_mon pos_l3_recieved_data; // This will be used when monitoring the output of the xgmii rx signals as it's the output of this direction  
	xgmii_item_mon  xgmii_recieved_data;  // This will monitor the xgmii tx signals as it's considered as the output of the pos l3 interface
	Packet 		    packet;
	int 			done;

	uvm_analysis_export   #(pos_l3_item_mon) pos_l3_write_exp,pos_l3_write_exp_crc;
    uvm_analysis_export   #(xgmii_item_mon)  xgmii_write_exp,xgmii_write_exp_crc;
    uvm_tlm_analysis_fifo #(pos_l3_item_mon) pos_l3_fifo,pos_l3_fifo_crc;
	uvm_tlm_analysis_fifo #(xgmii_item_mon)  xgmii_fifo,xgmii_fifo_crc;
	
	bit [63:0] pos_l3_pushed_data_queue[$];
	bit [63:0] pos_l3_pushed_data_temp;
	bit [63:0] pos_l3_recieved_data_queue[$];
	bit [63:0] pos_l3_recieved_data_temp;
	bit [63:0] xgmii_pushed_data_queue[$];
	bit [63:0] xgmii_pushed_data_temp;
	bit [63:0] xgmii_recieved_data_queue[$];
	bit [63:0] xgmii_recieved_data_temp;
	
	
	function new (string name = "ethernet_scoreboard" , uvm_component parent = null);
       super.new(name,parent);
	   
	  
    endfunction
	
	function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Build_Phase",UVM_NONE)
    
    // Factory Creation
    pos_l3_recieved_data = pos_l3_item_mon::type_id::create("pos_l3_recieved_data");
	xgmii_recieved_data  = xgmii_item_mon::type_id::create("xgmii_recieved_data");
    packet 				 = Packet::type_id::create("packet");
	pos_l3_write_exp 	 = new("pos_l3_write_exp",this);
	pos_l3_write_exp_crc = new("pos_l3_write_exp_crc",this);
	xgmii_write_exp  	 = new("xgmii_write_exp",this);
	xgmii_write_exp_crc  = new("xgmii_write_exp_crc",this);
	pos_l3_fifo_crc  	 = new("pos_l3_fifo_crc",this);
	xgmii_fifo_crc       = new("xgmii_fifo_crc",this);
	pos_l3_fifo  	 	 = new ("pos_l3_fifo",this);
	xgmii_fifo  	 	 = new ("xgmii_fifo",this);

    endfunction
  
  
  
  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Connect_Phase",UVM_NONE)
	pos_l3_write_exp.connect(pos_l3_fifo.analysis_export);
	xgmii_write_exp.connect(xgmii_fifo.analysis_export);

  	pos_l3_write_exp_crc.connect(pos_l3_fifo_crc.analysis_export);
	xgmii_write_exp_crc.connect(xgmii_fifo_crc.analysis_export);
    endfunction
  

  task run_phase(uvm_phase phase);
   super.run_phase(phase);
	 forever begin
	//`uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_RUN_Phase",UVM_NONE)
	xgmii_fifo.get(xgmii_recieved_data);
	//`uvm_info("SCOREBOARD", $sformatf("Got XGMII txn: %p", xgmii_recieved_data), UVM_LOW)
	pos_l3_fifo.get(pos_l3_recieved_data);
	
	pos_l3_fifo_crc.get(pos_l3_recieved_data);

	xgmii_fifo_crc.get(xgmii_recieved_data);
	//`uvm_info("SCOREBOARD", $sformatf("Got POS_L3 txn: %p", pos_l3_recieved_data), UVM_LOW)

		queueing_pos_l3_pushed_data();
		queueing_xgmii_recieved_data();
		check_pos_l3_to_xgmii();	
		
		queueing_xgmii_pushed_data();
		queueing_pos_l3_recieved_data();
		check_xgmii_to_pos_l3();
		
		checking_crc_for_pos_l3_direction();
		checking_crc_for_xgmii_direction();
	
   end
  endtask
  
  
  task queueing_pos_l3_pushed_data ;

		if (pos_l3_recieved_data.pkt_tx_val) begin
		//#1ns;		
		pos_l3_pushed_data_queue.push_front(pos_l3_recieved_data.pkt_tx_data);
		//`uvm_info("DEBUG", $sformatf("[%0t] The pushed value to the pos_l3 is = [%0h] !",$time  , pos_l3_pushed_data_queue[0]), UVM_NONE)
     	end
  endtask
  
  task queueing_xgmii_recieved_data ;  // This will monitor the xgmii tx signals as it's considered as the output of the pos l3 interface
		//$display(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
		if (xgmii_recieved_data.xgmii_txc == 'h00) begin	
		//$display("qwqwqwqwqwqwqw");
		xgmii_recieved_data_queue.push_front(xgmii_recieved_data.xgmii_txd);
		//`uvm_info("DEBUG", $sformatf("[%0t] The pushed value to the xgmii is = [%0h] !",$time  , xgmii_recieved_data_queue[0]), UVM_NONE)
     	end
  endtask
  
  task check_pos_l3_to_xgmii ;
  //$display("xxxxxxxxxxxxxxxxxxxxx");
	if(pos_l3_pushed_data_queue.size > 0 && xgmii_recieved_data_queue.size > 0 )
	  begin
	  //$display("yyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
	  pos_l3_pushed_data_temp  = pos_l3_pushed_data_queue.pop_back ;
	  xgmii_recieved_data_temp = xgmii_recieved_data_queue.pop_back;
	  //$display("oooooooooooooooooooooo");
	   if( pos_l3_pushed_data_temp == xgmii_recieved_data_temp) begin

			`uvm_info("DEBUG", $sformatf("[%0t] The Basic Operation is GOOD where packets transmitted from pos_l3_intf to xgmii_intf TX= [%0h] , RX= [%0h] !",$time  , pos_l3_pushed_data_temp , xgmii_recieved_data_temp), UVM_NONE)
		end	
		else begin
			`uvm_error("ILLEGAL_ACCESS", $sformatf("The Basic Operation is BAD where packets transmitted from pos_l3_intf to xgmii_intf TX= [%0h] , RX= [%0h] !", pos_l3_pushed_data_temp, xgmii_recieved_data_temp))
		end
	  
	  
	  end
  
  endtask

  
  task queueing_xgmii_pushed_data ;
  
		if (xgmii_recieved_data.xgmii_rxc == 'h00) begin	
			//$display("qwqwqwqwqwqwqw");
			xgmii_pushed_data_queue.push_front(xgmii_recieved_data.xgmii_rxd);
			//`uvm_info("DEBUG", $sformatf("[%0t] The pushed value to the xgmii is = [%0h] !",$time  , xgmii_pushed_data_queue[0]), UVM_NONE)
			//$display("ppppppppppppppppppppppppp");
     	end
		
  endtask
  
  task queueing_pos_l3_recieved_data ;  // This will monitor the xgmii tx signals as it's considered as the output of the pos l3 interface
		  if (pos_l3_recieved_data.pkt_rx_val) begin
			//#1ns;	
			pos_l3_recieved_data_queue.push_front(pos_l3_recieved_data.pkt_rx_data);
			
			//`uvm_info("DEBUG", $sformatf("[%0t] The pushed value to the pos_l3 is = [%0h] , [%0h] !",$time  , pos_l3_recieved_data_queue[0],pos_l3_recieved_data.pkt_rx_val ), UVM_NONE)
			//$display("xxxxxxxxxxxxxxxxxxxxxxxxxxx");
		  end
		  
		
  endtask
  
  task check_xgmii_to_pos_l3 ;

	if(pos_l3_recieved_data_queue.size > 0 && xgmii_pushed_data_queue.size > 0 )
	  begin
	  //$display("value of the fifo %0p" , pos_l3_recieved_data_queue);
	  xgmii_pushed_data_temp     = xgmii_pushed_data_queue.pop_back;
	  pos_l3_recieved_data_temp  = pos_l3_recieved_data_queue.pop_back ;
	  //$display("oooooooooooooooooooooo");
	   if( pos_l3_recieved_data_temp == xgmii_pushed_data_temp) begin

			`uvm_info("DEBUG", $sformatf("[%0t] The Basic Operation is GOOD where packets transmitted from xgmii_intf to pos_l3_intf TX= [%0h] , RX= [%0h] !",$time  , pos_l3_recieved_data_temp , xgmii_pushed_data_temp), UVM_NONE)
		end	
		else begin
			`uvm_error("ILLEGAL_ACCESS", $sformatf("The Basic Operation is BAD where packets transmitted from xgmii_intf to pos_l3_intf TX= [%0h] , RX= [%0h] !", pos_l3_recieved_data_temp, xgmii_pushed_data_temp))
		end
	  
	  
	  end
  
  endtask
  
  task checking_crc_for_pos_l3_direction ;  // This will monitor the xgmii tx signals as it's considered as the output of the pos l3 interface
		  static bit [31:0] crc_temp;
		  
		  if(pos_l3_recieved_data.crc_calc_value == 0) begin 
		  end
				
		  else  begin
			crc_temp = pos_l3_recieved_data.crc_calc_value ;
		  end 
		  
		  if (pos_l3_recieved_data.crc_rx_state == 'd8) begin
			if( crc_temp == pos_l3_recieved_data.crc_rx_value)
				`uvm_info("DEBUG", $sformatf("[%0t] The CRC value caclulated by the MAC is GOOD = [%0h] , [%0h] !",$time  , crc_temp ,pos_l3_recieved_data.crc_rx_value ), UVM_NONE)
			else  
				`uvm_error("DEBUG", $sformatf("[%0t] The CRC value caclulated by the MAC is BAD = [%0h] , [%0h] !",$time  , crc_temp ,pos_l3_recieved_data.crc_rx_value ))
		  end	
  endtask
  
  task checking_crc_for_xgmii_direction ;  // This will monitor the xgmii tx signals as it's considered as the output of the pos l3 interface
		  static bit [31:0] crc_temp;
		  
		  if(xgmii_recieved_data.crc_state == 0 && xgmii_recieved_data.crc_rx_state == 'd8) begin 
			   crc_temp = xgmii_recieved_data.crc_calculated ;
			if( crc_temp == xgmii_recieved_data.crc_rx_value)
				`uvm_info("DEBUG", $sformatf("[%0t] The CRC value caclulated by the MAC in the XGMII is GOOD = [%0h] , [%0h] !",$time  , crc_temp ,xgmii_recieved_data.crc_rx_value ), UVM_NONE)
			else  
				`uvm_error("DEBUG", $sformatf("[%0t] The CRC value caclulated by the MAC in the XGMII is BAD = [%0h] , [%0h] !",$time  , crc_temp ,xgmii_recieved_data.crc_rx_value ))
		  end	
  endtask
  

  endclass

`endif
