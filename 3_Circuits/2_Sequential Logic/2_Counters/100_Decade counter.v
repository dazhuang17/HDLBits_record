module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk)
    if (reset) q <= 0;
    else q <= q < 9 ? q + 1 : 0;

endmodule