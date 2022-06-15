module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q
    );
    always @(posedge clk)begin
        if (reset) q <= 4'b0;
        else begin
            if (slowena) begin
                if (q == 4'd9) q <= 4'b0;
                else q <= q + 1'b1;
            end
            else q <= q;
        end
    end

endmodule
