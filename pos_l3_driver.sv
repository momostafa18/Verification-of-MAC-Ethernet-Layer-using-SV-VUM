`ifndef POS_L3_DRIVER_SV
  `define POS_L3_DRIVER_SV

class pos_l3_driver extends uvm_driver#(pos_l3_item_drv) implements pos_l3_reset_handler;

    virtual pos_l3_if pos_l3_vif; 
  
    pos_l3_agent_config agent_config;
      
	process process_drive_transactions;

	pos_l3_item_drv	 item ;
	
	Packet packet ;          
	`uvm_component_utils(pos_l3_driver)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
			`uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Agent ")
		end
		
		packet = Packet::type_id::create("packet");
		
		item   = pos_l3_item_drv::type_id::create("item");

  endfunction
  
  virtual task run_phase(uvm_phase phase);
      forever begin
      	fork
          begin
            wait_reset_end();
            drive_transactions();
            
            disable fork;
          end
        join
      end
      
    endtask

    virtual task drive_transaction(pos_l3_item_drv item);
	  
	  `uvm_info("ITEM_START", $sformatf("Driving: Data= 0x%0h ",packet), UVM_LOW)
		
        @(posedge pos_l3_vif.clk_156m25);
		#1ns ;
        pos_l3_vif.pkt_tx_val 	  	  <= item.pkt_tx_val;
	    pos_l3_vif.txdfifo_ren 	  	  <= item.txdfifo_ren;
		pos_l3_vif.txdfifo_rempty 	  <= item.txdfifo_rempty;
        for (int i = 0; i < agent_config.get_tx_length(); i = i + 8) begin

            pos_l3_vif.pkt_tx_sop 		<= 1'b0;
            pos_l3_vif.pkt_tx_eop 		<= 1'b0;
            pos_l3_vif.pkt_tx_mod   	<= 2'b0;
			
			
            if (i == 0) begin 
			pos_l3_vif.pkt_tx_sop <= 1'b1;
			
			pos_l3_vif.pkt_tx_data[`LANE0] <= packet.sop[`LANE0];
            pos_l3_vif.pkt_tx_data[`LANE1] <= packet.sop[`LANE1];
            pos_l3_vif.pkt_tx_data[`LANE2] <= packet.sop[`LANE2];
            pos_l3_vif.pkt_tx_data[`LANE3] <= packet.sop[`LANE3];
            pos_l3_vif.pkt_tx_data[`LANE4] <= packet.sop[`LANE4];
            pos_l3_vif.pkt_tx_data[`LANE5] <= packet.sop[`LANE5];
			pos_l3_vif.pkt_tx_data[`LANE6] <= packet.sop[`LANE6];
			pos_l3_vif.pkt_tx_data[`LANE7] <= packet.sop[`LANE7];
			
			end
			
            else if (i + 8 >= agent_config.get_tx_length()) begin
                pos_l3_vif.pkt_tx_eop <= 1'b1;
                pos_l3_vif.pkt_tx_mod <= agent_config.get_tx_length() % 8;
				
				pos_l3_vif.pkt_tx_data[`LANE0] <= packet.eop[`LANE0];
				pos_l3_vif.pkt_tx_data[`LANE1] <= packet.eop[`LANE1];
				pos_l3_vif.pkt_tx_data[`LANE2] <= packet.eop[`LANE2];
				pos_l3_vif.pkt_tx_data[`LANE3] <= packet.eop[`LANE3];
				pos_l3_vif.pkt_tx_data[`LANE4] <= packet.eop[`LANE4];
				pos_l3_vif.pkt_tx_data[`LANE5] <= packet.eop[`LANE5];
				pos_l3_vif.pkt_tx_data[`LANE6] <= packet.eop[`LANE6];
				pos_l3_vif.pkt_tx_data[`LANE7] <= packet.eop[`LANE7];
            end
			
			else begin 
			void'(packet.randomize());
            pos_l3_vif.pkt_tx_data[`LANE0] <= packet.pkt_data[`LANE0];
            pos_l3_vif.pkt_tx_data[`LANE1] <= packet.pkt_data[`LANE1];
            pos_l3_vif.pkt_tx_data[`LANE2] <= packet.pkt_data[`LANE2];
            pos_l3_vif.pkt_tx_data[`LANE3] <= packet.pkt_data[`LANE3];
            pos_l3_vif.pkt_tx_data[`LANE4] <= packet.pkt_data[`LANE4];
            pos_l3_vif.pkt_tx_data[`LANE5] <= packet.pkt_data[`LANE5];
			pos_l3_vif.pkt_tx_data[`LANE6] <= packet.pkt_data[`LANE6];
			pos_l3_vif.pkt_tx_data[`LANE7] <= packet.pkt_data[`LANE7];
            
			end

            @(posedge pos_l3_vif.clk_156m25);
			#1ns ;
        end
	  pos_l3_vif.pkt_tx_val 		    <= 1'b0;
      pos_l3_vif.pkt_tx_eop 		    <= 1'b0;
      pos_l3_vif.pkt_tx_mod 		    <= 3'b0;
      
	  
	  
        

    endtask

  protected virtual task drive_transactions();
    
    fork 
      begin
        
        process_drive_transactions = process::self();
        
        forever begin
        seq_item_port.get_next_item(item);
		
		drive_transaction(item);
        
        seq_item_port.item_done();
      end
      
      end
    join
    
   endtask
  
  protected virtual task wait_reset_end();
      agent_config.wait_reset_end();
    endtask
  
  virtual function void handle_reset(uvm_phase phase);
    
	if(process_drive_transactions != null) begin
              process_drive_transactions.kill();

              process_drive_transactions = null;
    end
    
    //Initialize the signals
      pos_l3_vif.pkt_tx_val 			<= 1'b0;
      pos_l3_vif.pkt_tx_eop 			<= 1'b0;
      pos_l3_vif.pkt_tx_mod 			<= 3'b0;
      pos_l3_vif.pkt_tx_data 			<= 64'b0;
	  pos_l3_vif.txdfifo_ren 			<= 'b0;
	  pos_l3_vif.txdfifo_rempty 	    <= 'b0;
    endfunction

  endclass
  
`endif  
