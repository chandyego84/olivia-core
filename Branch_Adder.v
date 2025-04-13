module Branch_Adder(
    input wire [63:0] pc_out,
    input wire [63:0] branch_off,
    output wire [63:0] result
);

assign result = pc_out + branch_off;

endmodule