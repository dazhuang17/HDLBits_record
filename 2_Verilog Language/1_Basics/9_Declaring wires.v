`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
    wire m;
    assign m = ((a & b) | (c & d));
    assign out = m;
    assign out_n = ~m;
endmodule
