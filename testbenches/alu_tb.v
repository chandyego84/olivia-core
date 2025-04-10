`timescale 1ns / 1ps

module ALU_tb;

    reg [63:0] data_a;
    reg [63:0] data_b;
    reg [3:0] alu_signal;
    wire [63:0] alu_result;
    wire ZERO_FLAG;

    reg [63:0] expected_result;
    reg expected_zero;

    // Instantiate the ALU
    ALU uut (
        .data_a(data_a),
        .data_b(data_b),
        .alu_signal(alu_signal),
        .alu_result(alu_result),
        .ZERO_FLAG(ZERO_FLAG)
    );

    // Task to run a test and check results
    task run_test(
        input [63:0] a,
        input [63:0] b,
        input [3:0] signal,
        input [63:0] exp_result,
        input exp_zero
    );
    begin
        // initialize ALU inputs
        data_a = a;
        data_b = b;
        alu_signal = signal;

        // expected outputs
        expected_result = exp_result;
        expected_zero = exp_zero;
        #10;

        $display("A=%h | B=%h | Signal=%b", data_a, data_b, alu_signal);
        $display("Expected: Result=%h ZERO=%b", expected_result, expected_zero);
        $display("Actual:   Result=%h ZERO=%b", alu_result, ZERO_FLAG);

        if (alu_result === expected_result && ZERO_FLAG === expected_zero)
            $display("PASS\n");
        else
            $display("FAIL\n");
    end
    endtask

    initial begin
        $display("==== ALU Testbench Start ====");

        // AND
        run_test(64'hFF00FF00FF00FF00, 64'h00FF00FF00FF00FF, 4'b0000,
                 64'h0000000000000000, 1'b1);

        // OR
        run_test(64'hFF00FF00FF00FF00, 64'h00FF00FF00FF00FF, 4'b0001,
                 64'hFFFFFFFFFFFFFFFF, 1'b0);

        // ADD
        run_test(64'd100, 64'd50, 4'b0010,
                 64'd150, 1'b0);

        // SUB
        run_test(64'd100, 64'd50, 4'b0110,
                 64'd50, 1'b0);

        // PASS B
        run_test(64'hDEADBEEFCAFEBABE, 64'h1122334455667788, 4'b0111,
                 64'h1122334455667788, 1'b0);

        // NOR
        run_test(64'h00000000FFFFFFFF, 64'hFFFFFFFF00000000, 4'b1100,
                 64'h0000000000000000, 1'b1);

        // SUB = 0
        run_test(64'd42, 64'd42, 4'b0110,
                 64'd0, 1'b1);

        $display("==== ALU Testbench Complete ====");
        $finish;
    end

endmodule
