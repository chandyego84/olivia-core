module Branch_Adder(
    input wire [63:0] pc_out,
    input wire signed [63:0] branch_off, // relative byte-offset (e.g., B #2 == 8 byte-offset from PC)
    output wire [63:0] result
);

assign result = (pc_out) + branch_off;

endmodule