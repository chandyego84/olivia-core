`timescale 1ns/1ps

/**
LEGv8 has 32 x 64-bit register file with 31 being genreal purpose registers X0 to X30.  
X0 – X7: procedure arguments/results    
X8: indirect result location register   
X9 – X15: temporaries   
X16 – X17 (IP0 – IP1): may be used by linker as a scratch register, other times as temporary register   
X18:  platform register for platform independent code; otherwise a temporary register   
X19 – X27: saved    
X28 (SP): stack pointer 
X29 (FP): frame pointer 
X30 (LR): link register (return address)    
XZR (register 31): the constant value 0     
*NOTE: Temporary vs saved registers: No difference in how they work but rather how they ought to be used. Temporaries are caller saved registers, while saved registers are callee saved. In other words, when calling a function, the convention guarantees that the saved registers are the same after return wheras the convention does not guarantee this for the temporary registers.*
*/
module Register_File(
    input wire REGWRITE, // CONTROL SIGNAL
    input wire [4:0] read1, // read reg 1: instruction 9-5 
    input wire [4:0] read2, // read reg 2: instruction 20-16 or instruction 4-0 (rt) for reg to be written by a load 
    input wire [4:0] write_reg, // // write register: instruction 4-0 (rd for r-type/i-type instructions to store value of current operation in register)
    input wire [63:0] writeData, // from ALU or from memory
    output reg [63:0] read_data1, // data from read reg 1
    output reg [63:0] read_data2 // data from read reg 2
);

reg [63:0] reg_data [31:0];

integer r;
initial begin
    // init each register data value with generic value
    for (r = 0; r < 31; r = r + 1) begin
        reg_data[r] = r;
    end

    reg_data[31] = 64'b0;
end

always @ (REGWRITE, read1, read2, write_reg, writeData) begin
    if (REGWRITE == 1 && write_reg != 5'd31) begin // cannot write to reg 31
        reg_data[write_reg] = writeData;
    end

    read_data1 <= reg_data[read1];
    read_data2 <= reg_data[read2];
end

endmodule