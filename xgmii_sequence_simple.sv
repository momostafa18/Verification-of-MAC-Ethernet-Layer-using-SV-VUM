`ifndef XGMII_SEQUENCE_SIMPLE_SV
  `define XGMII_SEQUENCE_SIMPLE_SV

  class xgmii_sequence_simple extends xgmii_sequence_base;

	xgmii_sequence_preamble_and_start_frame_delimiter seq1;
	xgmii_sequence_addresses                          seq2;
    
    `uvm_object_utils(xgmii_sequence_simple)
    
    function new(string name = "");
      super.new(name);
    endfunction
	
	task pre_body ;
	  seq1 = xgmii_sequence_preamble_and_start_frame_delimiter :: type_id:: create("seq1");
	  seq2 = xgmii_sequence_addresses :: type_id:: create("seq2");
    endtask

  //Body Task
  task body;
  

	 void'(seq2.randomize() with {item.type_len == 55;}
	 );

     seq1.start(m_sequencer, this); 
	 seq2.start(m_sequencer, this); 

  endtask

  endclass
`endif	

