module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);

    reg [3:0] q_temp=4'b0;

    always @(posedge clk) begin
        if (shift_ena) q_temp <= {q_temp[2:0], data};
        if (count_ena) q_temp <= q_temp + 4'b1111;
    end

    assign q = q_temp;

endmodule
