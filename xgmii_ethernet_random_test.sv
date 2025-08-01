`ifndef XGMII_ETHERNET_TEST_RANDOM_SV
  `define XGMII_ETHERNET_TEST_RANDOM_SV

  class xgmii_ethernet_test_random extends ethernet_test_base;
    
    //Number of MD RX transactions
    protected int unsigned tx_length;
	protected int unsigned type_len;

    `uvm_component_utils(xgmii_ethernet_test_random)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      tx_length = 64;    // TODO : Make the Agent Configuration configurable by the test to change the tx_length of the packet
	  type_len  = 128;   // TODO : Make the Agent Configuration configurable by the test to change the type_len of the packet
    endfunction
     
    virtual task run_phase(uvm_phase phase); 

      phase.raise_objection(this, "TEST_DONE");
       
      #(100ns);
		fork
         begin
          xgmii_sequence_idle seq = xgmii_sequence_idle::type_id::create("seq");
          
          seq.start(env.agent_2.sequencer);
		end
		
		/*begin
          repeat(55) begin
            @(posedge xgmii_vif.clk_xgmii_rx);
          end
          #(6.4ns);
          xgmii_vif.reset_xgmii_rx_n <= 0;
          
          repeat(4) begin
            @(posedge xgmii_vif.clk_xgmii_rx);
          end
          xgmii_vif.reset_xgmii_rx_n <= 1;
        end*/
		
		begin
          xgmii_sequence_preamble_and_start_frame_delimiter seq = xgmii_sequence_preamble_and_start_frame_delimiter::type_id::create("seq");
          
          seq.start(env.agent_2.sequencer);
		end
		
		begin
          xgmii_sequence_addresses seq = xgmii_sequence_addresses::type_id::create("seq");
          
		  void'(seq.randomize());
          seq.start(env.agent_2.sequencer);
		end		

      join
	  
      #(500ns);
      
      phase.drop_objection(this, "TEST_DONE"); 
    endtask
    
  endclass

`endif

