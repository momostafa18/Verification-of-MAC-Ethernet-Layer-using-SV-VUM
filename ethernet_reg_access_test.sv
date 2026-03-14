`ifndef ETHERNET_TEST_REG_ACCESS_SV
  `define ETHERNET_TEST_REG_ACCESS_SV

  class ethernet_test_reg_access extends ethernet_test_base;

	//Number of register accesses
    protected int unsigned num_reg_accesses;

    //Number of unmapped accesses
    protected int unsigned num_unmapped_accesses;

    `uvm_component_utils(ethernet_test_reg_access)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      num_reg_accesses      = 100;
      num_unmapped_accesses = 100;
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      
      phase.raise_objection(this, "TEST_DONE");
      
      #(100ns);
      
     
	  begin
        ethernet_seq_reg_config seq = ethernet_seq_reg_config::type_id::create("seq", this);
        
        seq.reg_block = env.model.reg_block;
        
        seq.start(env.model.reg_block.default_map.get_sequencer());
      end



	 /*fork
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i 		== 'h00;
            item.wb_we_i  		== 1;
            item.wb_dat_i 		== 'h0001;
          });
          
          seq.start(env.agent_3.sequencer);
        end
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i 		== 'h00;
            item.wb_we_i  		== 0;
          });
          
          seq.start(env.agent_3.sequencer);
        end
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i 		== 'h08;
            item.wb_we_i  		== 1;
			item.wb_dat_i 		== 'h0035;
          });
          
          seq.start(env.agent_3.sequencer);
        end
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i 		== 'h08;
            item.wb_we_i  		== 0;
          });
          
          seq.start(env.agent_3.sequencer);
        end
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i 		== 'h08;
            item.wb_we_i  		== 0;
          });
          
          seq.start(env.agent_3.sequencer);
        end
        begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i 		== 'h0c;
            item.wb_we_i  		== 1;
			item.wb_dat_i 		== 'h0085;
          });
          
          seq.start(env.agent_3.sequencer);
        end
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i == 'h0c;
            item.wb_we_i  == 0;
          });
          
          seq.start(env.agent_3.sequencer);
        end
		begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i == 'h10;
            item.wb_we_i  == 1;
            item.wb_dat_i == 'h0044;
          });
          
          seq.start(env.agent_3.sequencer);
        end
	  
        begin
          wishbone_sequence_simple seq = wishbone_sequence_simple::type_id::create("seq");
		  
		  void'(seq.randomize() with {
            item.wb_adr_i == 'h10;
            item.wb_we_i  == 0;
          });
          
          seq.start(env.agent_3.sequencer);
        end

        /*begin
          wishbone_sequence_random seq = wishbone_sequence_random::type_id::create("seq");
          
          void'(seq.randomize());
          
          seq.start(env.agent_3.sequencer);
        end
      join*/
      
      #(500ns);
      
      phase.drop_objection(this, "TEST_DONE"); 
    endtask
    
  endclass

`endif	
