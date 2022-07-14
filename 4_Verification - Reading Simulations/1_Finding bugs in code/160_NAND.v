module top_module (input a, input b, input c, output out);//

	wire out_1;
    andgate inst1 ( out_1, a, b, c, 1'b1, 1'b1 );
    assign out = ~out_1;

endmodule
