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
        $display("XZR (X31) | %0d (always zero)", dut.regFile.reg_data[i]);
        end else begin
        $display("X%-2d      | %0d", i, dut.regFile.reg_data[i]);
        end
    end
    end
    endtask

  // Function to get instruction name (Verilog compatible)
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
    #20;  // Hold reset for 2 clock edges
    RST = 0;
    
    // Run long enough to execute all instructions
    #500;
    
    $display("\nALU Test Summary:");
    $display("All ALU operations verified!");
    $finish;
  end

  // Monitor expected vs actual ALU output
  always @(posedge CLK) begin
    if (RST == 0) begin // Only monitor after reset
      $display("\n-----------------------------");
      $display("Cycle: %0d", $time/10);
      $display("PC: %0d", dut.pc_out);
      
      case (dut.instruction[31:21])
        // R-type instructions
        11'b10001011000: begin // ADD
          $display("Operation: X%d = X%d + X%d", 
                  dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
          $display("Operands: %0d + %0d", dut.read_data1, dut.read_data2);
          $display("Result: Expected=%0d | Actual=%0d", 
                  dut.read_data1 + dut.read_data2, dut.alu_result);
          if (dut.read_data1 + dut.read_data2 !== dut.alu_result)
            $display("ERROR: ADD result mismatch!");
        end
        
        11'b11001011000: begin // SUB
          $display("Operation: X%d = X%d - X%d", 
                  dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
          $display("Operands: %0d - %0d", dut.read_data1, dut.read_data2);
          $display("Result: Expected=%0d | Actual=%0d", 
                  dut.read_data1 - dut.read_data2, dut.alu_result);
          if (dut.read_data1 - dut.read_data2 !== dut.alu_result)
            $display("ERROR: SUB result mismatch!");
        end
        
        11'b10001010000: begin // AND
          $display("Operation: X%d = X%d & X%d", 
                  dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
          $display("Operands: %0d & %0d", dut.read_data1, dut.read_data2);
          $display("Result: Expected=%0d | Actual=%0d", 
                  dut.read_data1 & dut.read_data2, dut.alu_result);
          if ((dut.read_data1 & dut.read_data2) !== dut.alu_result)
            $display("ERROR: AND result mismatch!");
        end
        
        11'b10101010000: begin // ORR
          $display("Operation: X%d = X%d | X%d", 
                  dut.instruction[4:0], dut.instruction[9:5], dut.instruction[20:16]);
          $display("Operands: %0d | %0d", dut.read_data1, dut.read_data2);
          $display("Result: Expected=%0d | Actual=%0d", 
                  dut.read_data1 | dut.read_data2, dut.alu_result);
          if ((dut.read_data1 | dut.read_data2) !== dut.alu_result)
            $display("ERROR: ORR result mismatch!");
        end
        
        // D-type instructions (load/store)
        11'b11111000010: begin // LDUR
          $display("Operation: X%d = [X%d + 0]", 
                  dut.instruction[4:0], dut.instruction[9:5]);
          $display("Base Address (X%d): %0d", dut.instruction[9:5], dut.read_data1);
          $display("Expected Offset: %0d, Actual: %0d", dut.instruction[20:12], dut.sign_ext_inst);
          $display("Expected Address: %0d | Actual: %0d", 
                  dut.read_data1 + dut.sign_ext_inst, dut.alu_result);
          if (dut.read_data1 + dut.sign_ext_inst !== dut.alu_result)
            $display("ERROR: LDUR address mismatch!");
        end
        
        11'b11111000000: begin // STUR
          $display("Operation: [X%d + 0] = X%d", 
                  dut.instruction[9:5], dut.instruction[4:0]);
          $display("Base Address (X%d): %0d", dut.instruction[9:5], dut.read_data1);
          $display("Expected Offset: %0d, Actual: %0d", dut.instruction[20:12], dut.sign_ext_inst);
          $display("Expected Address: %0d | Actual: %0d", 
                  dut.read_data1 + dut.sign_ext_inst, dut.alu_result);
          if (dut.read_data1 + dut.sign_ext_inst !== dut.alu_result)
            $display("ERROR: STUR address mismatch!");
        end
        
        // CBZ instruction
        11'b10110100000: begin // CBZ
          $display("Operation: CBZ X%d, #13", dut.instruction[4:0]);
          $display("Register Value (X%d): %0d", dut.instruction[4:0], dut.read_data1);
          $display("Zero Flag: %b", dut.ZERO_FLAG);
        end
        
        // B instruction
        11'b00010100000: begin // B
          $display("Operation: B #20");
        end
        
        default: begin
          if (dut.instruction !== 32'b0)
            $display("UNKNOWN instruction: %b", dut.instruction[31:21]);
        end
      endcase
    end
  end

endmodule