module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    reg [8:0] num;
 	assign num = a + b;
    assign s = num[7:0];
    assign overflow = ~s[7]&a[7]&b[7] | s[7]&~a[7]&~b[7];

endmodule
