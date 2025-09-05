`ifndef WISHBONE_REG_PREDICTOR_SV
  `define WISHBONE_REG_PREDICTOR_SV

  class wishbone_reg_predictor#(type BUSTYPE = uvm_sequence_item) extends uvm_reg_predictor#(.BUSTYPE(BUSTYPE));
    
    //Pointer to the environment configuration
    ethernet_env_config env_config;

    `uvm_component_param_utils(wishbone_reg_predictor#(BUSTYPE))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    //Get the value of a register field from a full register value
    protected virtual function uvm_reg_data_t get_reg_field_value(uvm_reg_field reg_field, uvm_reg_data_t reg_data);
      uvm_reg_data_t mask = (('h1 << reg_field.get_n_bits()) - 1) << reg_field.get_lsb_pos();
      
      return (mask & reg_data) >> reg_field.get_lsb_pos();
    endfunction
    
    //Getter for the expected reponse
    protected virtual function wishbone_reg_access_status_info get_exp_response(uvm_reg_bus_op operation);
      uvm_reg register;
      
      register = map.get_reg_by_offset(operation.addr, (operation.kind == UVM_READ));
      
      //Any access to a location on which no register is mapped must reutrn an WB error
      if(register == null) begin
        return wishbone_reg_access_status_info::new_instance(UVM_NOT_OK, "Access to a location on which no register is mapped");
      end
      
      //Any write access to a full read-only register must return an WB error.
      if(operation.kind == UVM_WRITE) begin
        uvm_reg_map_info info = map.get_reg_map_info(register);
        
        if(info.rights == "RO") begin
          return wishbone_reg_access_status_info::new_instance(UVM_NOT_OK, "Write access to a full read-only register");
        end
      end
      
      //Any read access from a full write-only register must return an WB error.
      if(operation.kind == UVM_READ) begin
        uvm_reg_map_info info = map.get_reg_map_info(register);
        
        if(info.rights == "WO") begin
          return wishbone_reg_access_status_info::new_instance(UVM_NOT_OK, "Read access from a full write-only register");
        end
      end

      return wishbone_reg_access_status_info::new_instance(UVM_IS_OK, "All OK");
    endfunction
    
	  virtual function void write(BUSTYPE tr);
		uvm_reg_bus_op operation;
		
		wishbone_reg_access_status_info exp_response ;
		
		adapter.bus2reg(tr, operation);
		
		exp_response = get_exp_response(operation);
		
		if(env_config.get_has_checks()) begin
		  if(exp_response.status != UVM_IS_OK) begin
			`uvm_error("ILLEGAL_ACCESS", 
					   $sformatf("Illegal Wishbone access detected: %0s - Access: %0s", exp_response.info, tr.convert2string()))
		  end
		end
		
		// Only update the reg model if access is valid
		if(exp_response.status == UVM_IS_OK) begin
		  super.write(tr);
		end
	  endfunction
	  
    
  endclass

`endif