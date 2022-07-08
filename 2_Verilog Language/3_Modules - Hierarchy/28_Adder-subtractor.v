module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire [31:0] b_h;
    assign b_h = {32{sub}} ^ b;
    wire cout;
    add16 u1_add16(
        .a(a[15:0]		),
        .b(b_h[15:0]		),
        .cin(sub		),
        .sum(sum[15:0]	),
        .cout(cout		)
    );

    add16 u2_add16(
        .a(a[31:16]		),
        .b(b_h[31:16]		),
        .cin(cout		),
        .sum(sum[31:16]	),
        .cout(			)
    );

endmodule
