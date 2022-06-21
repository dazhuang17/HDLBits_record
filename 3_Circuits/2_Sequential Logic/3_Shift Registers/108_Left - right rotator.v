module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q);

    reg [99:0] data_temp;
    always @(posedge clk) begin
        if (load) data_temp <= data;
        else case(ena)
            2'b01: data_temp <= {data_temp[0], data_temp[99:1]};
            2'b10: data_temp <= {data_temp[98:0], data_temp[99]};
            default: data_temp <= data_temp;
        endcase
    end

    assign q = data_temp;

endmodule
