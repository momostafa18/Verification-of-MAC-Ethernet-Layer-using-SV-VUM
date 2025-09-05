`ifndef ETHERNET_SEQ_REG_CONFIG_SV
  `define ETHERNET_SEQ_REG_CONFIG_SV

  class ethernet_seq_reg_config extends uvm_reg_sequence;
    
    ethernet_reg_block reg_block;

    `uvm_object_utils(ethernet_seq_reg_config)
    
    function new(string name = "");
      super.new(name);
    endfunction
    
    virtual task body();
      uvm_status_e status;
      uvm_reg_data_t data;
      
	  reg_block.INTMASK.write(status, 'h111);
	  reg_block.INTSTAT.read(status,data);

    endtask
    
  endclass

`endif
