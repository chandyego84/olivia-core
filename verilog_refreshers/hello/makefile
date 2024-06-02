TARGET = hello_run

SRCS = hello_tb.v hello.v

# default rule
all: run

# compile the verilog files
run: $(SRCS)
	iverilog -o $(TARGET) $(SRCS)

# run simulation -- `: run` indicates it depends on `run` target. ensures `run` is executed before `simulate`.
sim: run
	vvp $(TARGET)

clean:
	del -f $(TARGET)