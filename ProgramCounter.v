`timescale 1ns/1ps`

module ProgramCounter(
    input clk,
    input rst,
    input [63:0] pc_in,
    output reg [63:0] pc_out
);

initial begin 
    pc_out = 0;
end

always @(posedge clk) begin
    pc_out <= pc_in;
end

always @(rst) begin
    pc_out = 0;
end

endmodule