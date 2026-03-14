class virtual_seq extends uvm_sequence;
  pos_l3_sequence_simple    pos_l3_seq;
  xgmii_sequence_simple     xgmii_seq;
  ethernet_seq_reg_config   reg_seq;

  pos_l3_sequencer          pos_l3_seqr;
  xgmii_sequencer           xgmii_seqr;
  wishbone_sequencer        wb_seqr;
  ethernet_reg_model 		model;

  `uvm_object_utils(virtual_seq)
  `uvm_declare_p_sequencer(virtual_sequencer)

  function new (string name = "virtual_seq");
    super.new(name);
  endfunction

  task body();
    // Create sequences
    pos_l3_seq			= pos_l3_sequence_simple::type_id::create("pos_l3_seq");
    xgmii_seq  			= xgmii_sequence_simple::type_id::create("xgmii_seq");
    reg_seq    			= ethernet_seq_reg_config::type_id::create("reg_seq");
	
    fork
      begin
        pos_l3_seq.start(p_sequencer.pos_l3_seqr);
      end
      begin
        xgmii_seq.start(p_sequencer.xgmii_seqr);
      end
	  repeat(35)
	  begin
	  begin
		reg_seq.reg_block = p_sequencer.model.reg_block;
        reg_seq.start(null);
      end
	  end

    join
  endtask
endclass
