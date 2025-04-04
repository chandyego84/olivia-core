// ALU_OP:
    // 00 (add) for loads/stores
    // 01 (pass input b) for CBZ
    // 10 (determined by operation encoded in opfield)

// OPCODE:
    // 31-21 : 1986'd for load, 1984'd for store
    // 31-21 : R-type instruction
    // 31-26: 180'd for CBZ
module Control_Unit(
    input wire [31:0] instruction,
    output reg REG2LOC,
    output reg ALU_SRC,
    output reg MEM2REG,
    output reg REG_WRITE,
    output reg MEM_READ,
    output reg MEM_WRITE,
    output reg BRANCH,
    output reg [1:0] ALU_OP
);

wire [10:0] opcode_full = instruction[31:21]; // r-type, load, store
wire [5:0] opcode_cbz = instruction[31:26];

always @ (*) begin
    // initialize all
    REG2LOC   = 0;
    ALU_SRC   = 0;
    MEM2REG   = 0;
    REG_WRITE = 0;
    MEM_READ  = 0;
    MEM_WRITE = 0;
    BRANCH    = 0;
    ALU_OP    = 2'b00;

    if (opcode_cbz == 6'd180) begin
        // CBZ
        REG2LOC = 1;
        BRANCH = 1;
        ALU_OP = 2'b01;
    end
    
    else case (opcode_full)
        11'b10001011000, // ADD
        11'b11001011000, // SUB
        11'b10001010000, // AND
        11'b10101010000: // ORR
            REG_WRITE = 1;
            ALU_OP = 2'b10;

        11'd1986: 
            // LOAD
            ALU_SRC = 1;
            MEM2REG = 1;
            REG_WRITE = 1;
            MEM_READ = 1;
            ALU_OP = 2'b00;

        11'd1984: 
            // STORE
            REG2LOC = 1;
            ALU_SRC = 1;
            MEM_WRITE = 1;
            ALU_OP = 2'b00;
    endcase
end

endmodule