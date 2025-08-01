
`ifndef POS_L3_MONITOR_SV
  `define POS_L3_MONITOR_SV

class pos_l3_monitor extends uvm_monitor implements pos_l3_reset_handler;
    
    virtual pos_l3_if pos_l3_vif; 
  
    pos_l3_agent_config agent_config;
	
	process process_collect_transactions;
	
	pos_l3_item_mon item ;
       
	`uvm_component_utils(pos_l3_monitor)
  
  function new(string name = "", uvm_component parent);
      super.new(name, parent);
        
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
			`uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Agent ")
		end
		
		
		item   = pos_l3_item_mon::type_id::create("item");
    

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

      int done = 0;

      item.pkt_rx_ren					= 1'b1;
	  item.pkt_rx_val  					= pos_l3_vif.pkt_rx_val ;
	  item.pkt_rx_sop  					= pos_l3_vif.pkt_rx_sop ;
	  item.pkt_rx_data 					= pos_l3_vif.pkt_rx_data ;
	  item.pkt_rx_eop  					= pos_l3_vif.pkt_rx_eop ;
	  item.pkt_tx_full 					= pos_l3_vif.pkt_tx_full ;	 
	  item.txdfifo_wfull 		        = pos_l3_vif.txdfifo_wfull;
	  item.txdfifo_walmost_full 		= pos_l3_vif.txdfifo_walmost_full;
	  
	  
      @(posedge pos_l3_vif.clk_156m25);

      while (!done) begin

            if (item.pkt_rx_val) begin

                if (item.pkt_rx_sop) begin
                    $display("\n\n------------------------");
                end

                $display("%x", item.pkt_rx_data);

                if (item.pkt_rx_eop) begin
                    
                    item.pkt_rx_ren <= 1'b0;
					
					@(posedge pos_l3_vif.clk_156m25);
					done = 1;
                end

                if (item.pkt_rx_eop) begin
                    $display("------------------------\n\n");
                end

            end

            @(posedge pos_l3_vif.clk_156m25);

        end
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
    endfunction
 
endclass
`endif	