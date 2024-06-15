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

module tb_decoder_2_4;
    reg EIN;
    reg EOUT;
    reg [1:0] in;
    wire [3:0] out;

    decoder_2_4 uut(.EIN(EIN), .EOUT(EOUT), .in(in), .out(out));

    initial begin
        $dumpfile("tb_decoder_2_4.vcd");
        $dumpvars(0, tb_decoder_2_4);

        $monitor("2-4 decoder: en=%b eout=%b in=%b out=%b", EIN, EOUT, in, out);

        EIN=1; EOUT=0; in=0; #5
        EIN=1; EOUT=0; in=1; #5
        EIN=1; EOUT=0; in=2; #5
        EIN=1; EOUT=0; in=3; #5
        EIN=1; EOUT=1; in=0; #5 // no input in encoder asserted
        EIN=0; EOUT=0; in=0; #5 // 4'd1 should be decoded value but EIN is off, so expecting 0
        $finish;
    end
endmodule