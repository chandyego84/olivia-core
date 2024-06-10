SRCS = basic.v basic_tb.v

EXECS = tb_AND tb_OR tb_NOR tb_NAND tb_XOR tb_XNOR

all: $(EXECS)

tb_AND: $(SRCS)
	iverilog -o tb_AND -s tb_AND $^
	vvp tb_AND
	gtkwave tb_AND.vcd &

tb_OR: $(SRCS)
	iverilog -o tb_OR -s tb_OR $^
	vvp tb_OR
	gtkwave tb_OR.vcd &

tb_NOR: $(SRCS)
	iverilog -o tb_NOR -s tb_NOR $^
	vvp tb_NOR
	gtkwave tb_NOR.vcd &

tb_NAND: $(SRCS)
	iverilog -o tb_NAND -s tb_NAND $^
	vvp tb_NAND
	gtkwave tb_NAND.vcd &

tb_XOR: $(SRCS)
	iverilog -o tb_XOR -s tb_XOR $^
	vvp tb_XOR
	gtkwave tb_XOR.vcd &

tb_XNOR: $(SRCS)
	iverilog -o tb_XNOR -s tb_XNOR $^
	vvp tb_XNOR
	gtkwave tb_XNOR.vcd &

clean:
	del -f $(EXECS) *.vcd