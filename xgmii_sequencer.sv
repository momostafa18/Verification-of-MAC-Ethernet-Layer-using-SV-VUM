`ifndef XGMII_SEQUENCER_SV
  `define XGMII_SEQUENCER_SV

class xgmii_sequencer extends uvm_sequencer#(xgmii_item_drv) implements xgmii_reset_handler;

	`uvm_component_utils(xgmii_sequencer)
    
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

