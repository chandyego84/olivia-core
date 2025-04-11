`timescale 1ns/1ps

module register_file_tb;

    // Inputs for Register File
    reg REG_WRITE;
    reg [4:0] read1, read2, write_reg;
    reg [63:0] writeData;
    
    // Inputs for Register Mux
    reg [4:0] rm, rt;
    reg REG2LOC;
    
    // Outputs for Register File
    wire [63:0] read_data1, read_data2;
    
    // Output for Register Mux
    wire [4:0] mux_out;
    
    // Instantiate the Register File
    Register_File regFile(
        .REG_WRITE(REG_WRITE),
        .read1(read1),
        .read2(read2),
        .write_reg(write_reg),
        .writeData(writeData),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Instantiate the Register Mux
    Register_Mux regMux(
        .rm(rm),
        .rt(rt),
        .REG2LOC(REG2LOC),
        .out(mux_out)
    );

    initial begin
        // Initialize inputs
        REG_WRITE = 0;
        read1 = 5'd0;
        read2 = 5'd1;
        write_reg = 5'd2;
        writeData = 64'd1234;
        
        rm = 5'd0;
        rt = 5'd1;
        REG2LOC = 0;  // Initially select `rm`
        
        // Display all initial register values
        $display("\nInitial Register Values:");
        $display("-----------------------");
        for (integer i = 0; i < 32; i = i + 1) begin
            if (i == 31) begin
                $display("XZR (X31): %0d (should be 0)", regFile.reg_data[i]);
            end else begin
                $display("X%0d: %0d", i, regFile.reg_data[i]);
            end
        end
        $display("-----------------------\n");
        
        // Initial write to the register file
        #10;
        REG_WRITE = 1;
        write_reg = 5'd2;  // Writing to register X2
        writeData = 64'd99999;
        
        // Wait for the write to complete
        #10;
        
        // Read data from register 1 and 2
        read1 = 5'd1;
        read2 = 5'd2;

        #10; // wait for write to complete
        
        // Display the data
        $display("Current Register Values:");
        $display("X1: %d", read_data1);
        $display("X2: %d (should be 99999)", read_data2);

        // Test the Register Mux: select `rm` (should be register X0)
        REG2LOC = 0;  // Select `rm`
        #10;
        $display("\nRegister Mux Output (should be rm=0): %d", mux_out);
        
        // Test Register Mux: select `rt` (should be register X1)
        REG2LOC = 1;  // Select `rt`
        #10;
        $display("Register Mux Output (should be rt=1): %d", mux_out);
        
        // Verify X31 remains zero
        $display("\nTesting XZR (X31):");
        $display("X31 before write: %d (should be 0)", regFile.reg_data[31]);
        REG_WRITE = 1;
        write_reg = 5'd31;
        writeData = 64'd99999;
        #10;
        $display("X31 after write attempt: %d (should still be 0)", regFile.reg_data[31]);
        
        // Display final register values
        $display("\nFinal Register Values:");
        $display("---------------------");
        for (integer i = 0; i < 32; i = i + 1) begin
            if (i == 2) begin
                $display("X%0d: %0d (should be 99999)", i, regFile.reg_data[i]);
            end else if (i == 31) begin
                $display("XZR (X31): %0d (should be 0)", regFile.reg_data[i]);
            end else begin
                $display("X%0d: %0d", i, regFile.reg_data[i]);
            end
        end
        
        // End simulation
        $finish;
    end

endmodule