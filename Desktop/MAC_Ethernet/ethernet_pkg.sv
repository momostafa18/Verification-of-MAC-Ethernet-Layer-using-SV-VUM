`ifndef ETHERNET_ENV_PKG_SV
  `define ETHERNET_ENV_PKG_SV


	`include "uvm_macros.svh"
	`include "pos_l3_agent_pkg.sv"
	`include "xgmii_agent_pkg.sv"
	`include "wb_agent_pkg.sv"
	`include "ethernet_reg_pkg.sv"

	package ethernet_env_pkg;
      import uvm_pkg::*;

	  import pos_l3_agent_pkg::*;
	  import xgmii_agent_pkg::*;
	  import wishbone_agent_pkg:: *;
	  import ethernet_reg_pkg:: *;

      `include "ethernet_reset_handler.sv"
	  `include "ethernet_isr_modeling_value.sv"
	  `include "ethernet_env_config.sv"
	  `include "ethernet_reg_model.sv"
	  `include "ethernet_seq_reg_config.sv"
      `include "ethernet_virtual_sequencer.sv"
	  `include "ethernet_virtual_sequence.sv"
	  `include "wb_reg_access_status_info.sv"
	  `include "wb_reg_predictor.sv"
	  `include "ethernet_scoreboard.sv"
	  `include "ethernet_env.sv"
	  
	  
	  

    endpackage


`endif
