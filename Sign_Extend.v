module Sign_Extend(
    input wire [31:0] instruction,
    output reg signed [63:0] extended
);

wire [10:0] opcode_full = instruction[31:21]; // r-type, load, store
wire [7:0] opcode_cbz = instruction[31:24];
wire [5:0] opcode_branch = instruction[31:26];

always @(*) begin
    if (opcode_cbz == 8'd180) begin
        // CBZ - 19-bit offset -- Relative WORD Offset
        extended = {{45{instruction[23]}}, instruction[23:5]};
    end

    else if (opcode_branch == 6'd5) begin
        // BRANCH - 26-bit offset -- Relative WORD Offset
        extended = {{38{instruction[25]}}, instruction[25:0]};
    end

    else begin
        case (instruction[31:21])
            // D-type instructions (LDUR/STUR) - 9-bit offset
            11'd1986, 11'd1984: extended = {{55{instruction[20]}}, instruction[20:12]};                    
            default: extended = {{32{instruction[31]}}, instruction[31:0]};            
        endcase
    end
end

endmodule