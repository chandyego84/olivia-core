# ARM LEGv8 Processor in Verilog
A simplified pipelined ARMv8 processor. The processor is based on the architecture from 'Computer Organization and Design ARM Edition' by David A. Patterson and John L. Hennessy.

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

## Instructions - Basic Assembly
![](./img/instructions.png)     
Also `NOP` -- Make the processor wait one cycle.

## Testing
### Registers Initialized With Some Values
TODO: Add initializers here

### Instruction Memory Initialized With Instructions
TODO: This is temporary and should adjust to register initialization.
| Line # | ARM Assembly         | Machine Code                             | Hexadecimal  |
|--------|----------------------|------------------------------------------|--------------|
| 1      | `LDUR r2, [r12]`       | 1111 1000 0100 0000 0000 0001 1000 0010  | 0xf8400182   |
| 2      | `LDUR r3, [r13]`       | 1111 1000 0100 0000 0000 0001 1010 0011  | 0xf84001a3   |
| 3      | `ORR x5, x20, x1`      | 1010 1010 0000 0001 0000 0010 1000 0101  | 0xaa010285   |
| 4      | `AND x6, x28, x27`     | 1000 1010 0001 1011 0000 0011 1000 0110  | 0x8a1b0386   |
| 5      | `NOP`                  | 0000 0000 0000 0000 0000 0000 0000 0000  | 0x00000000   |
| 6      | `ADD x9, x3, x2`       | 1000 1011 0000 0010 0000 0000 0110 1001  | 0x8b020069   |
| 7      | `SUB x10, x3, x2`      | 1100 1011 0000 0010 0000 0000 0110 1010  | 0xcb02006a   |
| 8      | `CBZ x6, #13`          | 1011 0100 0000 0000 0000 0001 1010 0110  | 0xb40001a6   |
| 9      | `NOP`                  | 0000 0000 0000 0000 0000 0000 0000 0000  | 0x00000000   |
| 10     | `SUB X11, x9, x3`      | 1100 1011 0000 0011 0000 0001 0010 1011  | 0xcb03012b   |
| 11     | `AND x9, x9, x10`      | 1000 1010 0000 1010 0000 0001 0010 1001  | 0x8a0a0129   |
| 12     | `STUR x5, [x7, #1]`    | 1111 1000 0000 0000 0001 0000 1110 0101  | 0xf80010e5   |
| 13     | `AND x3, x2, x10`      | 1000 1010 0000 1010 0000 0000 0100 0011  | 0x8a0a0043   |
| 14     | `ORR x21, x25, x24`    | 1010 1010 0001 1000 0000 0011 0011 0101  | 0xaa180335   |
| 15     | `B #20`                | 0001 0100 0000 0000 0000 0000 0001 0100  | 0x14000014   |
