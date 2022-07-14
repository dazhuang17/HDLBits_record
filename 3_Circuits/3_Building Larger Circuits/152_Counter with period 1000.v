module top_module (
    input clk,
    input reset,
    output [9:0] q);

    reg [9:0] q_temp;

    always @(posedge clk) begin
        if (reset) q_temp <= 10'b0;
        else if (q_temp == 10'd999) q_temp <= 10'b0;
        else q_temp <= q_temp + 1'b1;
    end

    assign q = q_temp;

endmodule
