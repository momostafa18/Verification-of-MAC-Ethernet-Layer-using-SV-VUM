import "DPI-C" context function void crc32_reset();
import "DPI-C" context function void crc32_update(longint unsigned word, int valid_bytes);
import "DPI-C" context function int unsigned crc32_finalize();

`ifndef XGMII_SEQUENCE_ADDRESSES_SV
`define XGMII_SEQUENCE_ADDRESSES_SV

class xgmii_sequence_addresses extends xgmii_sequence_base;


  rand bit [15:0]  data_part;
  rand bit [63:0]  data;
  int unsigned num_cycles;

  bit pauseYES = 0;

  bit [31:0] crc_accum;   

  `uvm_object_utils(xgmii_sequence_addresses)
    
  function new(string name = "");
    super.new(name);
  endfunction

  //Body Task
  task body;
    void'(item.randomize());
    num_cycles = (item.type_len + 7) / 8;

    crc32_reset();   // <---- start CRC fresh

    start_item(item);
    send_destination_address();
    finish_item(item);

    start_item(item);
    send_source_address();
    finish_item(item);

    
	if(item.type_len < 1500) begin
      for (int i = 0 ; i < num_cycles ; i++) begin  
        start_item(item);
        void'(randomize(data));  
        send_payload();
        finish_item(item);
      end
    end
    else begin
      for (int i = 0 ; i < 10 ; i++) begin  
        start_item(item);
        void'(randomize(data));  
        send_payload();
        finish_item(item);
      end
    end

    start_item(item);
    send_crc();
    finish_item(item);

  endtask

  task send_destination_address();
    if(!pauseYES) begin
      item.xgmii_rxd[47:0]  = item.DA;
      item.xgmii_rxd[63:48] = item.SA[15:0]; 
      item.xgmii_rxc        = 8'h00;
    end
    else begin
      item.xgmii_rxd[47:0]  = 'h0180C2000001;
      item.xgmii_rxd[63:48] = item.SA[15:0]; 
      item.xgmii_rxc        = 8'h00;
    end

    // feed first 64b word into DPI
    crc32_update(item.xgmii_rxd, 8);
  endtask

  task send_source_address();
    item.xgmii_rxd[31:0]   = item.SA[47:16];

    if(!pauseYES) begin
      item.xgmii_rxd[47:32]  = item.type_len; 
      item.xgmii_rxd[63:48]  = data_part; 
    end
    else begin
      item.xgmii_rxd[47:32]  = 'h8808; 
      item.xgmii_rxd[63:48]  = 'h0001; 
    end
    
    item.xgmii_rxc         = 8'h00;

    // feed 64b word into DPI
    crc32_update(item.xgmii_rxd, 8);
  endtask

  task send_payload();
    if(!pauseYES) begin
      item.xgmii_rxc = 8'h00;
      item.xgmii_rxd = data;
      crc32_update(data, 8);
    end 
    else begin
      item.xgmii_rxd[15:0] = 'h00FF;
	  item.xgmii_rxd[63:16] = 48'h0;
      item.xgmii_rxc       = 8'h00;
      crc32_update(item.xgmii_rxd, 8); 
    end
  endtask

  task send_crc();
    crc_accum = crc32_finalize();  // <-- get final CRC from C code
	item.crc_calc = crc_accum ;
    item.xgmii_rxd  = {8'h07, 8'h07, 8'h07, 8'hFD,
                       crc_accum[31:24], crc_accum[23:16],
                       crc_accum[15:8],  crc_accum[7:0]};
    item.xgmii_rxc  = 8'b11110000;
  endtask

endclass
`endif
