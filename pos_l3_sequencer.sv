`ifndef POS_L3_SEQUENCER_SV
  `define POS_L3_SEQUENCER_SV

class pos_l3_sequencer extends uvm_sequencer#(pos_l3_item_drv) implements pos_l3_reset_handler;

	`uvm_component_utils(pos_l3_sequencer)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
	
	virtual function void handle_reset(uvm_phase phase);
      int objections_count;
      stop_sequences();

      objections_count = uvm_test_done.get_objection_count(this);

      if(objections_count > 0) begin
        uvm_test_done.drop_objection(this, $sformatf("Dropping %0d objections at reset", objections_count), objections_count);
      end

      start_phase_sequence(phase);
    endfunction

  endclass
`endif	
