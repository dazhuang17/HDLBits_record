module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging );

    parameter LEFT=3'b000, RIGHT=3'b001, down_l=3'b010, down_r=3'b011, DIG_L=3'b100, DIG_R=3'b101;
    reg [2:0] state, next_state;

    always @(*) begin
        case(state)
            LEFT: next_state = ground ? (dig ? DIG_L : (bump_left ? RIGHT : LEFT)) : down_l;
            RIGHT: next_state = ground ? (dig ? DIG_R : (bump_right ? LEFT : RIGHT)) : down_r;
            DIG_L : next_state = ground ? DIG_L : down_l;
            DIG_R : next_state = ground ? DIG_R : down_r;
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
    assign digging = (state == DIG_L | state == DIG_R);

endmodule
