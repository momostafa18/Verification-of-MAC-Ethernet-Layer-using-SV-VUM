`ifndef ETHERNET_TEST_PKG_SV
  `define ETHERNET_TEST_PKG_SV


	`include "uvm_macros.svh"
	`include "ethernet_pkg.sv"

	package ethernet_test_pkg;

      import uvm_pkg::*;
	  import ethernet_env_pkg::*;
	  import pos_l3_agent_pkg::*;
	  import xgmii_agent_pkg::*;
	  import wishbone_agent_pkg::*;

      `include "ethernet_test_base.sv"
	  `include "pos_l3_ethernet_random_test.sv"
	  `include "xgmii_ethernet_random_test.sv"
	  `include "ethernet_reg_access_test.sv"
	  
    endpackage


`endif
