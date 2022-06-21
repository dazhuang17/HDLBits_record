module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q);

    reg [63:0] data_temp;
    always @(posedge clk) begin
        if (load) data_temp <= data;
        else if (ena)
        	case(amount)
                2'b00: data_temp <= {data_temp[62:0], 1'b0};
                2'b01: data_temp <= {data_temp[55:0], 8'b0};
                2'b10: data_temp <= {{2{data_temp[63]}}, data_temp[62:1]};
                2'b11: data_temp <= {{9{data_temp[63]}}, data_temp[62:8]};
        	endcase
        else data_temp <= data_temp;
    end

    assign q = data_temp;

endmodule
