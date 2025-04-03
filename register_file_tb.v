`timescale 1ns/1ps

module register_file_test;

    // Inputs
    reg REGWRITE;
    reg [4:0] read1;
    reg [4:0] read2;
    reg [4:0] write_reg;
    reg [63:0] writeData;

    // Outputs
    wire [63:0] read_data1;
    wire [63:0] read_data2;

    // Instantiate the Register_File module
    Register_File uut (
        .REGWRITE(REGWRITE),
        .read1(read1),
        .read2(read2),
        .write_reg(write_reg),
        .writeData(writeData),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        // Initialize
        REGWRITE = 0;
        write_reg = 0;
        writeData = 64'd0;
        read1 = 0;
        read2 = 0;

        // Wait for any initializations
        #10;

        // Check default values
        read1 = 5'd1;
        read2 = 5'd2;
        #10;
        $display("Read Reg 1 (X1): %d, Read Reg 2 (X2): %d", read_data1, read_data2);

        // Write to register X3
        REGWRITE = 1;
        write_reg = 5'd3;
        writeData = 64'd12345;
        #10;

        // Turn off write, read from X3
        REGWRITE = 0;
        read1 = 5'd3;
        read2 = 5'd0;
        #10;
        $display("After Write -> X3: %d", read_data1);

        // Write to X31 (should remain zero)
        REGWRITE = 1;
        write_reg = 5'd31;
        writeData = 64'd99999;
        #10;

        // Read from X31
        REGWRITE = 0;
        read1 = 5'd31;
        #10;
        $display("X31 (Should be 0): %d", read_data1);

        $finish;
    end

endmodule
