`timescale 1ns/1ps

module control_alu_tb;
    initial begin
        $dumpfile("testbenches/wave.vcd");
        $dumpvars(0);
    end

    // Inputs
    reg [31:0] instruction;
    wire [2:0] op_code_bits;
    wire [1:0] alu_op;
    
    // Control Unit Outputs
    wire REG2LOC;
    wire ALU_SRC;
    wire MEM2REG;
    wire REG_WRITE;
    wire MEM_READ;
    wire MEM_WRITE;
    wire BRANCH;

    // ALU Control Outputs
    wire [3:0] ALU_SIGNAL;

    // Instantiate Control Unit
    Control_Unit CU (
        .instruction(instruction),
        .REG2LOC(REG2LOC),
        .ALU_SRC(ALU_SRC),
        .MEM2REG(MEM2REG),
        .REG_WRITE(REG_WRITE),
        .MEM_READ(MEM_READ),
        .MEM_WRITE(MEM_WRITE),
        .BRANCH(BRANCH),
        .ALU_OP(alu_op)
    );

    // Instantiate ALU Control
    ALU_Control ACU (
        .alu_op(alu_op),
        .op_code_bits(op_code_bits),
        .ALU_SIGNAL(ALU_SIGNAL)
    );

    task print_test_result(
        input [80*8:1] name,
        input [80*8:1] expected_ctrl,
        input [3:0] expected_alu_signal
    );
        begin
            $display("\n=== %s ===", name);
            $display("==INSTRUCTION: %b (len=%0d)", instruction, $bits(instruction));
            $display("Actual   : R2L:%b AS:%b M2R:%b RW:%b MR:%b MW:%b B:%b | ALU_OP=%02b | 3_OP_CODE = %03b | ALU_SIGNAL=%04b", 
                        REG2LOC, ALU_SRC, MEM2REG, REG_WRITE, MEM_READ, MEM_WRITE, BRANCH, alu_op, op_code_bits, ALU_SIGNAL);
            $display("Expected : %s | ALU_SIGNAL=%04b", expected_ctrl, expected_alu_signal);
        end
    endtask

    assign op_code_bits = {instruction[30], instruction[29], instruction[24]};
    
    initial begin
        $display("==== Control Unit & ALU Control Testbench ====");

        instruction = 32'b0;
        #10;

        // R-Type: ADD
        instruction[31:0] = 32'b10001011000_00000_00001_00010_000000;        
        #20;
        print_test_result("R-TYPE ADD", "R2L:0 AS:0 M2R:0 RW:1 MR:0 MW:0 B:0", 4'b0010);

        // R-Type: SUB
        instruction[31:0] = 32'b11001011000_00000_00001_00010_000000;
        #20;
        print_test_result("R-TYPE SUB", "R2L:0 AS:0 M2R:0 RW:1 MR:0 MW:0 B:0", 4'b0110);

        // R-Type: AND
        instruction[31:0] = 32'b10001010000_00000_00001_00010_000000;
        #20;
        print_test_result("R-TYPE AND", "R2L:0 AS:0 M2R:0 RW:1 MR:0 MW:0 B:0", 4'b0000);

        // R-Type: ORR
        instruction[31:0] = 32'b10101010000_00000_00001_00010_000000;
        #20;
        print_test_result("R-TYPE ORR", "R2L:0 AS:0 M2R:0 RW:1 MR:0 MW:0 B:0", 4'b0001);

        // LOAD
        instruction[31:0] = 32'b00000000000_00000_00000_00000_000000; // clear everything
        instruction[31:21] = 11'd1986;
        #20;
        print_test_result("LOAD", "R2L:0 AS:1 M2R:1 RW:1 MR:1 MW:0 B:0", 4'b0010);

        // STORE
        instruction[31:0] = 32'b00000000000_00000_00000_00000_000000;
        instruction[31:21] = 11'd1984;
        #20;
        print_test_result("STORE", "R2L:1 AS:1 M2R:0 RW:0 MR:0 MW:1 B:0", 4'b0010);

        // CBZ
        instruction[31:0] = 32'b000000_000000000000000000000000000;
        instruction[31:24] = 8'd180;
        #20;
        print_test_result("CBZ", "R2L:1 AS:0 M2R:0 RW:0 MR:0 MW:0 B:1", 4'b0111);

        $display("\n==== Test Complete ====");
        $finish;
    end

endmodule
