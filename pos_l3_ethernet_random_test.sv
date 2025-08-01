`ifndef POS_L3_ETHERNET_TEST_RANDOM_SV
  `define POS_L3_ETHERNET_TEST_RANDOM_SV

  class pos_l3_ethernet_test_random extends ethernet_test_base;
    
    //Number of MD RX transactions
    protected int unsigned tx_length;

    `uvm_component_utils(pos_l3_ethernet_test_random)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      tx_length = 64;    // TODO : Make the Agent Configuration configurable by the test to change the tx_length of the packet
    endfunction
     
    virtual task run_phase(uvm_phase phase); 

      phase.raise_objection(this, "TEST_DONE");
       
      #(100ns);
	  
	  // OVERFLOW SEQUENCE
	  fork
         begin
          pos_l3_sequence_simple seq = pos_l3_sequence_simple::type_id::create("seq");
          seq.start(env.agent_1.sequencer);
		 end

		begin
          repeat(3) begin
            @(posedge pos_l3_vif.pkt_tx_sop);
          end
          #(6.4ns);
          pos_l3_vif.reset_156m25_n <= 0;
          
          repeat(4) begin
            @(posedge pos_l3_vif.clk_156m25);
          end
          pos_l3_vif.reset_156m25_n <= 1;
        end

		begin
		repeat (257) begin
          pos_l3_sequence_random seq = pos_l3_sequence_random::type_id::create("seq");
          
		  void'(seq.randomize());
		  
          seq.start(env.agent_1.sequencer);
		  end
		end
		
		begin
		repeat (30) begin
          pos_l3_sequence_underflow_tx seq = pos_l3_sequence_underflow_tx::type_id::create("seq");
          seq.start(env.agent_1.sequencer);
		  end
		end

      join
      #(500ns);
      phase.drop_objection(this, "TEST_DONE"); 
    endtask
    
  endclass

`endif
