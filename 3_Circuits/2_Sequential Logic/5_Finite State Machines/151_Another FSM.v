module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    parameter A = 0,
              B = 1,
              C = 2,
              D = 3,
              E = 4,
              F = 5,
              G = 6,
              LOW = 7,
              HIGH = 8;

    reg [3:0] state, next_state;

    always @(*)
        case (state)
            A: next_state = B;
            B: next_state = C;
            C: next_state = x ? D : C;
            D: next_state = x ? D : E;
            E: next_state = x ? F : C;
            F: next_state = y ? HIGH : G;
            G: next_state = y ? HIGH : LOW;
            LOW: next_state = LOW;
            HIGH: next_state = HIGH;
            default: next_state = A;
        endcase

    always @(posedge clk) begin
        if (~resetn) state <= A;
        else state <= next_state;
    end

    assign f = (state == B);
    assign g = (state == F | state == G | state == HIGH);

endmodule
