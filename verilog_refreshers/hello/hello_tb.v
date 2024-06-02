`timescale 1ns/1ns

module hello_tb;

reg A;
wire B;

hello uut(A,B);

initial begin
    $dumpfile("hello_tb.vcd"); // create a file that contains the dumped waveforms
    // 0 indicating dumping all variables in ALL lower level modules instantiated by this top module
    // ex., 1 would indicate dumping variables of only the top module
    $dumpvars(0, hello_tb); // define the scope of the dump

    A = 0;
    #20;

    A = ~A;
    #20;

    A = ~A;
    #20;

    $display("Test completed.");
end

initial begin
    // track states of A and B
    $monitor("A=%d, B=%d\n", A, B);
end

endmodule