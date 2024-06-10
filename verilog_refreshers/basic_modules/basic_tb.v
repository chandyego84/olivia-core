`timescale 1ns/1ns

module tb_AND;
    reg a, b;
    wire c;

    AND uut(.a(a), .b(b), .c(c));

    initial begin
        $dumpfile("tb_AND.vcd");
        $dumpvars(0, tb_AND);

        a = 1'b0;
        b = 1'b0;
        #10;

        a = 1'b0;
        b = 1'b1;
        #10;

        a = 1'b1;
        b = 1'b0;
        #10;

        a = 1'b1;
        b=1'b1;
        #10;
    end

    initial begin
        $monitor("and: a=%b, b=%b, c=%b \n", a, b, c);
    end

endmodule

module tb_OR;
    reg a, b;
    wire c;

    OR uut(.a(a), .b(b), .c(c));

    initial begin
        $dumpfile("tb_OR.vcd");
        $dumpvars(0, tb_OR);

        a = 1'b0;
        b = 1'b0;
        #10;

        a = 1'b0;
        b = 1'b1;
        #10;

        a = 1'b1;
        b = 1'b0;
        #10;

        a = 1'b1;
        b=1'b1;
        #10;
    end

    initial begin
        $monitor("or: a=%b, b=%b, c=%b\n", a, b, c);
    end

endmodule

module tb_NOR;
    reg a, b;
    wire c;

    NOR uut(.a(a), .b(b), .c(c));

    initial begin
        $dumpfile("tb_NOR.vcd");
        $dumpvars(0, tb_NOR);

        a = 1'b0;
        b = 1'b0;
        #10;

        a = 1'b0;
        b = 1'b1;
        #10;

        a = 1'b1;
        b = 1'b0;
        #10;

        a = 1'b1;
        b=1'b1;
        #10;
    end

    initial begin
        $monitor("nor: a=%b, b=%b, c=%b\n", a, b, c);
    end

endmodule

module tb_NAND;
    reg a, b;
    wire c;

    NAND uut(.a(a), .b(b), .c(c));

    initial begin
        $dumpfile("tb_NAND.vcd");
        $dumpvars(0, tb_NAND);

        a = 1'b0;
        b = 1'b0;
        #10;

        a = 1'b0;
        b = 1'b1;
        #10;

        a = 1'b1;
        b = 1'b0;
        #10;

        a = 1'b1;
        b=1'b1;
        #10;
    end

    initial begin
        $monitor("nand: a=%b, b=%b, c=%b\n", a, b, c);
    end

endmodule

module tb_XOR;
    reg a, b;
    wire c;

    XOR uut(.a(a), .b(b), .c(c));

    initial begin
        $dumpfile("tb_XOR.vcd");
        $dumpvars(0, tb_XOR);

        a = 1'b0;
        b = 1'b0;
        #10;

        a = 1'b0;
        b = 1'b1;
        #10;

        a = 1'b1;
        b = 1'b0;
        #10;

        a = 1'b1;
        b=1'b1;
        #10;
    end

    initial begin
        $monitor("xor: a=%b, b=%b, c=%b\n", a, b, c);
    end

endmodule

module tb_XNOR;
    reg a, b;
    wire c;

    XNOR uut(.a(a), .b(b), .c(c));

    initial begin
        $dumpfile("tb_XNOR.vcd");
        $dumpvars(0, tb_XNOR);

        a = 1'b0;
        b = 1'b0;
        #10;

        a = 1'b0;
        b = 1'b1;
        #10;

        a = 1'b1;
        b = 1'b0;
        #10;

        a = 1'b1;
        b=1'b1;
        #10;
    end

    initial begin
        $monitor("xnor: a=%b, b=%b, c=%b\n", a, b, c);
    end

endmodule