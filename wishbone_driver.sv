`ifndef WISHBONE_DRIVER_SV
  `define WISHBONE_DRIVER_SV

class wishbone_driver extends uvm_driver#(wishbone_item_drv) implements wishbone_reset_handler;

    virtual wishbone_intf wb_vif; 
  
    wishbone_agent_config agent_config;
      
	process process_drive_transactions;

	wishbone_item_drv	 item ;
	
	`uvm_component_utils(wishbone_driver)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if (!uvm_config_db#(virtual wishbone_intf)::get(this, "", "vif", wb_vif)) begin
			`uvm_fatal("NO_VIF", "Failed to get wishbone Virtual Interface from Agent ")
		end

	    item   = wishbone_item_drv::type_id::create("item");

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

    virtual task drive_transaction(wishbone_item_drv item);

@(posedge wb_vif.wb_clk_i);

        wb_vif.wb_cyc_i <= 1;
		wb_vif.wb_stb_i <= 1;
		wb_vif.wb_adr_i <= item.wb_adr_i;
		wb_vif.wb_we_i  <= item.wb_we_i;

		if (item.wb_we_i == 'b1) begin
		  wb_vif.wb_dat_i <= item.wb_dat_i;
		end

		// Wait for ack
		@(posedge wb_vif.wb_clk_i);
		while (wb_vif.wb_ack_o !== 1 ) @(posedge wb_vif.wb_clk_i);

		// De-assert signals
		wb_vif.wb_cyc_i <= 0;
		wb_vif.wb_stb_i <= 0;
		wb_vif.wb_we_i  <= 0;
		wb_vif.wb_adr_i <= '0;
		wb_vif.wb_dat_i <= '0;

		@(posedge wb_vif.wb_clk_i);
 
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
        wb_vif.wb_cyc_i <= 1;
		wb_vif.wb_stb_i <= 1;
		wb_vif.wb_we_i  <= 0;
		wb_vif.wb_adr_i <= 'b0;
		wb_vif.wb_dat_i <= 'b0;

    endfunction

  endclass
  
`endif  

