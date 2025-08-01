`ifndef POS_L3_AGENT_SV
  `define POS_L3_AGENT_SV

class pos_l3_agent extends uvm_agent implements pos_l3_reset_handler;

	 virtual pos_l3_if   pos_l3_vif; 
     pos_l3_agent_config agent_config;
	 
	 pos_l3_driver 	  driver ;
	 pos_l3_sequencer sequencer;
	 pos_l3_monitor   monitor ;
	 
	`uvm_component_utils(pos_l3_agent)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);

    endfunction

	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Test ")
      end
	  uvm_config_db #(virtual pos_l3_if)::set(this,"pos_l3_agent_config","vif",pos_l3_vif);
	  
	  
	  agent_config = pos_l3_agent_config::type_id::create("agent_config", this);
	  
	  if(agent_config.get_active_passive() == UVM_ACTIVE) begin
		  uvm_config_db #(virtual pos_l3_if)::set(this,"pos_l3_driver","vif",pos_l3_vif);
		  driver    = pos_l3_driver::type_id::create("driver", this);
		  sequencer = pos_l3_sequencer::type_id::create("sequencer", this);
		  driver.agent_config = agent_config ;
	  
	  end
	  monitor    = pos_l3_monitor::type_id::create("monitor", this);
	  uvm_config_db #(virtual pos_l3_if)::set(this,"pos_l3_monitor","vif",pos_l3_vif);
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
        pos_l3_reset_handler reset_handler;
        
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