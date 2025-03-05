# Makefile for Olivia project

# Variables
IVERILOG = iverilog
VVP = vvp
GTKWAAVE = gtkwave

# Source files
SRCS = Olivia.v ProgramCounter.v Adder.v InstructionMemory.v
PC_TB = pc_tb.v
PC_IM_TB = pc_im_tb.v
OLIVIA_TB = olivia_tb.v

# Output files
PC_OUT = pc_tb.out
PC_IM_OUT = pc_im_tb.out
OLIVIA_OUT = olivia_tb.out
VCD = wave.vcd

# Targets
all: run_olivia

# Compile and run the Olivia testbench
run_olivia: $(OLIVIA_TB) $(SRCS)
	$(IVERILOG) -o $(OLIVIA_OUT) $(OLIVIA_TB) $(SRCS)
	$(VVP) $(OLIVIA_OUT)

# Compile and run the Program Counter + Instruction Memory testbench
run_pc_im: $(PC_IM_TB) $(SRCS)
	$(IVERILOG) -o $(PC_IM_OUT) $(PC_IM_TB) $(SRCS)
	$(VVP) $(PC_IM_OUT)

# Compile and run the Program Counter testbench
run_pc: $(PC_TB) $(SRCS)
	$(IVERILOG) -o $(PC_OUT) $(PC_TB) $(SRCS)
	$(VVP) $(PC_OUT)

# View waveform for Olivia testbench
view_olivia: run_olivia
	$(GTKWAAVE) $(VCD)

# View waveform for PC testbench
view_pc: run_pc
	$(GTKWAAVE) $(VCD)

# Clean up generated files
clean:
	del -f *.out *.vcd

.PHONY: all run_olivia run_pc view_olivia view_pc clean
