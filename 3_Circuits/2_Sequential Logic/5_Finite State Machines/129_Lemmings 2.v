module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah );

    parameter LEFT=2'b00, RIGHT=2'b01, down_l=2'b10, down_r=2'b11;
    reg [1:0] state, next_state;

    always @(*) begin
        case(state)
            LEFT: next_state = ground ? (bump_left ? RIGHT : LEFT) : down_l;
            RIGHT: next_state = ground ? (bump_right ? LEFT : RIGHT) : down_r;
            down_l: next_state = ground ? LEFT : down_l;
            down_r: next_state = ground ? RIGHT : down_r;
            default: next_state = LEFT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if (areset) state <= LEFT;
        else state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == down_l | state == down_r);

endmodule
