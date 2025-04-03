module Register_Mux(
    input wire [4:0] rm, // 20-16 for R-type
    input wire [4:0] rt, // 4-0 for register to be written by a load
    input wire REG2LOC, // CONTROL SIGNAL
    output wire [4:0] out
);


assign out = REG2LOC ? rm : rt; 

endmodule