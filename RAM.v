module RAM(
    input wire clk,
    input wire MEM_WRITE,
    input wire MEM_READ,
    input wire [63:0] address, 
    input wire [63:0] write_data,
    output reg [63:0] read_data // output muxxed with ALU_RESULT
);

reg [63:0] mem_data [127:0];

integer m;
initial begin 
    // init the ram with zero values 
    for (m = 0; m < 128; m = m + 1) begin
        mem_data[m] = 100*m;
    end

    // init to these values for testing
    mem_data[10] = 1540;
    mem_data[11] = 2117;
end

always @ (*) begin
    if (MEM_READ) begin
        read_data = mem_data[address];
    end
end

always @ (posedge(clk)) begin 
    if (MEM_WRITE) begin
        mem_data[address] = write_data;
    end
end

endmodule