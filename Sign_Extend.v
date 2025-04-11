module Sign_Extend(
    input wire [31:0] instruction,
    output reg [63:0] extended
);

wire [10:0] opcode_full = instruction[31:21]; // r-type, load, store
wire [7:0] opcode_cbz = instruction[31:24];

always @(*) begin
    if (opcode_cbz == 8'd180) begin
        // CBZ - 19-bit offset
        extended = {{45{instruction[23]}}, instruction[23:5]};
    end
    
    else begin
        case (instruction[31:21])
            // D-type instructions (LDUR/STUR) - 9-bit offset
            11'd1986, 11'd1984: extended = {{55{instruction[20]}}, instruction[20:12]};                    
            default: extended = {{32{instruction[31]}}, instruction[31:0]};

            // TODO: Branch
        endcase
    end
end

endmodule