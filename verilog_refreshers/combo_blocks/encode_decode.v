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

module decoder_2_4(
    input wire EIN,
    input wire EOUT,
    input wire [1:0] in,
    output wire [3:0] out
);

reg [3:0] temp;

always @ (EIN, EOUT, in) begin
    if (EIN & ~EOUT) begin
        case(in)
        2'b00: temp <= 4'd1;
        2'b01: temp <= 4'd2;
        2'b10: temp <= 4'd4;
        2'b11: temp <= 4'd8;
        default: temp <= 4'd0;
    endcase
    end

    else begin
        // no input was asserted
        temp <= 4'd0;
    end 
end

assign out = temp;

endmodule