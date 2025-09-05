`ifndef ETHERNET_REG_MODEL_SV
  `define ETHERNET_REG_MODEL_SV

  import "DPI-C" context function void crc32_reset();
  import "DPI-C" context function void crc32_update(longint unsigned word, int valid_bytes);
  import "DPI-C" context function int unsigned crc32_finalize();

  `uvm_analysis_imp_decl(_in_pos_l3) 
  `uvm_analysis_imp_decl(_in_xgmii)
  
  class ethernet_reg_model extends uvm_component;
  
  static bit [31:0] last_crc;
    
    //Register block
    ethernet_reg_block reg_block;
	
	ethernet_env_config env_config;
	
	uvm_analysis_imp_in_pos_l3#(pos_l3_item_mon, ethernet_reg_model) port_in_pos_l3;
	
	uvm_analysis_imp_in_xgmii#(xgmii_item_mon, ethernet_reg_model) port_in_xgmii;
	
	uvm_analysis_port#(pos_l3_item_mon) port_out_pos_l3;
	
	uvm_analysis_port#(xgmii_item_mon) port_out_xgmii;
	
	ethernet_isr_modeling_value isr_cb ;
	
	uvm_reg_field mask_fields[$];
	
	uvm_reg_field pend_fields[$];
    
    `uvm_component_utils(ethernet_reg_model)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent); 
	  
	  port_in_pos_l3    = new("port_in_pos_l3",   this); 
	  port_in_xgmii     = new("port_in_xgmii",   this); 
	  port_out_pos_l3   = new("port_out_pos_l3",   this); 
	  port_out_xgmii    = new("port_out_xgmii",   this); 
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(reg_block == null) begin
        reg_block = ethernet_reg_block::type_id::create("reg_block", this);
        
        reg_block.build();
        reg_block.lock_model();
      end
	   isr_cb = ethernet_isr_modeling_value::type_id::create("isr_cb", this);
    endfunction
	
	virtual function void connect_phase(uvm_phase phase);
    
	 super.connect_phase(phase);
      
      
	  
	  isr_cb.ethernet_reg_interrupt_mask = reg_block.INTMASK;
	  isr_cb.ethernet_reg_interrupt_status = reg_block.INTSTAT;
	  isr_cb.ethernet_reg_interrupt_pending = reg_block.INTPEND;
	  
	  reg_block.INTMASK.get_fields(mask_fields);
	  reg_block.INTPEND.get_fields(pend_fields);

	  
	  foreach (mask_fields[i]) begin
		uvm_reg_field_cb::add(mask_fields[i], isr_cb);
	  end
	  foreach (pend_fields[i]) begin
		uvm_reg_field_cb::add(pend_fields[i], isr_cb);
	  end
    endfunction
	
	virtual function void kill_process(ref process p);
      if(p != null) begin
        p.kill();
        
        p = null;
      end
    endfunction
	
	virtual function void handle_reset(uvm_phase phase);
      reg_block.reset("HARD");
    endfunction
	
	protected virtual function bit [31:0] calc_crc_for_pos_l3(
		bit SOP,
		bit EOP,
		bit val,
		bit [63:0] xgmii_txd
	);
		bit [31:0] crc_value;

		// Reset CRC on SOP
		if (SOP) begin
			crc32_reset();
		end

		// Process middle data words
		if (val && !SOP && !EOP) begin
			crc32_update(xgmii_txd, 8);
		end

		// Finalize on EOP
		if (EOP) begin
			crc_value = crc32_finalize();
			//`uvm_info("DEBUG", $sformatf("CRC calculated in pos_l3 is: %0h", crc_value), UVM_NONE)
			return crc_value;
		end
		endfunction

	
	virtual function void write_in_pos_l3(pos_l3_item_mon item_mon);
    // Calculate and store CRC into the transaction
    item_mon.crc_calc_value = calc_crc_for_pos_l3(
        item_mon.pkt_tx_sop,
        item_mon.pkt_tx_eop,
        item_mon.pkt_tx_val,
        item_mon.pkt_tx_data
    );
	//`uvm_info("DEBUG", $sformatf("Cfsfsfsff pos_l3 is: %0h", item_mon.crc_calc_value), UVM_NONE)
    // Forward the item to the scoreboard

    port_out_pos_l3.write(item_mon);
	endfunction

	
	virtual function void write_in_xgmii(xgmii_item_mon item_mon);
      //`uvm_info("DEBUG", $sformatf("Model received information from the RX agent: %0s", item_mon.convert2string()), UVM_NONE)
	  //`uvm_info("DEBUG", $sformatf("Cfsfsfsff xgmiii is: %0h", item_mon.crc_calculated), UVM_NONE)
	  port_out_xgmii.write(item_mon);
    endfunction
	
	
	
	
    
  endclass

`endif
