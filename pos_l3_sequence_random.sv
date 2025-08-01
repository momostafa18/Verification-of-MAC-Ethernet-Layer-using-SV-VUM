
`ifndef POS_L3_SEQUENCE_RANDOM_SV
  `define POS_L3_SEQUENCE_RANDOM_SV

  class pos_l3_sequence_random extends pos_l3_sequence_base;
    
	pos_l3_sequence_simple seq ;
	
	bit pkt_tx_vall ;
           
    rand int unsigned item_num = 2; 
    constraint num_of_items {item_num <= 10; }
    
    `uvm_object_utils(pos_l3_sequence_random)
    
    function new(string name = "");
      super.new(name);
	  
    endfunction
    
	task pre_body ;
	  seq = pos_l3_sequence_simple :: type_id:: create("seq");
    endtask
    
  //Body Task
  task body;

     for(int i = 0; i < item_num; i++) begin
        
        void'(seq.randomize() with { pkt_tx_val == pkt_tx_vall; });

        seq.start(m_sequencer, this);  

      end
    endtask
    
    

  endclass
`endif	