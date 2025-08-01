`ifndef POS_L3_AGENT_CONFIG_SV
  `define POS_L3_AGENT_CONFIG_SV

class pos_l3_agent_config extends uvm_component;

	int unsigned tx_length ;
	
	virtual pos_l3_if pos_l3_vif; 

	uvm_active_passive_enum active_passive;
	
	`uvm_component_utils(pos_l3_agent_config)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);

	    active_passive = UVM_ACTIVE;
		tx_length 	   = 64 ;
    endfunction
	
	virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
	  
      if (!uvm_config_db#(virtual pos_l3_if)::get(this, "", "vif", pos_l3_vif)) begin
      `uvm_fatal("NO_VIF", "Failed to get POS_L3 Virtual Interface from Agent ")
      end

	endfunction
	
	virtual function int unsigned get_tx_length();
      return tx_length;
    endfunction
    
    virtual function void set_tx_length(int unsigned value);

      tx_length = value;

    endfunction
	
	virtual function uvm_active_passive_enum get_active_passive();
      return active_passive;
    endfunction
    
    //Setter for the APB Active/Passive control
    virtual function void set_active_passive(uvm_active_passive_enum value);
      active_passive = value;
    endfunction

     virtual task wait_reset_start();
      if(pos_l3_vif.reset_156m25_n !== 0) begin
            @(negedge pos_l3_vif.reset_156m25_n);
      end
    endtask
         
    //Task for waiting the reset to be finished
     virtual task wait_reset_end();
      if(pos_l3_vif.reset_156m25_n == 0) begin
        	@(posedge pos_l3_vif.reset_156m25_n);
	  end
	endtask
	
	
  endclass
  
`endif
