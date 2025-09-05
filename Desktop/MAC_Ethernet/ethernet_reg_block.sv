
`ifndef ETHERNET_REGISTER_BLOCK
	`define ETHERNET_REGISTER_BLOCK

class ethernet_reg_block extends uvm_reg_block;
  
  rand ethernet_reg_configuration   	CONFIG;
  
  rand ethernet_reg_interrupt_mask 		INTMASK;
  
  rand ethernet_reg_interrupt_status  	INTSTAT;
  
  rand ethernet_reg_interrupt_pending   INTPEND;
  
  `uvm_object_utils(ethernet_reg_block)

  function new(string name = "");
	super.new(.name(name), .has_coverage(UVM_NO_COVERAGE));
endfunction

  
  virtual function void build();
    
    default_map = create_map(.name(           "wishbone_map"),
        					.base_addr(       'h0),
       						.n_bytes(          4),
      						.endian(           UVM_LITTLE_ENDIAN),
      						.byte_addressing(  1));
                                  
    default_map.set_check_on_read(1); 
                                         
    CONFIG = ethernet_reg_configuration::type_id::create("CONFIG", null, get_full_name());    
     
    CONFIG.configure(this);
	
    CONFIG.build();

    default_map.add_reg(CONFIG, 'h00, "RW");                             
                                  
           
                                  
    
    INTPEND = ethernet_reg_interrupt_pending::type_id::create("INTPEND", null, get_full_name());
                                  
    INTPEND.configure(this);

    INTPEND.build();

    default_map.add_reg(INTPEND, 'h08);    
   
                                  
                                  
    INTSTAT = ethernet_reg_interrupt_status::type_id::create("INTSTAT", null, get_full_name());    
    
    INTSTAT.configure(this);

    INTSTAT.build();

    default_map.add_reg(INTSTAT, 'h0C, "RO");        
                                  
                                  
                                  
                                  
    INTMASK = ethernet_reg_interrupt_mask::type_id::create("INTMASK", null, get_full_name());    

    INTMASK.configure(this);
	
    INTMASK.build();

    default_map.add_reg(INTMASK, 'h10, "RW");   

  endfunction

endclass

`endif
