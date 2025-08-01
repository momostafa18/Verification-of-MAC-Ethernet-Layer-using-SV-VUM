`ifndef POS_L3_SEQUENCE_BASE_SV
  `define POS_L3_SEQUENCE_BASE_SV

  class pos_l3_sequence_base extends uvm_sequence#(pos_l3_item_drv);
    
    
    `uvm_declare_p_sequencer(pos_l3_sequencer)
    
    `uvm_object_utils(pos_l3_sequence_base)
    
    function new(string name = "");
      	super.new(name);
     endfunction
	 
  endclass
`endif	
