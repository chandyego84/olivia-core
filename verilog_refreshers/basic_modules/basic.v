/* easy logic gates */
module AND(a,b);
    input wire a;
    input wire b;

    output wire c;

    assign c = a && b;

endmodule

module OR(a, b);
    input wire a;
    input wire b;

    output wire c;

    assign c = a || b;

endmodule

// universal gate
module NOR(a, b);
    input wire a;
    input wire b;

    output wire c;

    assign c = ~(a | b);

endmodule

// universal gate
module NAND(a, b);
    input wire a;
    input wire b;

    output wire c;

    assign c = ~(a & b);

endmodule

module XOR(a, b);
    input wire a;
    input wire b;

    output wire c;

    // assign c = a ^ b
    assign c = (a & ~b) | (~a & b);

endmodule

module XNOR(a, b)
    input wire a;
    input wire b;

    assign c = ~(a ^ b)
endmodule