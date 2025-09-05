`ifndef ETHERNET_INTERRUPT_STATUS_REGISTER
	`define ETHERNET_INTERRUPT_STATUS_REGISTER

class ethernet_reg_interrupt_status extends uvm_reg ;
  
  rand uvm_reg_field TX_Data_FIFO_Overflow;
  rand uvm_reg_field TX_Data_FIFO_Underflow;
  
  rand uvm_reg_field RX_Data_FIFO_Overflow;
  rand uvm_reg_field RX_Data_FIFO_Underflow;
  
  rand uvm_reg_field local_fault;
  rand uvm_reg_field remote_fault;
  
  rand uvm_reg_field RX_Pause_Frame;
  
  rand uvm_reg_field RX_CRO_Error;
  
  rand uvm_reg_field RX_Fragment_Error;

  `uvm_object_utils(ethernet_reg_interrupt_status)
  
  function new(string name = "");
      super.new(.name(name), .n_bits(32), .has_coverage(UVM_NO_COVERAGE));
    endfunction
	
	/*virtual task write(output uvm_status_e status,
						input  uvm_reg_data_t value,
						input  uvm_path_e path = UVM_DEFAULT_PATH,
						input  uvm_reg_map map = null,
						input 	uvm_sequence_base 	parent	 = 	null,
						input 	int 	prior	 = 	-1,
						input 	uvm_object 	extension	 = 	null,
						input 	string 	fname	 = 	"",
						input 	int 	lineno	 = 	0);
    `uvm_error("RO_REG_WRITE",
               $sformatf("Attempted WRITE to read-only register %s (value=0x%0h)",
                         get_name(), value))
    status = UVM_NOT_OK;
  endtask*/
  
    
virtual function void build();
    TX_Data_FIFO_Overflow = uvm_reg_field::type_id::create(.name("TX_Data_FIFO_Overflow"), .parent(null), .contxt(get_full_name()));
    TX_Data_FIFO_Overflow.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                0),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    TX_Data_FIFO_Underflow = uvm_reg_field::type_id::create(.name("TX_Data_FIFO_Underflow"), .parent(null), .contxt(get_full_name()));
    TX_Data_FIFO_Underflow.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                1),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    RX_Data_FIFO_Overflow = uvm_reg_field::type_id::create(.name("RX_Data_FIFO_Overflow"), .parent(null), .contxt(get_full_name()));
    RX_Data_FIFO_Overflow.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                2),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    RX_Data_FIFO_Underflow = uvm_reg_field::type_id::create(.name("RX_Data_FIFO_Underflow"), .parent(null), .contxt(get_full_name()));
    RX_Data_FIFO_Underflow.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                3),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    local_fault = uvm_reg_field::type_id::create(.name("local_fault"), .parent(null), .contxt(get_full_name()));
    local_fault.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                4),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    remote_fault = uvm_reg_field::type_id::create(.name("remote_fault"), .parent(null), .contxt(get_full_name()));
    remote_fault.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                5),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    RX_Pause_Frame = uvm_reg_field::type_id::create(.name("RX_Pause_Frame"), .parent(null), .contxt(get_full_name()));
    RX_Pause_Frame.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                6),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    RX_CRO_Error = uvm_reg_field::type_id::create(.name("RX_CRO_Error"), .parent(null), .contxt(get_full_name()));
    RX_CRO_Error.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                7),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    RX_Fragment_Error = uvm_reg_field::type_id::create(.name("RX_Fragment_Error"), .parent(null), .contxt(get_full_name()));
    RX_Fragment_Error.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                8),
        .access(                 "RO"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

endfunction

endclass
`endif


