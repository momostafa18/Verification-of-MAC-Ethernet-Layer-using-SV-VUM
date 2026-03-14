`ifndef ETHERNET_CONFIGURATION_REGISTER
	`define ETHERNET_CONFIGURATION_REGISTER

class ethernet_reg_configuration extends uvm_reg ;
  
  rand uvm_reg_field TX_Enable;

  `uvm_object_utils(ethernet_reg_configuration)
  
  function new(string name = "");
      super.new(.name(name), .n_bits(32), .has_coverage(UVM_NO_COVERAGE));
    endfunction
  
  virtual function void build();
    
     TX_Enable   = uvm_reg_field::type_id::create(.name("TX_Enable"),   .parent(null), .contxt(get_full_name()));
    
     TX_Enable.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                0),
        .access(                 "RW"),
        .volatile(               0),
        .reset(                  1'b1),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));
  endfunction

  
endclass
`endif
