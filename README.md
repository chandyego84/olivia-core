# Olivia RodriCORE

<p align="center">
  <img src="./img/SMOL_ARM_LOGO.jpg" alt="ARMLOGO" style="width:50%; height:50%;">
</p>

A simplified ARMv8 "processor", aka ARM-LEGv8. The processor is based on the architecture from 'Computer Organization and Design ARM Edition' by David A. Patterson and John L. Hennessy.  

# Olivia Rodrigo Assembly Language
TODO: add instructions here lol

# Architecture Information
__Doubleword__: Group of 64 bits.    
__Word__: Group of 32 bits.  

LEGv8 architecture is 64 bits.   
__Instruction format__: Each instruction takes exactly one word.  
__Registers__: 64 bits x 32 registers.   
__Memory__: LEGv8 uses byte addressing, with each doubleword representing 64 bits (8 bytes). There are two memories: instruction memory and data memory.    
__Instruction Memory__: 8 bits x 64 registers, i.e., 64 bytes. Since each instruction (32 bits) is 4 bytes, the instruction memory can hold 16 instructions. Although we only have 64 registers, thus needing only 6 bits to represent the address space, we will use 64 bits for consistency with the full ARMv8 architecture.  
__Data Memory__: 64 bits (8 bytes) x 128 registers = 1024 bytes of data.

## verilog_refreshers
A folder with various verilog modules for practice.

## Prerequisites
- Download and install [Icarus Verilog](https://bleyer.org/icarus/).
- Download and install [GTKWave](http://gtkwave.sourceforge.net/)

## Running
- Run using makefile OR     
`iverilog -o ARM olivia.v`  
`vvp ARM`    
`gtkwave olivia.v`

## Introduction
### Datapath with control unit  
![](./img/armLegWithControlAndUncondBranch.png)

### Pipeline and stages
![](./img/pipelinedArmLeg.png)

## Instructions (Basic)
### R-Format Instructions
| opcode: 11 bits | Rm: 5 bits | shamt: 6 bits | Rn: 5 bits | Rd: 5 bits |
- Opcode: operation code
- Rm: second register source operand
- shamt: shift amount (0000 for now)
- Rn: first register source operand
- Rd: register destination

### D-Format Instructions
| opcode: 11 bits | address: 9 bits | op2: 2 bits | Rn: 5 bits | Rt: 5 bits |   
__Load/Store Instructions__:
- address: constant offset from contents of base register Rn (+/- 32 doublewords).
- Rn : base register
- Rt: destination (load) or source (store) register number

### I-Format Instructions
| opcode: 10 bits | immediate: 12 bits | Rn: 5 bits | Rd: 5 bits |  
__Immediate Instructions (ADDI, SUBI):__    
- Rn: source register
- Rd: destination register  
- Immediate field is zero-extended   

### Supported Instructions
![](./img/instructions.png)     
Also `NOP` -- Make the processor wait one cycle.

### Control Signals  
![](./img/control_signals.png)

### Instructions Types With Control Signals
![](./img/instructions_controls.png)

## Program Counter
The PC uses the Instruction Memory to fetch a 32 bit instruction at each cycle. 4 registers of 8 bits are read in big-endian order.

## Registers
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

## Testing
### Registers and Memory Initialized With Some Values
```Register_File.v```: Initialized registers X0-X30 with values 0-30 and X31 with 0.   
```RAM.v```: Initialized with values 0-1280 except for memory registers 10 (1540) and 11 (2117).

### Instruction Memory Initialized With Instructions
The following is a set of test instructions loaded into ```Instruction_Memory.v``` from ```test_instructions.mem```
| Line # | ARM Assembly            | Machine Code (Binary)                     | Hexadecimal  | Notes                         |
|--------|-------------------------|-------------------------------------------|--------------|-------------------------------|
| 1      | `LDUR r2, [r10]`        | 1111 1000 0100 0000 0000 0001 0100 0010   | 0xF8400142   |                               |
| 2      | `LDUR r3, [r10, #1]`    | 1111 1000 0100 0001 0001 0001 0100 0011   | 0xF8401143   |                               |
| 3      | `SUB r4, r3, r2`        | 1100 1011 0000 0010 0000 0000 0110 0100   | 0xCB020064   |                               |
| 4      | `ADD r5, r3, r2`        | 1000 1011 0000 0010 0000 0000 0110 0101   | 0x8B020065   |                               |
| 5      | `CBZ r1, #2`            | 1011 0100 0000 0000 0000 0000 0100 0001   | 0xB4000041   | Branch if r1 == 0             |
| 6      | `CBZ r0, #2`            | 1011 0100 0000 0000 0000 0000 0100 0000   | 0xB4000040   | Branch if r0 == 0             |
| 7      | `LDUR r2, [r10]`        | 1111 1000 0100 0000 0000 0001 0100 0010   | 0xF8400142   | Skipped if CBZ from above hits|
| 8      | `ORR r6, r2, r3`        | 1010 1010 0000 0011 0000 0000 0100 0110   | 0xAA030046   |                               |
| 9      | `AND r7, r2, r3`        | 1000 1010 0000 0011 0000 0000 0100 0111   | 0x8A030047   |                               |
| 10     | `STUR r4, [r7, #1]`     | 1111 1000 0000 0000 0001 0000 1110 0100   | 0xF80010E4   |                               |
| 11     | `B #-3`                 | 0001 0111 1111 1111 1111 1111 1111 1101   | 0x17FFFFFD   | Branch back to instruction 8  |
| 12     | `ADD r8, r0, r1`        | 1000 1011 0000 0001 0000 0000 0000 1000   | 0x8B010008   | Never executes due to branch  |
