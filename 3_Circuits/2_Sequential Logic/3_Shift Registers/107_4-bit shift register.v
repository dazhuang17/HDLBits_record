module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q);

    reg [3:0] data_temp;
    always @(posedge clk or posedge areset) begin
        if (areset) data_temp <= 4'b0;
        else if (load) data_temp <= data;
        else if (ena)begin
            if (load) data_temp <= data;
            else data_temp <= {1'b0, data_temp[3:1]};
        end
    end

    assign q = data_temp;

endmodule
