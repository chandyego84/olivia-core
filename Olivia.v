`timescale 1ns/1ps

// olivia is the cuter name of our CPU
module Olivia(
    input clk,
    input rst
);

///////////////////////////////////////////////////////////////////////////
// program counter
wire [63:0] pc_in;
wire [63:0] pc_out;
wire [63:0] adder_out;
wire [63:0] pc_branch_offset; // offset in bytes
wire PC_MUX_SEL;
wire [31:0] instruction;

// register file
wire [63:0] read_data1;
wire [63:0] read_data2;
wire [63:0] reg_write_data; // MEMORY: from alu or from memory
wire [4:0] rn = instruction[9:5];
wire [4:0] rm = instruction[20:16]; // R-type 
wire [4:0] rt = instruction[4:0]; // loads, stores
wire [4:0] reg_mux_out;
wire REG2LOC;
wire REG_WRITE;

// control unit
wire ALU_SRC;
wire MEM2REG;
wire MEM_READ;
wire MEM_WRITE;
wire BRANCH;
wire UNCOND_BRANCH;
wire [1:0] ALU_OP;

// ALU Control
wire [2:0] op_code_bits = {instruction[30], instruction[29], instruction[24]};
wire [3:0] ALU_SIGNAL;

// ALU mux
wire [63:0] alu_read_data2; // alu mux output
wire [63:0] sign_ext_inst; // alu/branch mux 1

// ALU
wire [63:0] alu_result;
wire ZERO_FLAG;

// MEM
wire [63:0] ram_read_data;
///////////////////////////////////////////////////////////////////////////

/************IF************/
//assign pc_in = adder_out; // pc_in updates when adder calculates next addr

// sign extend for instruction 32b -> 64b
Sign_Extend signExt(
    instruction,
    sign_ext_inst
);

PC_Adder pcAdder(4'b0100, pc_out, adder_out); // update pc by 4 bytes
Branch_Adder branchAdder(pc_out, sign_ext_inst <<< 2, pc_branch_offset);

assign PC_MUX_SEL = BRANCH & ZERO_FLAG | UNCOND_BRANCH;
Mux_64 pcMux(PC_MUX_SEL, pc_branch_offset, adder_out, pc_in); // decides PC_IN

Program_Counter PC(clk, rst, pc_in, pc_out);

// instruction memory
Instruction_Memory IM(pc_out, instruction);
/************END_IF************/

/************ID************/
Register_Mux regMux(REG2LOC, rm, rt, reg_mux_out);

Register_File regFile(
    REG_WRITE,
    rn,
    reg_mux_out,
    rt,
    reg_write_data,
    read_data1,
    read_data2
);
/************END_ID************/

/************EX************/
Control_Unit controlUnit(
    instruction,
    REG2LOC,
    ALU_SRC,
    MEM2REG,
    REG_WRITE,
    MEM_READ,
    MEM_WRITE,
    BRANCH,
    UNCOND_BRANCH,
    ALU_OP 
);

ALU_Control aluControl(
    ALU_OP,
    op_code_bits,
    ALU_SIGNAL
);

/**
    AS A MODULE, ALUX_MUX WOULD LOOK LIKE:
    input wire ALU_SRC,
    input wire [63:0] sign_ext_inst,
    input wire [63:0] read_data2,
    output wire [63:0] out
);

assign out = ALU_SRC ? sign_ext_inst : read_data2;
**/
Mux_64 aluMux(
    ALU_SRC,
    sign_ext_inst,
    read_data2, // mux 0 output
    alu_read_data2
);


ALU alu(
    read_data1,
    alu_read_data2,
    ALU_SIGNAL,
    alu_result,
    ZERO_FLAG
);
/************END_EX************/

/************MEM************/
RAM ram(
    MEM_WRITE,
    MEM_READ,
    alu_result,
    read_data2,
    ram_read_data
);

/*** MEM WB ***/
/**
AS A MODULE, RAM_MUX WOULD LOOK LIKE:
module RAM_Mux(
    input wire MEM2REG,
    input wire [63:0] ram_read_data,
    input wire [63:0] ALU_result,
    output wire [63:0] out // data to register file
);

assign out = MEM2REG ? ram_read_data : ALU_result; 
endmodule
**/
Mux_64 ramMux(
    MEM2REG,
    ram_read_data,
    alu_result,
    reg_write_data
);
/************END_MEM************/

endmodule