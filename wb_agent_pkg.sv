
`ifndef WISHBONE_AGENT_PKG
  `define WISHBONE_AGENT_PKG

	`include "uvm_macros.svh"
    `include "wishbone_intf.sv"

  package wishbone_agent_pkg;
	 import uvm_pkg::*;
	  
	  `include "wishbone_reset_handler.sv"
	  `include "wishbone_agent_config.sv"
	  `include "wishbone_item_base.sv"
      `include "wishbone_item_drv.sv"
	  `include "wishbone_item_mon.sv"
	  `include "wishbone_driver.sv"
	  `include "wishbone_sequencer.sv"
	  `include "wishbone_monitor.sv"
	  //`include "wishbone_coverage.sv"
	  `include "wishbone_sequence_base.sv"
	  `include "wishbone_sequence_simple.sv"
	  `include "wishbone_sequence_random.sv"
	  `include "wishbone_agent.sv"
	  

	 endpackage

`endif
