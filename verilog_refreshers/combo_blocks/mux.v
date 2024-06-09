// 1-bit, 2:1 mux
module mux_2_1(input i_a, i_b, select);
    input wire i_a;
    input wire i_b;
    input wire select;

    output o_data;

    assign o_data = select ? i_a : i_b;

endmodule

// 1-bit, 4:1 mux
module mux_4_1(input a, b, c, d, sel);
    input wire a;
    input wire b;
    input wire c;
    input wire d;
    input [1:0] sel;

    output wire out;

    reg temp;

    always @ (*) begin
        case(sel)
            2'b00: temp <= a;
            2'b01: temp <= b;
            2'b10: temp <= c;
            2'b11: temp <= d;
        endcase
    end

    assign out = temp;

endmodule

// 8-bit, 4:1 bus mux
// like the 4_1 mux we are using behavioral verilog instead of structural verilog
// the synthesizer will construct the wiring
module mux_8bus_4_1(input a, b, c, d, sel);
    input wire [7:0] a, b, c, d;
    input wire [1:0] sel;

    output wire [7:0] out;

    reg [7:0] temp;

    always @ (*) begin
        case(sel)
            2'b00: temp <= a;  
            2'b01: temp <= b;
            2'b10: temp <= c;
            2'b11: temp <= d;
            default: temp <= '0;
        endcase
    end

    assign out = temp;

endmodule

// 8-bit, 4:1 bus mux using structural
// we have to actually join 8 4:1 muxes together
module structural_mux_8bus_4_1(input a, b, c, d, sel);
    input wire [7:0] a, b, c, d;
    input wire [1:0] sel;

    output wire [7:0] out;

    wire [7:0] temp;

    mux_4_1 m0(a[0], b[0], c[0], d[0], sel, temp[0]);
    mux_4_1 m1(a[1], b[1], c[1], d[1], sel, temp[1]);
    mux_4_1 m2(a[2], b[2], c[2], d[2], sel, temp[2]);
    mux_4_1 m3(a[3], b[3], c[3], d[3], sel, temp[3]);
    mux_4_1 m4(a[4], b[4], c[4], d[4], sel, temp[4]);
    mux_4_1 m5(a[5], b[5], c[5], d[5], sel, temp[5]);
    mux_4_1 m6(a[6], b[6], c[6], d[6], sel, temp[6]);
    mux_4_1 m7(a[7], b[7], c[7], d[7], sel, temp[7]);

    assign out = temp;

endmodule