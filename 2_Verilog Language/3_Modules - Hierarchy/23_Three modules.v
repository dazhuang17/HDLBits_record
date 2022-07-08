module top_module ( input clk, input d, output q );

    wire q0,q1,q2;
    my_dff my_dff_0 (
        .clk(clk),
        .d(d),
        .q(q0)
    );

    my_dff my_dff_1 (
        .clk(clk),
        .d(q0),
        .q(q1)
    );

    my_dff my_dff_2 (
        .clk(clk),
        .d(q1),
        .q(q)
    );

endmodule
