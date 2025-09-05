`ifndef ETHERNET_INTERRUPT_PENDING_REGISTER
	`define ETHERNET_INTERRUPT_PENDING_REGISTER

class ethernet_reg_interrupt_pending extends uvm_reg ;
  
  rand uvm_reg_field TX_Data_FIFO_Overflow;
  rand uvm_reg_field TX_Data_FIFO_Underflow;
  
  rand uvm_reg_field RX_Data_FIFO_Overflow;
  rand uvm_reg_field RX_Data_FIFO_Underflow;
  
  rand uvm_reg_field local_fault;
  rand uvm_reg_field remote_fault;
  
  rand uvm_reg_field RX_Pause_Frame;
  
  rand uvm_reg_field RX_CRC_Error;
  
  rand uvm_reg_field RX_Fragment_Error;

  `uvm_object_utils(ethernet_reg_interrupt_pending)
  
  function new(string name = "");
      super.new(.name(name), .n_bits(32), .has_coverage(UVM_NO_COVERAGE));
    endfunction
	
  /*virtual task post_read(uvm_reg_item rw);
    super.post_read(rw);

    // Clear the mirror in the reg model
    predict(0);
  endtask*/
      
virtual function void build();


    TX_Data_FIFO_Overflow = uvm_reg_field::type_id::create(.name("TX_Data_FIFO_Overflow"), .parent(null), .contxt(get_full_name()));
    TX_Data_FIFO_Overflow.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                0),
        .access(                 "RC"),
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
        .access(                 "RC"),
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
        .access(                 "RC"),
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
        .access(                 "RC"),
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
        .access(                 "RC"),
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
        .access(                 "RC"),
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
        .access(                 "RC"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

    RX_CRC_Error = uvm_reg_field::type_id::create(.name("RX_CRC_Error"), .parent(null), .contxt(get_full_name()));
    RX_CRC_Error.configure(
        .parent(                 this),
        .size(                   1),
        .lsb_pos(                7),
        .access(                 "RC"),
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
        .access(                 "RC"),
        .volatile(               0),
        .reset(                  1'b0),
        .has_reset(              1),
        .is_rand(                0),
        .individually_accessible(1));

  endfunction

  
endclass
`endif


