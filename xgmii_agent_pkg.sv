
`ifndef XGMII_AGENT_PKG
  `define XGMII_AGENT_PKG

	`include "uvm_macros.svh"
    `include "xgmii_intf.sv"

  package xgmii_agent_pkg;
	 import uvm_pkg::*;
	  
	  `include "xgmii_reset_handler.sv"
	  `include "xgmii_agent_config.sv"
	  `include "xgmii_item_base.sv"
      `include "xgmii_item_drv.sv"
	  `include "xgmii_item_mon.sv"
	  `include "xgmii_driver.sv"
	  `include "xgmii_sequencer.sv"
	  `include "xgmii_monitor.sv"
	  //`include "xgmii_coverage.sv"
	  `include "xgmii_sequence_base.sv"
	  `include "xgmii_sequence_simple.sv"
	  `include "xgmii_sequence_idle.sv"
	  `include "xgmii_data_sequence.sv"
	  `include "xgmii_sequence_preamble&SFD.sv"
	  `include "xgmii_sequence_addresses.sv"
	  //`include "xgmii_sequence_random.sv"
	  `include "xgmii_agent.sv"
	  

	 endpackage

`endif