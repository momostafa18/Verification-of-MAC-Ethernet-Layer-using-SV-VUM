`ifndef WISHBONE_SEQUENCE_SIMPLE_SV
  `define WISHBONE_SEQUENCE_SIMPLE_SV

  class wishbone_sequence_simple extends wishbone_sequence_base;

    rand wishbone_item_drv item;
    
    `uvm_object_utils(wishbone_sequence_simple)
    
    function new(string name = "");
      super.new(name);
      
     item = wishbone_item_drv::type_id::create("item");
    endfunction

  //Body Task
  task body;
     start_item(item);
	 finish_item(item);

  endtask

  endclass
`endif	

