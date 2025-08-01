
`ifndef XGMII_RESET_HANDLER_SV
  `define XGMII_RESET_HANDLER_SV

  interface class xgmii_reset_handler;
    
    //Function to handle the reset
    pure virtual function void handle_reset(uvm_phase phase);
    
      
  endclass

`endif

