module top_module(
    input [99:0] in,
    output [99:0] out
);
    int i;
    always @(*) begin
        for (i = 0; i < 100; i = i + 1)
        	out[i] = in[99 - i];
    end

endmodule
