module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
    wire [1:0] temp;
    reg out;
    assign temp[0] = E ? w : Q;
    assign temp[1] = L ? R : temp[0];

    always @(posedge clk) begin
        out <= temp[1];
    end

    assign Q = out;

endmodule
