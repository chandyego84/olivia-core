module Register_Mux(
    input wire REG2LOC, // CONTROL SIGNAL
    input wire [4:0] rm, // 20-16 for R-type
    input wire [4:0] rt, // 4-0 for register to be written by a load
    output wire [4:0] out
);


assign out = REG2LOC ? rt : rm; 

endmodule