####
### TODO: NEED TO UPDATE WITH ALU MODULES, e.g., SIGN EXTEND, ALU MUX 
####

# Variables
IVERILOG = iverilog
VVP = vvp
GTKWAAVE = gtkwave

# Testbench folder
TB_DIR = testbenches

# Source files
SRCS = Olivia.v Program_Counter.v PC_Adder.v Instruction_Memory.v Register_Mux.v Register_File.v Control_Unit.v ALU_Control.v ALU.v
PC_TB = $(TB_DIR)/pc_tb.v
PC_IM_TB = $(TB_DIR)/pc_im_tb.v
REG_FILE_TB = $(TB_DIR)/register_file_tb.v
CONTROL_ALU_TB = $(TB_DIR)/control_alu_tb.v
ALU_TB = $(TB_DIR)/alu_tb.v
OLIVIA_TB = $(TB_DIR)/olivia_tb.v

# Output files
PC_OUT = $(TB_DIR)/pc_tb.out
PC_IM_OUT = $(TB_DIR)/pc_im_tb.out
REG_FILE_OUT = $(TB_DIR)/register_file_tb.out
CONTROL_ALU_OUT = $(TB_DIR)/control_alu_tb.out
ALU_OUT = $(TB_DIR)/alu_tb.out
OLIVIA_OUT = $(TB_DIR)/olivia_tb.out
VCD = $(TB_DIR)/wave.vcd

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

# Compile and run the Register_File testbench
run_registers: $(REG_FILE_TB) Register_File.v Register_Mux.v
	$(IVERILOG) -o $(REG_FILE_OUT) $(REG_FILE_TB) Register_File.v Register_Mux.v
	$(VVP) $(REG_FILE_OUT) 

# For ALU control block
run_control_alu: $(CONTROL_ALU_TB) Control_Unit.v ALU_CONTROL.v
	$(IVERILOG) -o $(CONTROL_ALU_OUT) $(CONTROL_ALU_TB) Control_Unit.v ALU_CONTROL.v
	$(VVP) $(CONTROL_ALU_OUT)

# For ALU
run_alu: $(ALU) ALU.v
	$(IVERILOG) -o $(ALU_OUT) $(ALU_TB) ALU.v
	$(VVP) $(ALU_OUT)

# View waveform for Olivia testbench
view_olivia: run_olivia
	$(GTKWAAVE) $(VCD)

# View waveform for PC testbench
view_pc: run_pc
	$(GTKWAAVE) $(VCD)

# View waveform for Control Unit and ALU Control
view_controllers: run_control_alu
	$(GTKWAAVE) $(VCD)

# Clean up generated files
clean:
	del -f $(TB_DIR)\\*.out $(TB_DIR)\\*.vcd

.PHONY: all run_olivia run_pc run_pc_im run_registers run_control_alu \
        view_olivia view_pc view_controllers clean
