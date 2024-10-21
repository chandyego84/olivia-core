`timescale 1ns/1ps

module pc_tb;

    // inputs
    reg clk;
    reg rst;
    reg [63:0] pc_in;

    // outputs
    wire [63:0] pc_out;
    wire [63:0] adder_out;

    // params
    parameter INC_VALUE = 4'd4; // increment by 4 each cycle

    // Instantiate the ProgramCounter
    ProgramCounter uut_pc (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Instantiate the Adder
    Adder uut_adder (
        .inc(INC_VALUE),
        .pc_out(pc_out),
        .adder_out(adder_out)
    );

    // Clock generation: period of 10 ns (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;  // Start with reset active
        pc_in = 64'd0; // Initialize pc_in

        // Apply reset
        #10 rst = 0;  // Release reset

        // Set initial value for pc_in
        #10 pc_in = 64'd8; // Set initial pc_in to 8

        // Wait for two clock cycles to let it propagate
        #10;

        // TEST: Increment PC and check outputs
        #10 assign pc_in = adder_out;  // Set pc_in to the output of the adder

        // Let simulation run for some time to observe behavior
        #50;

        // End simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %t | clk: %b | rst: %b | pc_in: %d | pc_out: %d | adder_out: %d", 
                  $time, clk, rst, pc_in, pc_out, adder_out);
    end
endmodule
