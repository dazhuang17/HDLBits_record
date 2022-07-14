`timescale 1ps / 1ps
module top_module();

    reg clk;
    reg [2:0] s;
    reg in;
    wire out;

    q7 u_q7(clk, in, s, out);

    initial begin
        clk = 1'b0;
        in = 1'b0;
        s = 2;
        #10
        s = 6;
        #10
        in = 1;
        s = 2;
        #10
        in = 0;
        s = 7;
        #10
        in = 1;
        s = 0;
        #30
        in = 0;
    end

    always #5 clk = ~clk;

endmodule
