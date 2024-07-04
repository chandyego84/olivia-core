// D flip-flop, register file, BRAM, SRAM

// sr latch with nor gates
module sr_latch(
    input wire r,
    input wire s,
    output wire q,
    output wire, qn
);

wire q_int, qn_int;

nor(r, qn_int, q_int);
nor(s, q_int, qn_int);

assign q = q_int;
assign qn = qn_int;

endmodule

// d-latch (behavioral)
module d_latch_behavioral (
    input wire d,
    input wire en,
    output reg q   
);

always @ (*) begin
    if (en)
        q = d 
end

endmodule

// d_latch using 4 nand gates built structurally
module d_latch_struct (
    input wire d,
    input wire en,
    output wire q,
    output wire qn
);

wire dn;
wire s, r; // inputs into SR latch

nor(dn, d); // inverted data input

// nand gates to feed into SR latch
nand(d, en, s);
nand(dn, en, r);

// cross-coupled nand gates to form SR Latch
nand(s, qn, q);
nand(r, q, qn);

endmodule

// synchronous w/ synchronous reset
module d_flip_flop(
    input wire clk,
    input wire rst,
    input wire d,
    output reg q,
    output reg qn
);

always @ (posedge clk) begin
    if (rst)
        q <= 0;
        qn <= 1;

    else begin
        q <= d;
        qn <= !q;
    end
end

endmodule

// used by a CPU to fetch and hold data from secondary memory devices
// 32x16 register file
// Reading:
    // 2 muxes to provide two 32 bit outputs on posedge of clock when read enable is high
// Writing:
    // 4b select input to select corresponding register into which value from 32b input port is written on posedge of clock and write enable is high
module regFile(
    input wire clk, en, rd, wr, rst,
    input wire [31:0] ip,
    input wire [3:0] sel_ip,
    input wire [3:0] sel_op1,
    input wire [3:0] sel_op2,
    output reg [31:0] op1,
    output reg [31:0] op2
);

reg [31:0] regFile [0:15];

wire clkRst;
assign clkRst = clk || rst;

int i;

always @ posedge(clkRst) begin
    if (en) begin
        if (rst) begin
            // clear all registers
            for (i=0; i < 16; i = i+1) begin
                regFile[i] = 32'b0;
            end
        end
        else begin
            case({rd, wr})
            2'b00: begin end
            2'b01: begin
                // write only
                regFile[sel_ip] = ip;
            end
            2'b10: begin
                // read only
                op1 = regFile[sel_op1];
                op2 = regFile[sel_op2];
            end
            2'b11: begin
                // read and write
                op1 = regFile[sel_op1];
                op2 = regFile[sel_op2];
                regFile[sel_ip] = ip;
            end

            default: begin end // unknown case
            endcase
        end
    end

    else;
end

endmodule