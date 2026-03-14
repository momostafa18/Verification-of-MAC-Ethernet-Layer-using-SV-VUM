
`ifndef ETHERNET_ISR_MODELING_VALUE_SV
  `define ETHERNET_ISR_MODELING_VALUE_SV

  class ethernet_isr_modeling_value extends uvm_reg_cbs; 
    
    uvm_reg 			ethernet_reg_interrupt_mask ;
	uvm_reg 			ethernet_reg_interrupt_pending ;
	uvm_reg 			ethernet_reg_interrupt_status ;	
	bit [8:0] isr_val;
	
	`uvm_object_utils(ethernet_isr_modeling_value)
	
    
    function new(string name = "");
      super.new(name);
    endfunction
	
  virtual function void post_predict(uvm_reg_field fld,
                                     uvm_reg_data_t previous,
                                     inout uvm_reg_data_t value,
                                     input uvm_predict_e kind,
                                     uvm_path_e path,
                                     uvm_reg_map map);
    if (fld.get_parent().get_name() == "INTPEND" || 
        fld.get_parent().get_name() == "INTMASK") begin
      
      isr_val = ethernet_reg_interrupt_mask.get_mirrored_value() & ethernet_reg_interrupt_pending.get_mirrored_value();
      void'(ethernet_reg_interrupt_status.predict(isr_val, UVM_PREDICT_READ));
    end
  endfunction
	endclass
    

`endif