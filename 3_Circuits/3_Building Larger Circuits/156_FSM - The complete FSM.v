module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );

    parameter A=4'b0000,B=4'b0001,
    		  C=4'b0010,D=4'b0011,
    		  E=4'b0100,F=4'b0101,
    		  H=4'b0110,I=4'b0111,
    		  M=4'b1000,N=4'b1001;

    reg [3:0] state,next_state;

    always @(*) begin
        case(state)
            A: next_state = data ? B : A;
            B: next_state = data ? C : A;
            C: next_state = data ? C : D;
            D: next_state = data ? E : A;
            E: next_state = F;
            F: next_state = H;
            H: next_state = I;
            I: next_state = M;
            M: next_state = done_counting ? N : M;
            N: next_state = ack ? A : N;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) state <= A;
        else state <= next_state;
    end

    assign shift_ena = (state==E | state==F | state==H | state==I);
    assign counting = (state==M);
    assign done = (state==N);

endmodule
