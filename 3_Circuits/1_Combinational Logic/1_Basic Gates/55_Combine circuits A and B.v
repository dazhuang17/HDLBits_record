module top_module (input x, input y, output z);
    wire za;
    wire zb;

    assign za = (x ^ y) & x;
    assign zb = ~(x ^ y);
    assign z = (za | zb) ^ (za & zb);

endmodule
