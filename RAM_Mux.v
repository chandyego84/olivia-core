module RAM_Mux(
    input wire MEM2REG,
    input wire [63:0] ram_read_data,
    input wire [63:0] ALU_result,
    output wire [63:0] out // data to register file
);

assign out = MEM2REG ? ram_read_data : ALU_result; 

endmodule