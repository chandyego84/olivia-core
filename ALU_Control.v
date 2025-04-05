// ALU_OP:
    // 00 (add) for loads/stores
    // 01 (pass input b) for CBZ
    // 10 (determined by operation encoded in opfield)
        // only bits 30, 29, and 24 are different
// ALU OPERATIONS:
    // 0000: AND
    // 0001: OR
    // 0010: ADD
    // 0110: SUB
    // 0111: PASS INPUT b
    // 1100: NOR
module ALU_Control(
    input wire [1:0] alu_op,
    input wire [2:0] op_code_bits, // 30, 29, 24
    output reg [3:0] ALU_SIGNAL
);

always @ (*) begin
    case (alu_op) 
        2'b00:
            // load, store
            ALU_SIGNAL <= 4'b0010; 
        2'b01:
            // cbz
            ALU_SIGNAL <= 4'b0111;
        2'b10:
            // R-type
            case (op_code_bits)
                3'b000:
                    // AND
                    ALU_SIGNAL <= 4'b0000;
                3'b001:
                    // ADD
                    ALU_SIGNAL <= 4'b0010;
                3'b010:
                    // OR
                    ALU_SIGNAL <= 4'b0001;
                3'b101:
                    // SUB
                    ALU_SIGNAL <= 4'b0110;
                default:
                    ALU_SIGNAL <= 4'b0000;
            endcase
        default:
            ALU_SIGNAL <= 4'b0000;
    endcase
end

endmodule