class Packet extends uvm_object;
  bit 	   [63:0] sop = 64'h1000010000010000;
  bit 	   [63:0] eop = 64'h00000000002c2b2a;
  rand bit [63:0] pkt_data;

  `uvm_object_utils_begin(Packet)
  	`uvm_field_int(sop     , UVM_HIGH)
  	`uvm_field_int(pkt_data, UVM_DEFAULT)
  	`uvm_field_int(eop     , UVM_HIGH)
  `uvm_object_utils_end

  function new(string name = "Packet");
    super.new(name);
  endfunction
endclass
