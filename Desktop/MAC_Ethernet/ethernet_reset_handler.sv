`ifndef ETHERNET_RESET_HANDLER_SV
  `define ETHERNET_RESET_HANDLER_SV

  interface class ethernet_reset_handler;
    
    //Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);
 
  endclass

`endif


