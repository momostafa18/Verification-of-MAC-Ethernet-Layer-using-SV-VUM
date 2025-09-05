
`ifndef WISHBONE_MONITOR_SV
  `define WISHBONE_MONITOR_SV

class wishbone_monitor extends uvm_monitor implements wishbone_reset_handler;
    
    virtual wishbone_intf wb_vif; 
  
    wishbone_agent_config agent_config;
	
	process process_collect_transactions;
	
	wishbone_item_mon item ;
	
	uvm_analysis_port#(wishbone_item_mon) output_port;
       
	`uvm_component_utils(wishbone_monitor)
  
  function new(string name = "", uvm_component parent);
      super.new(name, parent);
        
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wishbone_intf)::get(this, "", "vif", wb_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get wishbone Virtual Interface from Agent ")
      end
	  
	  output_port = new("output_port", this);

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
	
	item   = wishbone_item_mon::type_id::create("item");

	 @(posedge wb_vif.wb_clk_i);

      if (wb_vif.wb_cyc_i && wb_vif.wb_stb_i) begin
        
        item.wb_adr_o = wb_vif.wb_adr_i;
        item.wb_we_o  = wb_vif.wb_we_i;
		
        // wait for ack
        while (!wb_vif.wb_ack_o) @(posedge wb_vif.wb_clk_i);
			if(item.wb_we_o == 0) item.wb_dat_o = wb_vif.wb_dat_o;
			else item.wb_dat_o = wb_vif.wb_dat_i;
		
      output_port.write(item);
	  
	  @(posedge wb_vif.wb_clk_i);
	  
	  `uvm_info("DEBUG", $sformatf("Monitoring \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE)
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

