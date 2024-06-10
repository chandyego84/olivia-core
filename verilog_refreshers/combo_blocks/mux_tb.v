`timescale 1ns/1ns

// tb for 1-bit, 2:1 mux
module tb_mux_2_1;
    reg i_a, i_b, select;
    wire o_data;

    mux_2_1 uut(.i_a(i_a), .i_b(i_b), .select(select), .o_data(o_data));

    initial begin
        $dumpfile("tb_mux_2_1.vcd");
        $dumpvars(0, tb_mux_2_1);

        // test 1
        i_a = 1'b0;
        i_b = 1'b1;
        select = 1'b0;
        #10;

        // test 2
        i_a = 1'b0;
        i_b = 1'b1;
        select = 1'b0;
        #10;
    end

    initial begin
        $monitor("2-1: a=%b, b=%b, s=%b, o=%b\n", i_a, i_b, select, o_data);
    end

endmodule

// tb for 1-bit, 4:1 mux
module tb_mux_4_1;
    reg a, b, c, d;
    reg [1:0] sel;

    wire out;

    mux_4_1 uut(.a(a), .b(b), .c(c), .sel(sel), .out(out));

    initial begin
        $dumpfile("tb_mux_4_1.vcd");
        $dumpvars(0, tb_mux_4_1);

        // test 1
        a = 1'b0;
        b = 1'b1;
        c = 1'b0;
        d = 1'b0;
        sel = 2'b01;
        #10;

    end

    initial begin
        $monitor("4-1: a=%b, b=%b, c=%b, d=%b, s=%b, o=%b", a, b, c, d, sel, out);
    end

endmodule


// tb for 8-bit, 4:1 bus mux
module tb_mux_8bus_4_1;
    reg [7:0] a, b, c, d;
    reg [1:0] sel;

    wire [7:0] out;

    mux_8bus_4_1 uut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .out(out));

    initial begin
        $dumpfile("tb_mux_8bus_4_1.vcd");
        $dumpvars(0, tb_mux_8bus_4_1);

        // test 1
        a = 8'h01; // a = 8'b00000001;
        b = 8'h02;
        c = 8'h03;
        d = 8'h04;
        sel = 2'b00;
        #10;

        // test 2
        sel = 2'b01;
        #10;
    end

    initial begin
        $monitor("8bus-4-1: a=%b, b=%b, c=%b, d=%b, s=%b, o=%b\n", a, b, c, d, sel, out);
    end

endmodule

// tb for 8-bit, 4:1 bus mux using structural
module tb_structural_mux_8bus_4_1;
    reg [7:0] a, b, c, d;
    reg [1:0] sel;
    wire [7:0] out;

    structural_mux_8bus_4_1 uut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .out(out));

    initial begin
        $dumpfile("tb_structural_mux_8bus_4_1.vcd");
        $dumpvars(0, tb_structural_mux_8bus_4_1);

        // test 1
        a = 8'h01; // a = 8'b00000001;
        b = 8'h02;
        c = 8'h03;
        d = 8'h04;
        sel = 2'b00;
        #10;

        // test 2
        sel = 2'b01;
        #10; 
    end
    
    initial begin
        $monitor("struct-8bus-4-1: a=%b, b=%b, c=%b, d=%b, s=%b, o=%b\n", a, b, c, d, sel, out);
    end
endmodule