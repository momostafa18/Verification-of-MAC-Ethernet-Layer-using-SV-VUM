
`ifndef ETHERNET_TEST_BASE_SV
  `define ETHERNET_TEST_BASE_SV

  class ethernet_test_base extends uvm_test;
	
	ethernet_env env ;
    virtual pos_l3_if pos_l3_vif; 
    virtual xgmii_if xgmii_vif; 
	virtual wishbone_intf wb_vif;

	`uvm_component_utils(ethernet_test_base)
    
    function new (string name = "" , uvm_component parent);
      super.new(name, parent);
    endfunction 
    
	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      env = ethernet_env::type_id::create("env",this);
      
      if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from config DB")
      end 
	  else begin
	  `uvm_info("VIF_CONFIG", $sformatf("Virtual interface is set correctly inside %0s", get_full_name()), UVM_LOW)
	  uvm_config_db #(virtual pos_l3_if)::set(this,"ethernet_env","vif",pos_l3_vif);
	  end
	  
	  if (!uvm_config_db#(virtual xgmii_if)::get(this, "", "vif", xgmii_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get XGMII Virtual Interface from config DB")
      end 
	  else begin
	  `uvm_info("VIF_CONFIG", $sformatf("Virtual interface is set correctly inside %0s", get_full_name()), UVM_LOW)
	  uvm_config_db #(virtual xgmii_if)::set(this,"ethernet_env","vif",xgmii_vif);
	  end
	  
	  if (!uvm_config_db#(virtual wishbone_intf)::get(this, "", "vif", wb_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get wishbone Virtual Interface from config DB")
      end 
	  else begin
	  `uvm_info("VIF_CONFIG", $sformatf("Virtual interface is set correctly inside %0s", get_full_name()), UVM_LOW)
	  uvm_config_db #(virtual wishbone_intf)::set(this,"ethernet_env","vif",wb_vif);
	  end
	  
	  
	endfunction
    


  endclass

`endif	