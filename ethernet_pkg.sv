`ifndef ETHERNET_ENV_PKG_SV
  `define ETHERNET_ENV_PKG_SV


	`include "uvm_macros.svh"
	`include "pos_l3_agent_pkg.sv"
	`include "xgmii_agent_pkg.sv"
	`include "wb_agent_pkg.sv"

	package ethernet_env_pkg;
      import uvm_pkg::*;

	  import pos_l3_agent_pkg::*;
	  import xgmii_agent_pkg::*;
	  import wishbone_agent_pkg:: *;

      `include "ethernet_env.sv"
    endpackage


`endif
