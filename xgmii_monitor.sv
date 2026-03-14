`ifndef XGMII_MONITOR_SV
  `define XGMII_MONITOR_SV

class xgmii_monitor extends uvm_monitor implements xgmii_reset_handler;
    
    virtual xgmii_if xgmii_vif; 
  
    xgmii_agent_config agent_config;
	
	process process_collect_transactions;
	
	xgmii_item_mon item ;
	
	uvm_analysis_port #(xgmii_item_mon) m_write_port;
       
	`uvm_component_utils(xgmii_monitor)
  
  function new(string name = "", uvm_component parent);
      super.new(name, parent);
        
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif", xgmii_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get XGMII Virtual Interface from Agent ")
      end
	
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
	
	item   = xgmii_item_mon::type_id::create("item");
	 @(posedge xgmii_vif.clk_xgmii_rx);
	 
	 fork 
	 begin
		 item.xgmii_rxc 		= xgmii_vif.xgmii_rxc ;
		 item.xgmii_rxd 		= xgmii_vif.xgmii_rxd ;
		 item.crc_state 		= xgmii_vif.crc_state ;
		 item.crc_calculated    = xgmii_vif.crc_calculated ;
		 item.crc_rx_state      = xgmii_vif.crc_rx_state ;
		 item.crc_rx_value      = xgmii_vif.crc_rx_value ;
		 
	 end
	 
	 begin
		 item.xgmii_txc = xgmii_vif.xgmii_txc ;
		 item.xgmii_txd = xgmii_vif.xgmii_txd ;
	 //$display("this is xgmii monitor and this is the value of txc = %0h", item.xgmii_txc);
	 //$display("this is xgmii monitor and this is the value of txd = %0h", item.xgmii_txd);
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
    endfunction
 
endclass
`endif	
