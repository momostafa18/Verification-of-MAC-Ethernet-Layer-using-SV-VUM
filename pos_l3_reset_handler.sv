

`ifndef POS_L3_RESET_HANDLER_SV
  `define POS_L3_RESET_HANDLER_SV

  interface class pos_l3_reset_handler;
    
    //Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);
    
      
  endclass

`endif

