module Branch_Adder(
    input wire [63:0] pc_out,
    input wire signed [63:0] branch_off, // relative byte-offset
    output wire [63:0] result
);

assign result = (pc_out) + branch_off;

endmodule