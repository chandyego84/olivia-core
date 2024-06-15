`timescale 1ns/1ns

module tb_encoder_4_2;
    reg EIN;
    reg [3:0] in;
    wire EOUT;
    wire [1:0] out;

    encoder_4_2 uut(.EIN(EIN), .in(in), .EOUT(EOUT), .out(out));

    initial begin
        $dumpfile("tb_encoder_4_2.vcd");
        $dumpvars(0, tb_encoder_4_2);

        $monitor("4-2 encoder: en=%b in=%b eout=%b out=%b", EIN, in, EOUT, out);

        EIN=1; in=0; #5 // no inp asserted
        EIN=1; in=1; #5
        EIN=1; in=2; #5
        EIN=1; in=4; #5
        EIN=1; in=8; #5
        EIN=0; in=4'bX; #5
        $finish;
    end
endmodule