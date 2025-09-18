vlog -sv ./q1/shift_register.sv
vlog -sv ./q1/shift_register_tb.sv

vsim -voptargs=+acc -debugDB work.shift_register_tb

# Add your waveforms signals here

add wave -position insertpoint  \
sim:/shift_register_tb/N \
sim:/shift_register_tb/loops \
sim:/shift_register_tb/clk \
sim:/shift_register_tb/rst_n \
sim:/shift_register_tb/serial_parallel \
sim:/shift_register_tb/load_enable \
sim:/shift_register_tb/serial_in \
sim:/shift_register_tb/parallel_in \
sim:/shift_register_tb/parallel_out \
sim:/shift_register_tb/serial_out \

run 1000000000ns
