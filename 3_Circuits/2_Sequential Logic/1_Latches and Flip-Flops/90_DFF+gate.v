module top_module (
    input clk,
    input in,
    output out);

    wire sum,out_0;
    always @(posedge clk)begin
        out_0 <= sum;
    end
    assign sum = out_0 ^ in;
    assign out = out_0;

endmodule
