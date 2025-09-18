vlog -sv ./q2/LFSR_6bit.sv
vlog -sv ./q2/LFSR_6bit_tb.sv

vsim -voptargs=+acc -debugDB work.LFSR_6bit_tb

run 1000000000ns
