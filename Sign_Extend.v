// 32b -> 64b
module Sign_Extend(
    input wire [31:0] inp_bits,
    output reg [63:0] ext_bits
);

always @ (*) begin
    ext_bits <= { {32{inp_bits[31]}}, inp_bits[31:0]};
end

endmodule