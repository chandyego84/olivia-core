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

    $readmemh("test_instructions.mem", im_data);
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