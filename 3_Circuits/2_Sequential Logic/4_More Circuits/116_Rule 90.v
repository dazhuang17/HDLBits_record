module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q );
    reg [511:0] q_temp;
    always @(posedge clk)begin
        if (load) q_temp <= data;
        else q_temp <= {q_temp[510:0], 1'b0} ^ {1'b0, q_temp[511:1]};
    end
    assign q = q_temp;
endmodule
