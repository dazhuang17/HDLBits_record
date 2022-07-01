module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z );

    parameter A = 2'b00, B = 2'b01, C = 2'b10;
    reg [1:0] state, next_state;
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = x ? B : C;
            C: next_state = x ? B : A;
            default: next_state = A;
        endcase
    end

    always @(posedge clk or negedge aresetn) begin
        if (~aresetn) state <= A;
        else state <= next_state;
    end

    assign z = (state == C ? x : 1'b0);

endmodule
