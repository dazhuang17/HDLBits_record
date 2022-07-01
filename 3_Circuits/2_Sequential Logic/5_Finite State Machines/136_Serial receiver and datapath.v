module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    parameter error=4'd0,
              data_0=4'd1,
              data_1=4'd2,
              data_2=4'd3,
              data_3=4'd4,
              data_4=4'd5,
              data_5=4'd6,
              data_6=4'd7,
              data_7=4'd8,
              stop=4'd9,
              idle=4'd10;

    reg [3:0] state,next_state;

    always @(*) begin
        case(state)
            error: next_state = in ? idle : error;
            data_0 : next_state = data_1;
            data_1 : next_state = data_2;
            data_2 : next_state = data_3;
            data_3 : next_state = data_4;
            data_4 : next_state = data_5;
            data_5 : next_state = data_6;
            data_6 : next_state = data_7;
            data_7 : next_state = stop;
            stop : next_state = in ? idle : error;
            idle : next_state = in ? idle : data_0;
            default: next_state = idle;
        endcase
    end

    always @(posedge clk)begin
        if (reset) state <= idle;
        else state <= next_state;
    end

    reg temp;
    always @(posedge clk)begin
        if (state==stop) begin
            if(next_state==idle) temp <= 1'b1;
            else temp <= 1'b0;
        end
        else temp <= 1'b0;
    end

    reg [9:0] data;
    always @(posedge clk)begin
        if (reset) data <= 10'b0;
        else data <= {in, data[9:1]};
    end

    assign done = temp;
    assign out_byte = temp ? data[8:1] : out_byte;

endmodule
