`timescale 1ns/1ps

module pc_im_tb;

    // inputs
    reg clk;
    reg rst;
    reg [63:0] pc_in;

    // outputs
    wire [63:0] pc_out;
    wire [31:0] instruction;
    
    always #5 clk = ~clk; // 10 ns clk period

    // Instantiate PC
    ProgramCounter uut_pc (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Instantiate IM
    InstructionMemory uut_im (
        .pc_addr(pc_out),
        .instruction(instruction)
    );

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;  
        pc_in = 0; 

        #10 rst = 0;

        // step through PC
        repeat (16) begin
            #10;
            pc_in = pc_out + 4;
        end

        // End simulation
        $finish;

    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t | clk = %b | rst = %b | PC = %0d | Instruction = 0x%h", $time, clk, rst, pc_out, instruction);
    end

endmodule
