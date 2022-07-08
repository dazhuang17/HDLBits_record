module top_module (
    input clk,
    input x,
    output z
);
    reg [2:0] num;
    always @(posedge clk) begin
        num[2] <= num[2] ^ x;
        num[1] <= x & ~num[1];
        num[0] <= x | ~num[0];
    end
    assign z = ~(|num);

endmodule
