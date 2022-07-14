`timescale 1ps / 1ps
module top_module ( );
    parameter timer=5;

    reg clk;
    dut u_dut( .clk(clk) ) ;

    initial begin
        clk = 0;
    end

    always begin
        # timer
        clk = ~clk;
    end

endmodule
