module ALU(
    input wire [63:0] data_a,
    input wire [63:0] data_b,
    input wire [3:0] alu_signal,
    output reg [63:0] alu_result,
    output reg ZERO_FLAG
);

always @ (*) begin
    case (alu_signal)
        4'b0000:
            alu_result <= data_a & data_b;
        4'b0001:
            alu_result <= data_a | data_b;
        4'b0010:
            alu_result <= data_a + data_b;
        4'b0110:
            alu_result <= data_a - data_b;
        4'b0111:
            alu_result <= data_b;
        4'b1100:
            alu_result <= ~ (data_a | data_b);
        default:
            alu_result <= 0;      
    endcase

    ZERO_FLAG = (alu_result == 0) ? 1'b1 : 1'b0;

end


endmodule