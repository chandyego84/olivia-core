`timescale 1ns/1ps

module register_file_tb;

    // Inputs for Register File
    reg REGWRITE;
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
        .REGWRITE(REGWRITE),
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
        REGWRITE = 0;
        read1 = 5'd0;
        read2 = 5'd1;
        write_reg = 5'd2;
        writeData = 64'd1234;
        
        rm = 5'd0;
        rt = 5'd1;
        REG2LOC = 0;  // Initially select `rm`
        
        // Initial write to the register file
        #10;
        REGWRITE = 1;
        write_reg = 5'd2;  // Writing to register X2
        writeData = 64'd99999;
        
        // Wait for the write to complete
        #10;
        
        // Read data from register 1 and 2
        read1 = 5'd1;
        read2 = 5'd2;

        #10; // wait for write to complete
        
        // Display the data
        $display("Register X1: %d", read_data1);
        $display("Register X2: %d", read_data2);

        // Test the Register Mux: select `rm` (should be register X0)
        REG2LOC = 0;  // Select `rm`
        #10;
        $display("Register Mux Output (should be rm): %d", mux_out);
        
        // Test Register Mux: select `rt` (should be register X1)
        REG2LOC = 1;  // Select `rt`
        #10;
        $display("Register Mux Output (should be rt): %d", mux_out);
        
        // Verify X31 remains zero
        $display("X31 before write: %d", regFile.reg_data[31]);
        REGWRITE = 1;
        write_reg = 5'd31;
        writeData = 64'd99999;
        #10;
        $display("X31 after write (should still be 0): %d", regFile.reg_data[31]);
        
        // End simulation
        $finish;
    end

endmodule
