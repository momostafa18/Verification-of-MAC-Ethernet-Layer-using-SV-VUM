

`ifndef WISHBONE_RESET_HANDLER_SV
  `define WISHBONE_RESET_HANDLER_SV

  interface class wishbone_reset_handler;
    
    //Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);
    
      
  endclass

`endif

