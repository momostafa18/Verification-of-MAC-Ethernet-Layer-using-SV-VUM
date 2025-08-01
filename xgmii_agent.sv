
`ifndef XGMII_AGENT_SV
  `define XGMII_AGENT_SV

class xgmii_agent extends uvm_agent implements xgmii_reset_handler;

	 virtual xgmii_if   xgmii_vif; 
     xgmii_agent_config   agent_config;
	
	 xgmii_driver 	      driver ;
	 xgmii_sequencer      sequencer;
	 xgmii_monitor        monitor ;
	 
	`uvm_component_utils(xgmii_agent)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);

    endfunction

	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif", xgmii_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Test ")
      end
	  uvm_config_db #(virtual xgmii_if)::set(this,"xgmii_agent_config","vif",xgmii_vif);
	  
	  
	  agent_config = xgmii_agent_config::type_id::create("agent_config", this);
	  
	  if(agent_config.get_active_passive() == UVM_ACTIVE) begin
		  uvm_config_db #(virtual xgmii_if)::set(this,"xgmii_driver","vif",xgmii_vif);
		  driver    = xgmii_driver::type_id::create("driver", this);
		  sequencer = xgmii_sequencer::type_id::create("sequencer", this);
		  driver.agent_config = agent_config ;
	  
	  end
	  
	  monitor    = xgmii_monitor::type_id::create("monitor", this);
	  uvm_config_db #(virtual xgmii_if)::set(this,"xgmii_monitor","vif",xgmii_vif);
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
        xgmii_reset_handler reset_handler;
        
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