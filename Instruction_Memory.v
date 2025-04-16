module Instruction_Memory(
    input [63:0] pc_addr,
    output reg [31:0] instruction
);

// 64 registers of 8b width (64 bytes)
// each instruction is 32 bits (4 bytes)
// holds up to 16 instructions
reg [7:0] im_data [0:63];

initial begin
    for (integer i = 0; i < 64; i = i + 1)
        im_data[i] = 8'h00;

    // Instruction 1: LDUR r2, [r10]
    {im_data[0], im_data[1], im_data[2], im_data[3]}     = 32'hF8400142;

    // Instruction 2: LDUR r3, [r10, #1]
    {im_data[4], im_data[5], im_data[6], im_data[7]}     = 32'hF8401143;

    // Instruction 3: SUB r4, r3, r2
    {im_data[8], im_data[9], im_data[10], im_data[11]}   = 32'hCB020064;

    // Instruction 4: ADD r5, r3, r2
    {im_data[12], im_data[13], im_data[14], im_data[15]} = 32'h8B020065;

    // Instruction 5: CBZ r1, #2
    {im_data[16], im_data[17], im_data[18], im_data[19]} = 32'hB4000041;

    // Instruction 6: CBZ r0, #2
    {im_data[20], im_data[21], im_data[22], im_data[23]} = 32'hB4000040;

    // Instruction 7: LDUR r2, [r10] -- SKIPPED DUE TO CBZ
    {im_data[24], im_data[25], im_data[26], im_data[27]} = 32'hF8400142;

    // Instruction 8: ORR r6, r2, r3
    {im_data[28], im_data[29], im_data[30], im_data[31]} = 32'hAA030046;

    // Instruction 9: AND r7, r2, r3
    {im_data[32], im_data[33], im_data[34], im_data[35]} = 32'h8A030047;

    // Instruction 10: STUR r4, [r7, #1]
    {im_data[36], im_data[37], im_data[38], im_data[39]} = 32'hF80010E4;

    // Instruction 11: B #-3 -> go back to instruction 8
    {im_data[40], im_data[41], im_data[42], im_data[43]} = 32'h17FFFFFD;

    // Instruction 12: ADD r8, r0, r1 -- DOES NOT EXECUTE DUE TO B
    {im_data[44], im_data[45], im_data[46], im_data[47]} = 32'h8B010008;
end

// read address and output 32b instruction
// big-endian order
always @(pc_addr) begin
    instruction[7:0] = im_data[pc_addr + 3]; // LSB
    instruction[15:8] = im_data[pc_addr + 2];
    instruction[23:16] = im_data[pc_addr + 1];
    instruction[31:24] = im_data[pc_addr]; // MSB
end

endmodule