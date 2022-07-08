module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output wire out_assign,
    output reg out_always   );

    wire [1:0] sel;
    assign sel = {sel_b1,sel_b2};
    always @(*) begin
        case(sel)
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

endmodule
