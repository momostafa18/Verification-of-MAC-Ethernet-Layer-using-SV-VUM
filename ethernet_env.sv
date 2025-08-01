`ifndef ETHERNET_ENV_SV
  `define ETHERNET_ENV_SV

 class ethernet_env extends uvm_env;

    virtual pos_l3_if   pos_l3_vif; 
	
	virtual xgmii_if    xgmii_vif; 
	
	virtual wishbone_intf	wb_vif;
	
	pos_l3_agent   agent_1;
	
	xgmii_agent    agent_2;
	
	wishbone_agent agent_3;
	
    `uvm_component_utils(ethernet_env)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
	endfunction
    
	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
           
	  agent_1 = pos_l3_agent::type_id::create("agent_1", this);	
	  agent_2 = xgmii_agent::type_id::create("agent_2", this);	
	  agent_3 = wishbone_agent::type_id::create("agent_3", this);		  	  
		   
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
	  
	endfunction
    
    virtual function void connect_phase(uvm_phase phase);
 		
    endfunction

    virtual task run_phase(uvm_phase phase);
      

    endtask  
    
  endclass
`endif	
