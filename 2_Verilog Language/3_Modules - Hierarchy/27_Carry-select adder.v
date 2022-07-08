module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire sel;
    wire [15:0] ad16,ad16_no;
    add16 u1_add16(
        .a(a[15:0]		),
        .b(b[15:0]		),
        .cin(1'b0		),
        .sum(sum[15:0]	),
        .cout(sel		)
    );

    add16 u2_add16(
        .a(a[31:16]		),
        .b(b[31:16]		),
        .cin(1'b0		),
        .sum(ad16_no	),
        .cout(			)
    );

    add16 u3_add16(
        .a(a[31:16]		),
        .b(b[31:16]		),
        .cin(1'b1		),
        .sum(ad16		),
        .cout(			)
    );


    always @(*) begin
        case(sel)
            1'b0: sum[31:16] <= ad16_no;
            1'b1: sum[31:16] <= ad16;
        endcase
    end

endmodule
