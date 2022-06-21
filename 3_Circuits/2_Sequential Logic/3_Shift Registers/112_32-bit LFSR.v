module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
);
    reg [31:0] temp;
    always @(posedge clk) begin
        if (reset) temp <= 32'h1;
        else begin
            temp <= {temp[0],temp[31:23],temp[22]^temp[0],temp[21:3],temp[2]^temp[0],temp[1]^temp[0]};
        end
    end
    assign q = temp;

endmodule
