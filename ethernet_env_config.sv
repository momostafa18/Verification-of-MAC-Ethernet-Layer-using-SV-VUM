`ifndef ETHERNET_ENV_CONFIG_SV
  `define ETHERNET_ENV_CONFIG_SV

  class ethernet_env_config extends uvm_component;
    
    //Switch to enable checks
    local bit has_checks;

    `uvm_component_utils(ethernet_env_config)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      has_checks      = 1;
    endfunction
    
    //Getter for the has_checks control field
    virtual function bit get_has_checks();
      return has_checks;
    endfunction
        
    //Setter for the has_checks control field
    virtual function void set_has_checks(bit value);
      has_checks = value;
    endfunction
    

  endclass

`endif
