
`ifndef POS_L3_MONITOR_SV
  `define POS_L3_MONITOR_SV

class pos_l3_monitor extends uvm_monitor implements pos_l3_reset_handler;
    
    virtual pos_l3_if pos_l3_vif; 
  
    pos_l3_agent_config agent_config;
	
	process process_collect_transactions;
	
	pos_l3_item_mon item ;
	
	Packet packet;
	
	uvm_analysis_port #(pos_l3_item_mon) m_write_port;
       
	`uvm_component_utils(pos_l3_monitor)
  
  function new(string name = "", uvm_component parent);
      super.new(name, parent);
        
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
			`uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Agent ")
		end
		
		packet = Packet::type_id::create("packet");
		
		m_write_port = new("m_write_port", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
      forever begin
      fork
        begin
          wait_reset_end(); 
          collect_transactions();
          
          disable fork;

        end
      join
     end
      
    endtask

    protected virtual task collect_transaction();
		bit done = 0;
		
		item   = pos_l3_item_mon::type_id::create("item");
		
		@(posedge pos_l3_vif.clk_156m25);
		
		fork 
		begin
		item.pkt_rx_val  = pos_l3_vif.pkt_rx_val;
			  item.pkt_rx_sop  = pos_l3_vif.pkt_rx_sop;
			  item.pkt_rx_data = pos_l3_vif.pkt_rx_data;
			  item.pkt_rx_eop  = pos_l3_vif.pkt_rx_eop;
		  if (pos_l3_vif.pkt_rx_avail) begin
			pos_l3_vif.pkt_rx_ren <= 1'b1;
			item.pkt_rx_ren       = pos_l3_vif.pkt_rx_ren;
		  end

		  // Collect until end of packet
		  while (!done) begin
			@(posedge pos_l3_vif.clk_156m25);
			if (pos_l3_vif.pkt_rx_val) begin
			  // Capture control signals
			  item.pkt_rx_val  = pos_l3_vif.pkt_rx_val;
			  item.pkt_rx_sop  = pos_l3_vif.pkt_rx_sop;
			  item.pkt_rx_data = pos_l3_vif.pkt_rx_data;
			  item.pkt_rx_eop  = pos_l3_vif.pkt_rx_eop;

			  if (pos_l3_vif.pkt_rx_eop) begin
				done = 1;

				// Deassert read enable after last word
				pos_l3_vif.pkt_rx_ren <= 1'b0;
				item.pkt_rx_ren       = pos_l3_vif.pkt_rx_ren;
			  end
			end
			end
			end

		begin
		if (pos_l3_vif.pkt_tx_val) begin
			item.pkt_tx_val    	 = pos_l3_vif.pkt_tx_val ;
			item.pkt_tx_data   	 = pos_l3_vif.pkt_tx_data ;
			item.pkt_tx_sop    	 = pos_l3_vif.pkt_tx_sop ;
			item.pkt_tx_eop    	 = pos_l3_vif.pkt_tx_eop ;				
			end
			item.crc_rx_state    = pos_l3_vif.crc_rx_state ;				
			item.crc_rx_value    = pos_l3_vif.crc_rx_value ;				
		end
		
		
		join_any
		 m_write_port.write(item);
    endtask

  protected virtual task collect_transactions();
      fork 
        begin

          	process_collect_transactions= process::self(); 

          forever begin
          	collect_transaction();
          end
      end
      join
    endtask
	
	protected virtual task wait_reset_end();
      agent_config.wait_reset_end();
	 
    endtask
	
	   
     virtual function void handle_reset(uvm_phase phase);
    
      if(process_collect_transactions != null) begin
              process_collect_transactions.kill();

              process_collect_transactions = null;
      end
	  
	   pos_l3_vif.pkt_rx_ren = 1'b0;
    endfunction
 
endclass
`endif	