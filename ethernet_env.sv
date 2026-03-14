`ifndef ETHERNET_ENV_SV
  `define ETHERNET_ENV_SV

 class ethernet_env extends uvm_env implements ethernet_reset_handler;
 
	ethernet_env_config env_config;

    virtual pos_l3_if   pos_l3_vif; 
	
	virtual xgmii_if    xgmii_vif; 
	
	virtual wishbone_intf	wb_vif;
	
	pos_l3_agent   agent_1;
	
	xgmii_agent    agent_2;
	
	wishbone_agent agent_3;
	
	ethernet_reg_model model;
	
	wishbone_reg_predictor#(wishbone_item_mon) predictor;
	
	wishbone_reg_adapter adapter;
	
	ethernet_scoreboard scoreboard;
	
	virtual_sequencer   v_seqr ;
	
    `uvm_component_utils(ethernet_env)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
	endfunction
    
	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
           
	  env_config = ethernet_env_config::type_id::create("env_config", this);
      
      env_config.set_has_checks(1);	   
		   
	  agent_1 = pos_l3_agent::type_id::create("agent_1", this);	
	  agent_2 = xgmii_agent::type_id::create("agent_2", this);	
	  agent_3 = wishbone_agent::type_id::create("agent_3", this);
	  scoreboard = ethernet_scoreboard::type_id::create("scoreboard", this);			  
		   
      if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Test ")
      end
	  else begin
	  `uvm_info("VIF_CONFIG", $sformatf("Virtual interface is set correctly inside %0s", get_full_name()), UVM_LOW)
	   uvm_config_db #(virtual pos_l3_if)::set(this,"pos_l3_agent","vif",pos_l3_vif);
	  end
	  
	  if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif", xgmii_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get XGMII Virtual Interface from Test")
      end 
	  else begin
	  `uvm_info("VIF_CONFIG", $sformatf("Virtual interface is set correctly inside %0s", get_full_name()), UVM_LOW)
	  uvm_config_db #(virtual xgmii_if)::set(this,"xgmii_agent","vif",xgmii_vif);
	  end
	  
	  if (!uvm_config_db#(virtual wishbone_intf)::get(this, "", "vif", wb_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get Wishbone Virtual Interface from Test")
      end 
	  else begin
	  `uvm_info("VIF_CONFIG", $sformatf("Virtual interface is set correctly inside %0s", get_full_name()), UVM_LOW)
	   uvm_config_db #(virtual wishbone_intf)::set(this,"wishbone_agent","vif",wb_vif);
	  end
	  
	  model = ethernet_reg_model::type_id::create("model", this);
	  
	  predictor = wishbone_reg_predictor#(wishbone_item_mon)::type_id::create("predictor", this);
	  
	  v_seqr = virtual_sequencer::type_id::create("v_seqr", this);

	endfunction
    
    virtual function void connect_phase(uvm_phase phase);
	adapter = wishbone_reg_adapter::type_id::create("adapter", this);
	
	super.connect_phase(phase);
	
	  predictor.map     = model.reg_block.default_map;
      predictor.adapter = adapter;

      //Connect the wishbone monitor with the predictor
      agent_3.monitor.output_port.connect(predictor.bus_in);
	  
	  model.reg_block.default_map.set_sequencer(agent_3.sequencer, adapter);
      
      predictor.env_config  = env_config;
	  
	  scoreboard.env_config = env_config;
	  
	  agent_1.m_write_port.connect(scoreboard.pos_l3_write_exp);
	  agent_1.m_write_port.connect(model.port_in_pos_l3);
      agent_2.m_write_port.connect(scoreboard.xgmii_write_exp);
      agent_2.m_write_port.connect(model.port_in_xgmii);
      
	  model.port_out_pos_l3.connect(scoreboard.pos_l3_write_exp_crc);
      model.port_out_xgmii.connect(scoreboard.xgmii_write_exp_crc);
	  
	  
	  
	  v_seqr.pos_l3_seqr = agent_1.sequencer;
	  v_seqr.xgmii_seqr  = agent_2.sequencer;
	  v_seqr.wb_seqr  	 = agent_3.sequencer;
	  v_seqr.model  	 = model;
 		
    endfunction
	
	virtual function void handle_reset(uvm_phase phase);
      model.handle_reset(phase);
    endfunction
  
    //Task for waiting reset to start
    protected virtual task wait_reset_start();
      agent_1.agent_config.wait_reset_start();
	  agent_2.agent_config.wait_reset_start();
	  agent_3.agent_config.wait_reset_start();
    endtask
  
    //Task for waiting reset to end
    protected virtual task wait_reset_end();
      agent_1.agent_config.wait_reset_end();
      agent_2.agent_config.wait_reset_end();
      agent_3.agent_config.wait_reset_end();
    endtask
    
    virtual task run_phase(uvm_phase phase);
      forever begin
        wait_reset_start();
        handle_reset(phase);
        wait_reset_end();
      end
    endtask

  endclass
`endif	
