`timescale 1ns/1ps

module Program_Counter(
    input clk,
    input rst,
    input [63:0] pc_in,
    output reg [63:0] pc_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out <= 0;
    end 
    else begin
        pc_out <= pc_in;  
    end
end

endmodule
