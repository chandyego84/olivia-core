`timescale 1ns/1ps

module olivia_tb();

  reg CLK;
  reg RST;

  // Instantiate Olivia (Device Under Test)
  Olivia dut (
    .clk(CLK),
    .rst(RST)
  );

  // Display all instructions at start of simulation
  initial begin
    $display("\nInstruction Memory Contents:");
    $display("--------------------------");
    $display("PC  | Instruction       | Opcode");
    $display("----|-------------------|--------");
    print_instructions();
    $display("--------------------------\n");

    $display("\nInitial Register Contents:");
    $display("------------------------");
    print_register_contents();
    $display("------------------------\n");
  end

  // Task to print instructions
  task print_instructions;
    integer i;
    reg [31:0] instr;
    reg [8*20:1] opcode_name;
    begin
      for (i = 0; i < 16; i = i + 1) begin
        instr = {dut.IM.im_data[i*4], dut.IM.im_data[i*4+1], 
                dut.IM.im_data[i*4+2], dut.IM.im_data[i*4+3]};
        opcode_name = get_opcode_name(instr);
        $display("%2d  | %h | %s", i*4, instr, opcode_name);
      end
    end
  endtask

task print_register_contents;
    integer i;
    begin
    $display("Register | Value");
    $display("--------|------------------");
        for (i = 0; i < 32; i = i + 1) begin
            if (i == 31) begin
            $display("(X31) | %0d (always zero)", dut.regFile.reg_data[i]);
            end else begin
            $display("X%-2d      | %0d", i, dut.regFile.reg_data[i]);
            end
        end
    end
endtask

task print_ram_contents;
    integer i;
    begin
    $display("Mem_Addr | Value");
    $display("--------|------------------");
        for (i = 0; i < 128; i = i + 1) begin
            $display("%-2d      | %0d", i, dut.ram.mem_data[i]);
        end
    end
endtask

// Function to get instruction name
function [8*20:1] get_opcode_name;
input [31:0] instr;
begin
    case (instr[31:21])
    11'b10001011000: get_opcode_name = "ADD";
    11'b11001011000: get_opcode_name = "SUB"; 
    11'b10001010000: get_opcode_name = "AND";
    11'b10101010000: get_opcode_name = "ORR";
    11'b11111000010: get_opcode_name = "LDUR";
    11'b11111000000: get_opcode_name = "STUR";
    11'b10110100000: get_opcode_name = "CBZ";
    11'b00010100000: get_opcode_name = "B";
    default: 
        if (instr == 32'b0) 
        get_opcode_name = "NOP";
        else
        get_opcode_name = "UNKNOWN";
    endcase
end
endfunction

// Clock generation
initial begin
CLK = 0;
forever #5 CLK = ~CLK;
end

// Test sequence
initial begin
$dumpfile("testbenches/wave.vcd");
$dumpvars(0, olivia_tb);

// Initialize with reset active
RST = 1;
#10;  // Hold reset for 1 clock edges
RST = 0;

// Run long enough to execute all instructions
#170;

$display("\033[1;34m\n-----------------REGISTERS FINAL-----------------");
print_register_contents();
$display("\033[1;33m\n-----------------RAM FINAL-----------------");
print_ram_contents();

$display("\033[0m"); // reset ANSI colors
$finish;
end

wire [10:0] opcode_full = dut.instruction[31:21]; // r-type, load, store
wire [7:0] opcode_cbz = dut.instruction[31:24];
wire [5:0] opcode_branch = dut.instruction[31:26];

// Monitor expected vs actual ALU output
always @(posedge CLK) begin
    if (RST == 0) begin
        $display("\n-----------------------------");
        $display("Time: %t", $time);
        $display("Cycle: %0d", $time/10);
        $display("PC: %0d", dut.pc_out);
        $display("Instruction: %0d", (dut.pc_out / 4) + 1);

        if (opcode_cbz == 8'd180) begin
            // CBZ
            $display("\033[1;96m"); // CYAN 
            $display("Operation: CBZ X%d, #%0d", dut.instruction[4:0], dut.sign_ext_inst);
            $display("Register Value (X%d): %0d", dut.instruction[4:0], dut.read_data2);
            $display("Word Offset (dec): %0d", dut.sign_ext_inst);
            // $display("Word Offset (b): %0b", dut.sign_ext_inst);
            $display("PC-Relative Branch Offset: %0d", dut.sign_ext_inst << 2);
            // $display("PC-Relative Branch Offset (b): %0b", dut.sign_ext_inst << 2);
            $display("\033[0m"); // reset ANSI colors
        end

        else if (opcode_branch == 8'd5) begin
            // UNCONDITIONAL BRANCH
            $display("\033[1;96m"); // CYAN 
            $display("Operation: B #%0d", dut.sign_ext_inst);
            $display("Word Offset: %0d", dut.sign_ext_inst);
            // $display("Word Offset (b): %0b", dut.sign_ext_inst);
            $display("PC-Relative Branch Offset: %0d", dut.sign_ext_inst << 2);
            // $display("PC-Relative Branch Offset (b): %0b", dut.sign_ext_inst << 2);
            $display("\033[0m"); // reset ANSI colors            
        end

        else begin
            case (opcode_full)
                // R-type instructions
                11'b10001011000: begin // ADD
                    $display("\033[1;92m"); // GREEN 
                    $display("Operation: X%0d = X%0d + X%0d", 
                        dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
                    $display("Operands: %0d + %0d", dut.read_data1, dut.read_data2);
                    $display("Result: Expected=%0d | Actual=%0d", 
                            dut.read_data1 + dut.read_data2, dut.alu_result);
                    $display("Reg2Write: X%0d", dut.rt);
                    if (dut.read_data1 + dut.read_data2 !== dut.alu_result) begin
                        $display("ERROR: ADD result mismatch!");
                    end
                    $display("\033[0m"); // reset ANSI colors
                end
            
                11'b11001011000: begin // SUB
                    $display("\033[1;92m"); // GREEN 
                    $display("Operation: X%0d = X%0d - X%0d", 
                            dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
                    $display("Operands: %0d - %0d", dut.read_data1, dut.read_data2);
                    $display("Result: Expected=%0d | Actual=%0d", 
                            dut.read_data1 - dut.read_data2, dut.alu_result);
                    if (dut.read_data1 - dut.read_data2 !== dut.alu_result) begin 
                        $display("ERROR: SUB result mismatch!");    
                    end
                    $display("\033[0m"); // reset ANSI colors
                end
            
                11'b10001010000: begin // AND
                    $display("\033[1;92m"); // GREEN 
                    $display("Operation: X%0d = X%0d & X%0d", 
                            dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
                    $display("Operands: %0d & %0d", dut.read_data1, dut.read_data2);
                    $display("Result: Expected=%0d | Actual=%0d", 
                            dut.read_data1 & dut.read_data2, dut.alu_result);
                    if ((dut.read_data1 & dut.read_data2) !== dut.alu_result) begin 
                        $display("ERROR: AND result mismatch!");
                    end
                    $display("\033[0m"); // reset ANSI colors
                end
            
                11'b10101010000: begin // ORR
                    $display("\033[1;92m"); // GREEN 
                    $display("Operation: X%0d = X%0d | X%0d", 
                            dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
                    $display("Operands: %0d | %0d", dut.read_data1, dut.read_data2);
                    $display("Result: Expected=%0d | Actual=%0d", 
                            dut.read_data1 | dut.read_data2, dut.alu_result);
                    if ((dut.read_data1 | dut.read_data2) !== dut.alu_result) begin 
                        $display("ERROR: ORR result mismatch!");
                    end
                    $display("\033[0m"); // reset ANSI colors
                end
            
                // D-type instructions (load/store)
                11'b11111000010: begin // LDUR
                    $display("\033[1;93m"); // YELLOW 
                    $display("Operation: X%d = [X%d + %0d]", 
                        dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:12]);
                    $display("Base Address (X%d)", dut.instruction[9:5]);
                    $display("Expected Offset: %0d, Actual: %0d", dut.instruction[20:12], dut.sign_ext_inst);
                    $display("Expected Address: %0d | Actual: %0d", 
                        dut.read_data1 + dut.sign_ext_inst, dut.alu_result);
                    $display("Reg Address X%0d Value (Mem addr to grab data from): %0d", dut.read_data1 + dut.sign_ext_inst, dut.regFile.reg_data[dut.read_data1 + dut.sign_ext_inst]);
                    if (dut.read_data1 + dut.sign_ext_inst !== dut.alu_result) begin 
                        $display("ERROR: LDUR address mismatch!");
                    end
                    $display("\033[0m"); // reset ANSI colors
                end
            
                11'b11111000000: begin // STUR
                    $display("\033[1;93m"); // YELLOW 
                    $display("Operation: M[X%d + %0d] = X%d", 
                        dut.instruction[9:5], dut.instruction[20:12], dut.instruction[4:0]);
                    $display("Base Address (X%0d) = %0d", dut.instruction[9:5], dut.read_data1);
                    $display("Expected Offset: %0d, Actual: %0d", dut.instruction[20:12], dut.sign_ext_inst);
                    $display("Expected Address: %0d | Actual: %0d", 
                        dut.read_data1 + dut.sign_ext_inst, dut.alu_result);
                    $display("X%0d = %0d", dut.instruction[4:0], dut.regFile.reg_data[dut.instruction[4:0]]);
                    $display("M[%0d] = %0d", dut.read_data1 + dut.sign_ext_inst, dut.ram.mem_data[dut.read_data1 + dut.sign_ext_inst]);
                    if (dut.read_data1 + dut.sign_ext_inst !== dut.alu_result) begin 
                        $display("ERROR: STUR address mismatch!");
                    end
                    $display("\033[0m"); // reset ANSI colors
                end

                default: begin
                    if (dut.instruction != 32'b0)
                        $display("\033[1;91m"); // RED 
                        $display("UNKNOWN instruction: %b", dut.instruction[31:21]);
                        $display("\033[0m"); // reset ANSI colors                
                end
            endcase            
        end
    end
end

endmodule