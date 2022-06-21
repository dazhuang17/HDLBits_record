module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    output [4:0] q
);
    reg [4:0] temp;
    always @(posedge clk) begin
        if (reset) temp <= 5'h1;
        else begin
            temp[4] <= 1'b0 ^ temp[0];
            temp[3] <= temp[4];
            temp[2] <= temp[3] ^ temp[0];
            temp[1] <= temp[2];
            temp[0] <= temp[1];
        end
    end
    assign q = temp;

endmodule
