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

assign pc_in = adder_out;

ProgramCounter pc(clk, rst, pc_in, pc_out);
Adder pcAdder(4'b0100, pc_out, adder_out);

// instruction memory

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