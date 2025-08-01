
`ifndef WISHBONE_SEQUENCE_RANDOM_SV
  `define WISHBONE_SEQUENCE_RANDOM_SV

  class wishbone_sequence_random extends wishbone_sequence_base;
    
	wishbone_sequence_simple seq ;
           
    rand int unsigned item_num = 7; 
    constraint num_of_items {item_num <= 10; }
    
    `uvm_object_utils(wishbone_sequence_random)
    
    function new(string name = "");
      super.new(name);
	  
    endfunction
    
	task pre_body ;
	  seq = wishbone_sequence_simple :: type_id:: create("seq");
    endtask
    
  //Body Task
  task body;

     for(int i = 0; i < item_num; i++) begin
        
        void'(seq.randomize());
        
        seq.start(m_sequencer, this);  

      end
    endtask
    
    

  endclass
`endif	
