module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q );
    reg [511:0] q_temp;
    always @(posedge clk)begin
        if (load) q_temp <= data;
        else q_temp <= (q_temp ^ (q_temp<<1)) | ~(q_temp>>1)&q_temp&(q_temp<<1);
    end
    assign q = q_temp;
endmodule
