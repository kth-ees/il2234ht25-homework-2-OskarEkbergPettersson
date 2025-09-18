# Makefile for running ModelSim simulation

# Variables
VSIM     = vsim
DO_DIR   = ./q1
DO_FILE  = ./$(DO_DIR)/simulate.tcl

# Default target
all: simulate

simulate:
	$(VSIM) -do $(DO_FILE)

# Clean up simulation outputs
clean:
	rm -rf transcript vsim.wlf vsim_stacktrace.vstf vish_stacktrace.vstf work

.PHONY: all simulate clean

