// 64b mux
module Mux_64(
    input wire SEL,
    input wire [63:0] inp1, // true case
    input wire [63:0] inp2, // false case
    output wire [63:0] out
);

assign out = SEL ? inp1 : inp2; 

endmodule