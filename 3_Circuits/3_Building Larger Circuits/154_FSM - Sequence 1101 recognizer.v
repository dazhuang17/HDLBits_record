module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);

    parameter A=3'b000,
    		  B=3'b001,
    		  C=3'b010,
    		  D=3'b011,
    		  E=3'b100;

    reg [2:0] state,next_state;

    always @(*) begin
        case(state)
            A: next_state = data ? B : A;
            B: next_state = data ? C : A;
            C: next_state = data ? C : D;
            D: next_state = data ? E : A;
            E: next_state = E;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next_state;
    end

    assign start_shifting = (state==E);

endmodule
