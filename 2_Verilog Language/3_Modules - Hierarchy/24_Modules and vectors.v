module top_module (
    input clk,
    input [7:0] d,
    input [1:0] sel,
    output [7:0] q
);
    wire [7:0] q0,q1,q2;
    my_dff8 my_dff8_0 (
        .clk(clk),
        .d(d),
        .q(q0)
    );

    my_dff8 my_dff8_1 (
        .clk(clk),
        .d(q0),
        .q(q1)
    );

    my_dff8 my_dff8_2 (
        .clk(clk),
        .d(q1),
        .q(q2)
    );

    always @(*) begin
        case(sel)
            3'b00: q = d;
            3'b01: q = q0;
            3'b10: q = q1;
            3'b11: q = q2;
        endcase
    end

endmodule
