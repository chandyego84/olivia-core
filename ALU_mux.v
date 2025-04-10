module ALU_Mux(
    input wire [63:0] read_data2,
    input wire [63:0] sign_ext_inst,
    input wire ALU_SRC,
    output wire [63:0] out
);

assign out = ALU_SRC ? sign_ext_inst : read_data2;

endmodule