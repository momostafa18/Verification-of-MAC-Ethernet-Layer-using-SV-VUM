`ifndef XGMII_DRIVER_SV
  `define XGMII_DRIVER_SV

class xgmii_driver extends uvm_driver#(xgmii_item_drv) implements xgmii_reset_handler;

    virtual xgmii_if xgmii_vif; 
  
    xgmii_agent_config agent_config;
      
	process process_drive_transactions;

	xgmii_item_drv	 item ;
   
	`uvm_component_utils(xgmii_driver)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif", xgmii_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get XGMII Virtual Interface from Agent ")
      end

	item   = xgmii_item_drv::type_id::create("item");
	
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

    virtual task drive_transaction(xgmii_item_drv item);

	
	@(posedge xgmii_vif.clk_xgmii_rx);

	xgmii_vif.xgmii_rxc <= item.xgmii_rxc ;
	xgmii_vif.xgmii_rxd <= item.xgmii_rxd ;
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
	xgmii_vif.xgmii_rxc <= 8'hff; 
	xgmii_vif.xgmii_rxd <= 64'h0707070707070707; 

    endfunction

  endclass
  
`endif  

