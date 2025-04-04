`timescale 1ns/1ps

module olivia_test;

    // Inputs
    reg clk;
    reg rst;

    // Wires to observe outputs
    wire [63:0] pc_out;
    wire [63:0] adder_out;
    wire [31:0] instruction;

    // Instantiate the Olivia CPU (Program Counter and Adder implemented)
    Olivia uut (
        .clk(clk), 
        .rst(rst)
    );

    // Clock generation: 10 ns period (100 MHz clock)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;  
                
        // Observe program counter behavior
        #100;  // Let the system run for some time

        // End simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %t | clk: %b | rst: %b | pc_out: %d | adder_out: %d", 
                  $time, clk, rst, uut.pc_out, uut.adder_out);
    end

endmodule
