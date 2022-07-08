module top_module (
    input [15:0] a, b,
    input cin,
    output cout,
    output [15:0] sum );

    wire single_0,single_1,single_2;
    bcd_fadd bcd_fadd_0 (a[3:0], b[3:0], cin, single_0, sum[3:0]);
    bcd_fadd bcd_fadd_1 (a[7:4], b[7:4], single_0, single_1, sum[7:4]);
    bcd_fadd bcd_fadd_2 (a[11:8], b[11:8], single_1, single_2, sum[11:8]);
    bcd_fadd bcd_fadd_3 (a[15:12], b[15:12], single_2, cout, sum[15:12]);

endmodule
