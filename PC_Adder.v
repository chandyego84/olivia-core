module PC_Adder(
    input [3:0] inc,
    input [63:0] pc_out,
    output wire [63:0] adder_out
);

assign adder_out = pc_out + inc;

endmodule