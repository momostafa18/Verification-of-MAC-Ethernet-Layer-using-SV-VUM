
`ifndef WISHBONE_MONITOR_SV
  `define WISHBONE_MONITOR_SV

class wishbone_monitor extends uvm_monitor implements wishbone_reset_handler;
    
    virtual wishbone_intf wb_vif; 
  
    wishbone_agent_config agent_config;
	
	process process_collect_transactions;
	
	wishbone_item_mon item ;
       
	`uvm_component_utils(wishbone_monitor)
  
  function new(string name = "", uvm_component parent);
      super.new(name, parent);
        
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wishbone_intf)::get(this, "", "vif", wb_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get wishbone Virtual Interface from Agent ")
      end
		
		
	item   = wishbone_item_mon::type_id::create("item");
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

	 @(posedge wb_vif.wb_clk_i);

      
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

