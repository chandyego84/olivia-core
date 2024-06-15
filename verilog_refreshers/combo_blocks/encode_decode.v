/*
Encoders
- Reverse of a decoder in combo logic
- Receives N inputs (typically a power of two)
- Asserts an output binary code of M bits (M = log2N)
    - M-bit output indicates which input was asserted
*/

// more than one input line might be asserted
// priority to the highest numbered input that is asserted
module encoder_4_2(
    input wire EIN, // enable signal
    input wire [3:0] in,
    output wire EOUT, // asserted only if EIN asserted and no input asserted
    output wire [1:0] out
);

assign out[1] = in[3] | in[2] & EIN;
assign out[0] = in[3] | (~in[2] & in[1]) & EIN;
assign EOUT = EIN & ~(|in);


endmodule