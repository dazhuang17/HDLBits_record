module top_module (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

wire [4:1] ena_temp;
// 00:00:00
assign ena_temp[1] = ena && ss[3:0] == 8'd9;
assign ena_temp[2] = ena_temp[1] && ss[7:4] == 8'd5;
assign ena_temp[3] = ena_temp[2] && mm[3:0] == 8'd9;
assign ena_temp[4] = ena_temp[3] && mm[7:4] == 8'd5;

cout #(.cin_cnt(9)) ss9 (clk, reset, ena, ss[3:0]);
cout #(.cin_cnt(5)) ss5 (clk, reset, ena_temp[1], ss[7:4]);
cout #(.cin_cnt(9)) mm9 (clk, reset, ena_temp[2], mm[3:0]);
cout #(.cin_cnt(5)) mm5 (clk, reset, ena_temp[3], mm[7:4]);
cout_h u_hh (clk, reset, ena_temp[4], hh);

// pm时序
always @(posedge clk)begin
    if (reset) pm <= 1'b0;
    if (ena_temp[4] && hh == 8'h11) pm <= ~pm;
end

endmodule

module cout (
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);
parameter cin_cnt = 9;
always @(posedge clk)
    if (reset) q <= 4'b0;
    else if (ena) begin
        if (q == cin_cnt)
            q <= 4'd0;
        else
            q <= q + 1'b1;
    end
endmodule

module cout_h (
    input clk,
    input reset,
    input ena,
    output reg [7:0] cout
);
always @(posedge clk)begin
    if (reset) begin
        cout <= 8'h12;
    end
    else begin
        if (ena) begin
            case (cout)
                8'h12: cout <= 8'h01;
                8'h09: cout <= 8'h10;
                default: cout[3:0] <= cout[3:0] + 1;
            endcase
        end
        else cout <= cout;
    end
end

endmodule
