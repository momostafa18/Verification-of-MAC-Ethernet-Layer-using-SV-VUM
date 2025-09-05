#do {C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/sim_home.do}

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/fault_sm.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/generic_fifo.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/generic_fifo_ctrl.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/generic_mem_medium.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/generic_mem_small.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/meta_sync.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/meta_sync_single.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/rx_data_fifo.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/rx_dequeue.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/rx_enqueue.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/rx_hold_fifo.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/sync_clk_core.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/sync_clk_wb.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/sync_clk_xgmii_tx.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/tx_data_fifo.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/tx_dequeue.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/tx_enqueue.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/tx_hold_fifo.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/wishbone_if.v"

vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/rtl/verilog/xge_mac.v"

vlog -ccflags "-std=c++11" -dpiheader CRC.h CRC.cpp


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/pos_l3_agent_pkg.sv"


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/xgmii_agent_pkg.sv"


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/wb_agent_pkg.sv"


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/ethernet_pkg.sv"


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/ethernet_reg_pkg.sv"


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/ethernet_tst_pkg.sv"


vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/MAC_Ethernet/testbench.sv"



#vlog -timescale 1ps/1ps "C:/Users/mohamedmostafamohame/Desktop/xge_mac-master/tbench/verilog/tb_xge_mac.v"



vsim -voptargs="+acc" work.TestBench +uvm_set_verbosity=*,REG_PREDICT,UVM_HIGH

#add wave sim:/TestBench/*

add wave -divider

add wave sim:/TestBench/dut/*

add wave -divider

add wave sim:/TestBench/dut/rx_eq0/*

add wave -divider

add wave sim:/TestBench/dut/rx_data_fifo0/*

add wave -divider

add wave sim:/TestBench/dut/rx_dq0/*

add wave -divider
add wave -divider
add wave -divider

add wave sim:/TestBench/dut/tx_eq0/*

add wave -divider

add wave sim:/TestBench/dut/tx_data_fifo0/*

add wave -divider

add wave sim:/TestBench/dut/tx_dq0/*

add wave -divider

add wave sim:/TestBench/dut/fault_sm0/*

add wave -divider

add wave sim:/TestBench/dut/wishbone_if0/*

#run 1000ns
