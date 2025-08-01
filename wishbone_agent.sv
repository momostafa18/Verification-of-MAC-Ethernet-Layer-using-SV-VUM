`ifndef WISHBONE_AGENT_SV
  `define WISHBONE_AGENT_SV

class wishbone_agent extends uvm_agent implements wishbone_reset_handler;

	 virtual wishbone_intf   wb_vif; 
     wishbone_agent_config agent_config;
	 
	 wishbone_driver 	  driver ;
	 wishbone_sequencer sequencer;
	 wishbone_monitor   monitor ;
	 
	`uvm_component_utils(wishbone_agent)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);

    endfunction

	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual wishbone_intf)::get(this, "", "vif", wb_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get wishbone Virtual Interface from Test ")
      end
	  uvm_config_db #(virtual wishbone_intf)::set(this,"wishbone_agent_config","vif",wb_vif);
	  
	  
	  agent_config = wishbone_agent_config::type_id::create("agent_config", this);
	  
	  if(agent_config.get_active_passive() == UVM_ACTIVE) begin
		  uvm_config_db #(virtual wishbone_intf)::set(this,"wishbone_driver","vif",wb_vif);
		  driver    = wishbone_driver::type_id::create("driver", this);
		  sequencer = wishbone_sequencer::type_id::create("sequencer", this);
		  driver.agent_config = agent_config ;
	  
	  end
	  monitor    = wishbone_monitor::type_id::create("monitor", this);
	  uvm_config_db #(virtual wishbone_intf)::set(this,"wishbone_monitor","vif",wb_vif);
	  monitor.agent_config = agent_config ;
	  
	endfunction
    
    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      if(agent_config.get_active_passive() == UVM_ACTIVE) begin
      
        driver.seq_item_port.connect(sequencer.seq_item_export);
      end
     
    endfunction

    protected virtual task wait_reset_start();
      agent_config.wait_reset_start();
    endtask
         
    protected virtual task wait_reset_end();
      agent_config.wait_reset_end();
    endtask
    
    virtual function void handle_reset(uvm_phase phase);
      uvm_component children[$];
      
      get_children(children);
      
      foreach(children[idx]) begin
        wishbone_reset_handler reset_handler;
        
        if($cast(reset_handler, children[idx])) begin
          reset_handler.handle_reset(phase);
        end
      end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      forever begin
        wait_reset_start();
        handle_reset(phase);
        wait_reset_end();
      end
    endtask

  endclass
`endif	
