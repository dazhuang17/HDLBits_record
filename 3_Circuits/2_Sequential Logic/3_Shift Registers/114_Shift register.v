module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //
    // clk,E,L,INPUT_Q,W,R,OUT
    MUXDFF U_MUXDFF_3(KEY[0], KEY[1], KEY[2], LEDR[3], KEY[3], SW[3], LEDR[3]);
    MUXDFF U_MUXDFF_2(KEY[0], KEY[1], KEY[2], LEDR[2], LEDR[3], SW[2], LEDR[2]);
    MUXDFF U_MUXDFF_1(KEY[0], KEY[1], KEY[2], LEDR[1], LEDR[2], SW[1], LEDR[1]);
    MUXDFF U_MUXDFF_0(KEY[0], KEY[1], KEY[2], LEDR[0], LEDR[1], SW[0], LEDR[0]);

endmodule

module MUXDFF (
    input clk,
    input E,
    input L,
    input q0,
    input W,
    input R,
    output q
    );
    reg q_t;
    assign q_t = L ? R : (E ? W : q0);
    always @(posedge clk)begin
        q <= q_t;
    end

endmodule
