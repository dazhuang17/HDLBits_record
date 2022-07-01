module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

    parameter S0=2'b00,
    		  S1=2'b01,
    		  S2=2'b10,
    		  S3=2'b11;

    reg [2:0] state,next_state;

    always @(*) begin
        case(state)
            S0: next_state = in[3] ? S1 : S0;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = in[3] ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= S0;
        else state <= next_state;
    end

    assign done = (state==S3);

endmodule
