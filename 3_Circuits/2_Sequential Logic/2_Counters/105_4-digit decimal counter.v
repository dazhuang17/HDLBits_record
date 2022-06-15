module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);

    test u_test(
        .clk(clk),
        .reset(reset),
        .ena(1'b1),
        .q(q[3:0])
    );

    test u_test1(
        .clk(clk),
        .reset(reset),
        .ena(ena[1]),
        .q(q[7:4])
    );

    test u_test2(
        .clk(clk),
        .reset(reset),
        .ena(ena[2]),
        .q(q[11:8])
    );

    test u_test3(
        .clk(clk),
        .reset(reset),
        .ena(ena[3]),
        .q(q[15:12])
    );
    // 是否进位标志
    assign ena = {q[11:8] == 4'd9 && q[7:4] == 4'd9 && q[3:0] == 4'd9, q[7:4] == 4'd9 && q[3:0] == 4'd9, q[3:0] == 4'd9};

endmodule


module test (
    input clk,
    input reset,   // Synchronous active-high reset
    input  ena,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0;
        end
        else if (ena) begin
            if (q == 4'd9)
                q <= 4'd0;
            else
                q <= q + 1'b1;
        end
    end
endmodule
