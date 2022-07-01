module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

    parameter error=4'd0,
              data_0=4'd1,
              data_1=4'd2,
              data_2=4'd3,
              data_3=4'd4,
              data_4=4'd5,
              data_5=4'd6,
              data_6=4'd7,
              data_7=4'd8,
              dis=4'd9,
    		  fla=4'd12,
              idle=4'd10;

    reg [3:0] state,next_state;
    always @(*) begin
        case(state)
            //idle: next_state = in ? idle : data_0;
            data_0 : next_state = in ? data_1 : data_0;
            data_1 : next_state = in ? data_2 : data_0;
            data_2 : next_state = in ? data_3 : data_0;
            data_3 : next_state = in ? data_4 : data_0;
            data_4 : next_state = in ? data_5 : data_0;
            data_5 : next_state = in ? data_6 : dis;
            data_6 : next_state = in ? error : fla;
            fla : next_state = in ? data_1 : data_0;
            dis : next_state = in ? data_1 : data_0;
            error : next_state = in ? error : data_0;
            default: next_state = data_0;
        endcase
    end

    always @(posedge clk) begin
        if(reset) state <= data_0;
        else state <= next_state;
    end

    assign disc = (state==dis);
    assign flag = (state==fla);
    assign err = (state==error);

endmodule
