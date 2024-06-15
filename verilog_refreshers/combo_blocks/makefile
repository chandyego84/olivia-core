# Source files
SRCS = mux.v mux_tb.v
SRCS2 = encode_decode.v encode_decode_tb.v

# Executable names for each testbench
EXECS = tb_mux_2_1 tb_mux_4_1 tb_mux_8bus_4_1 tb_structural_mux_8bus_4_1 tb_encoder_4_2

# Default target
all: $(EXECS)

# Individual rules to compile and simulate each testbench
tb_mux_2_1: $(SRCS)
	@echo "Compiling tb_mux_2_1 with source files $^"
	iverilog -o tb_mux_2_1 -s tb_mux_2_1 $^
	@echo "Running simulation for tb_mux_2_1"
	vvp tb_mux_2_1
	@echo "Opening waveform for tb_mux_2_1"
	gtkwave tb_mux_2_1.vcd &

tb_mux_4_1: $(SRCS)
	@echo "Compiling tb_mux_4_1 with source files $^"
	iverilog -o tb_mux_4_1 -s tb_mux_4_1 $^
	@echo "Running simulation for tb_mux_4_1"
	vvp tb_mux_4_1
	@echo "Opening waveform for tb_mux_4_1"
	gtkwave tb_mux_4_1.vcd &

tb_mux_8bus_4_1: $(SRCS)
	@echo "Compiling tb_mux_8bus_4_1 with source files $^"
	iverilog -o tb_mux_8bus_4_1 -s tb_mux_8bus_4_1 $^
	@echo "Running simulation for tb_mux_8bus_4_1"
	vvp tb_mux_8bus_4_1
	@echo "Opening waveform for tb_mux_8bus_4_1"
	gtkwave tb_mux_8bus_4_1.vcd &

tb_structural_mux_8bus_4_1: $(SRCS)
	@echo "Compiling tb_structural_mux_8bus_4_1 with source files $^"
	iverilog -o tb_structural_mux_8bus_4_1 -s tb_structural_mux_8bus_4_1 $^
	@echo "Running simulation for tb_structural_mux_8bus_4_1"
	vvp tb_structural_mux_8bus_4_1
	@echo "Opening waveform for tb_structural_mux_8bus_4_1"
	gtkwave tb_structural_mux_8bus_4_1.vcd &

tb_encoder_4_2: $(SRCS2)
	@echo "Compiling tb_encoder_4_2 with source files $^"
	iverilog -o tb_encoder_4_2 -s tb_encoder_4_2 $^
	@echo "Running simulation for tb_encoder_4_2"
	vvp tb_encoder_4_2
	@echo "Opening waveform for tb_encoder_4_2"
	gtkwave tb_encoder_4_2.vcd &

clean:
	del -f $(EXECS) *.vcd
