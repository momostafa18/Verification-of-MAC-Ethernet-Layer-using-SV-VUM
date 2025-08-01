`ifndef WISHBONE_SEQUENCE_BASE_SV
  `define WISHBONE_SEQUENCE_BASE_SV

  class wishbone_sequence_base extends uvm_sequence#(wishbone_item_base);
    
    
    `uvm_declare_p_sequencer(wishbone_sequencer)
    
    `uvm_object_utils(wishbone_sequence_base)
    
    function new(string name = "");
      	super.new(name);
     endfunction
	 
  endclass
`endif	

