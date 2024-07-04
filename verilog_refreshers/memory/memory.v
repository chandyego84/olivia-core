// D flip-flop, buffers, register file, BRAM, SRAM

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