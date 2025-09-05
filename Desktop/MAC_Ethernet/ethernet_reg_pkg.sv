
`ifndef ETHERNET_REGISTER_PACKAGE
	`define ETHERNET_REGISTER_PACKAGE
	
	`include "uvm_macros.svh"
 	package ethernet_reg_pkg;
    	import uvm_pkg::*;

	`include "ethernet_reg_config.sv"
	`include "ethernet_reg_intmask.sv"
	`include "ethernet_reg_intstat.sv"
	`include "ethernet_reg_intpend.sv"
	`include "ethernet_reg_block.sv"



	endpackage

`endif