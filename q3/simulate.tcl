vlog -sv ./q3/up_down_counter.sv
vlog -sv ./q3/up_down_counter_tb.sv

vsim -voptargs=+acc -debugDB work.up_down_counter_tb

run 1000000000ns
