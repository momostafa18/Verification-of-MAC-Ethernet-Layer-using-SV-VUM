class virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_sequencer)
  
  pos_l3_sequencer 	 pos_l3_seqr;
  xgmii_sequencer 	 xgmii_seqr;
  wishbone_sequencer wb_seqr;
  ethernet_reg_model model;

  function new(string name = "virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass
