// OPCODE:
    // 31-21 : 1986'd for load, 1984'd for store
    // 31-21 : R-type instruction
    // 31-24: 180'd for CBZ
// ALU_OP: into the ALU Control Unit
    // 00 (add) for loads/stores
    // 01 (pass input b) for CBZ
    // 10 (determined by operation encoded in opfield)
module Control_Unit(
    input wire [31:0] instruction,
    output reg REG2LOC,
    output reg ALU_SRC,
    output reg MEM2REG,
    output reg REG_WRITE,
    output reg MEM_READ,
    output reg MEM_WRITE,
    output reg BRANCH,
    output reg UNCOND_BRANCH,
    output reg [1:0] ALU_OP
);

wire [10:0] opcode_full = instruction[31:21]; // r-type, load, store
wire [7:0] opcode_cbz = instruction[31:24];
wire [5:0] opcode_branch = instruction[31:26];

always @ (*) begin
    // initialize all
    REG2LOC   <= 0;
    ALU_SRC   <= 0;
    MEM2REG   <= 0;
    REG_WRITE <= 0;
    MEM_READ  <= 0;
    MEM_WRITE <= 0;
    BRANCH    <= 0;
    ALU_OP    <= 2'b00;

    if (opcode_cbz == 8'd180) begin
        // CBZ
        REG2LOC <= 1;
        BRANCH <= 1;
        ALU_OP <= 2'b01;
        ALU_SRC   <= 0;
        MEM2REG   <= 0;
        REG_WRITE <= 0;
        MEM_READ  <= 0;
        MEM_WRITE <= 0;
        BRANCH    <= 0;

    end

    else if (opcode_branch == 8'd5) begin
        // UNCONDITIONAL BRANCH
        UNCOND_BRANCH <= 1;
        BRANCH    <= 1; // doesnt really matter, but it IS a branch, so set it anyways
        REG2LOC <= 0;
        BRANCH <= 0;
        ALU_OP <= 2'b00;
        ALU_SRC   <= 0;
        MEM2REG   <= 0;
        REG_WRITE <= 0;
        MEM_READ  <= 0;
        MEM_WRITE <= 0;
    end


    else begin 
        case (opcode_full)
            11'b10001011000, // ADD
            11'b11001011000, // SUB
            11'b10001010000, // AND
            11'b10101010000: begin // ORR
                REG_WRITE <= 1;
                ALU_OP <= 2'b10;
                REG2LOC   <= 0;
                ALU_SRC   <= 0;
                MEM2REG   <= 0;
                MEM_READ  <= 0;
                MEM_WRITE <= 0;
                BRANCH    <= 0;
            end

            11'd1986: begin 
                // LOAD
                ALU_SRC <= 1;
                MEM2REG <= 1;
                REG_WRITE <= 1;
                MEM_READ <= 1;
                ALU_OP <= 2'b00;
                REG2LOC   <= 0;
                MEM_WRITE <= 0;
                BRANCH    <= 0;

            end

            11'd1984: begin
                // STORE
                REG2LOC <= 1;
                ALU_SRC <= 1;
                MEM_WRITE <= 1;
                ALU_OP <= 2'b00;
                MEM2REG   <= 0;
                REG_WRITE <= 0;
                MEM_READ  <= 0;
                BRANCH    <= 0;
            end

            default: begin
                // already zero'd all values
            end
        endcase
    end
end

endmodule