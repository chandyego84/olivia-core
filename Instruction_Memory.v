module Instruction_Memory(
    input [63:0] pc_addr,
    output reg [31:0] instruction
);

// 64 registers of 8b width (64 bytes)
// each instruction is 32 bits (4 bytes)
// holds up to 16 instructions
reg [7:0] im_data [0:63];

initial begin
    // initialize instructions
    // Instruction 1: LDUR r2, [r12] -> 0xf8400182
    im_data[0]  = 8'hF8;  
    im_data[1]  = 8'h40;  
    im_data[2]  = 8'h01;  
    im_data[3]  = 8'h82;  

    // Instruction 2: LDUR r3, [r13] -> 0xf84001a3
    im_data[4]  = 8'hF8;  
    im_data[5]  = 8'h40;  
    im_data[6]  = 8'h01;  
    im_data[7]  = 8'hA3;  

    // Instruction 3: ORR x5, x20, x1 -> 0xaa010285
    im_data[8]  = 8'hAA;  
    im_data[9]  = 8'h01;  
    im_data[10] = 8'h02;  
    im_data[11] = 8'h85;  

    // Instruction 4: AND x6, x28, x27 -> 0x8a1b0386
    im_data[12] = 8'h8A;  
    im_data[13] = 8'h1B;  
    im_data[14] = 8'h03;  
    im_data[15] = 8'h86;  

    // Instruction 5: NOP -> 0x00000000
    im_data[16] = 8'h00;  
    im_data[17] = 8'h00;  
    im_data[18] = 8'h00;  
    im_data[19] = 8'h00;  

    // Instruction 6: ADD x9, x3, x2 -> 0x8b020069
    im_data[20] = 8'h8B;  
    im_data[21] = 8'h02;  
    im_data[22] = 8'h00;  
    im_data[23] = 8'h69;  

    // Instruction 7: SUB x10, x3, x2 -> 0xcb02006a
    im_data[24] = 8'hCB;  
    im_data[25] = 8'h02;  
    im_data[26] = 8'h00;  
    im_data[27] = 8'h6A;  

    // Instruction 8: CBZ x6, #13 -> 0xb40001a6
    im_data[28] = 8'hB4;  
    im_data[29] = 8'h00;  
    im_data[30] = 8'h01;  
    im_data[31] = 8'hA6;  

    // Instruction 9: NOP -> 0x00000000
    im_data[32] = 8'h00;  
    im_data[33] = 8'h00;  
    im_data[34] = 8'h00;  
    im_data[35] = 8'h00;  

    // Instruction 10: SUB x11, x9, x3 -> 0xcb03012b
    im_data[36] = 8'hCB;  
    im_data[37] = 8'h03;  
    im_data[38] = 8'h01;  
    im_data[39] = 8'h2B;  

    // Instruction 11: AND x9, x9, x10 -> 0x8a0a0129
    im_data[40] = 8'h8A;  
    im_data[41] = 8'h0A;  
    im_data[42] = 8'h01;  
    im_data[43] = 8'h29;  

    // Instruction 12: STUR x5, [x7, #1] -> 0xf80010e5
    im_data[44] = 8'hF8;  
    im_data[45] = 8'h00;  
    im_data[46] = 8'h10;  
    im_data[47] = 8'hE5;  

    // Instruction 13: AND x3, x2, x10 -> 0x8a0a0043
    im_data[48] = 8'h8A;  
    im_data[49] = 8'h0A;  
    im_data[50] = 8'h00;  
    im_data[51] = 8'h43;  

    // Instruction 14: ORR x21, x25, x24 -> 0xaa180335
    im_data[52] = 8'hAA;  
    im_data[53] = 8'h18;  
    im_data[54] = 8'h03;  
    im_data[55] = 8'h35;  

    // Instruction 15: B #20 -> 0x14000014
    im_data[56] = 8'h14;  
    im_data[57] = 8'h00;  
    im_data[58] = 8'h00;  
    im_data[59] = 8'h14;  
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