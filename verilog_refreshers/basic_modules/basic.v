/* easy logic gates */
module AND(a, b, c);
    input wire a;
    input wire b;

    output wire c;

    assign c = a && b;

endmodule

module OR(a, b, c);
    input wire a;
    input wire b;

    output wire c;

    assign c = a || b;

endmodule

// universal gate
module NOR(a, b, c);
    input wire a;
    input wire b;

    output wire c;

    assign c = ~(a || b);

endmodule

// universal gate
module NAND(a, b, c);
    input wire a;
    input wire b;

    output wire c;

    assign c = ~(a && b);

endmodule

module XOR(a, b, c);
    input wire a;
    input wire b;

    output wire c;

    assign c = (a && ~b) | (~a && b); // assign c = a ^ b


endmodule

module XNOR(a, b, c);
    input wire a;
    input wire b;

    output wire c;

    assign c = ~(a ^ b); // assign c = a ~^ b
endmodule