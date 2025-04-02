`timescale 1ns/1ps

// olivia is the cuter name of our CPU
module Olivia(
    input clk,
    input rst
);

/* MODULES */
/* IF */
// program counter
wire [63:0] pc_in;
wire [63:0] pc_out;
wire [63:0] adder_out;
wire [31:0] instruction;

assign pc_in = adder_out; // pc_in updates when adder calculates next addr

Program_Counter PC(clk, rst, pc_in, pc_out);
PC_Adder pcAdder(4'b0100, pc_out, adder_out); // update pc by 4 bytes

// instruction memory
Instruction_Memory IM(adder_out, instruction);

/* ID */
// register mux

// register file

// sign extend

/* EX */
// shift left 2

// ALU Control

// ALU mux

// ALU

/* MEM */
// ram

/* MEM WB */
// ram mux -- ram writeback

endmodule