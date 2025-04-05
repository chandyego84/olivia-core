`timescale 1ns/1ps

// olivia is the cuter name of our CPU
module Olivia(
    input clk,
    input rst
);

/* MODULES */
/*** IF ***/
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

/*** ID ***/
// register mux -- decides second operand reg
wire [4:0] rm = instruction[20:16]; // R-type 
wire [4:0] rt = instruction[4:0]; // loads, stores
wire [4:0] reg_mux_out;
wire REG2LOC;

Register_Mux regMux(rm, rt, REG2LOC, reg_mux_out);

// register file
wire [63:0] read_data1;
wire [63:0] read_data2;
wire REG_WRITE;

Register_File regFile(
    REG_WRITE,
    instruction[9:5],
    rm,
    rt,
    reg_mux_out,
    read_data1,
    read_data2
);

// sign extend

/*** EX ***/
// shift left 2

// ALU Control

// ALU mux

// ALU

/*** MEM ***/
// ram

/*** MEM WB ***/
// ram mux -- ram writeback

endmodule