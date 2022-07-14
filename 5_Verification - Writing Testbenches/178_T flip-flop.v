`timescale 1ps / 1ps
module top_module ();
    reg clk,reset,t;
    wire q;

    tff u_tff (clk, reset, t, q);

    initial begin
        clk = 0;
        reset = 0;
        #5
        reset = 1;
        #5
        reset = 0;
    end

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (reset) t <= 0;
        else t <= 1;
    end

endmodule
