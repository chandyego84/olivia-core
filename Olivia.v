`timescale 1ns/1ps

////// TODO: REWRITE SEQUENTIAL MODULES TO USE CLK -- NEED TO CHECK ON THIS //////
// REG FILE
// MEMORY

///// TODO: NEED TO TEST OLIVIA UP TO ALU OUTPUT

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

/*** EX ***/
// control unit
wire ALU_SRC;
wire MEM2REG;
wire MEM_READ;
wire MEM_WRITE;
wire BRANCH;
wire [1:0] ALU_OP;

Control_Unit controlUnut(
    instruction,
    REG2LOC,
    ALU_SRC,
    MEM2REG,
    REG_WRITE,
    MEM_WRITE,
    BRANCH,
    ALU_OP 
);

// ALU Control
wire [2:0] op_code_bits = {instruction[30], instruction[29], instruction[24]}
wire [3:0] ALU_SIGNAL;

ALU_Control aluControl(
    ALU_OP,
    op_code_bits,
    ALU_SIGNAL
);

// ALU mux
wire [63:0] alu_read_data2; // alu mux output
wire [63:0] sign_ext_inst; // mux 1 output

// sign extend for instruction
Sign_Extend signExt(
    instruction,
    sign_ext_inst
);

ALU_Mux aluMux(
    read_data2, // mux 0 output
    sign_ext_inst,
    ALU_SRC,
    alu_read_data2
);


// ALU
wire [63:0] alu_result;
wire ZERO_FLAG;

ALU alu(
    read_data1,
    alu_read_data2,
    ALU_SIGNAL,
    alu_result,
    ZERO_FLAG
);

// shift left 2

/*** MEM ***/
// ram

/*** MEM WB ***/
// ram mux -- ram writeback

endmodule