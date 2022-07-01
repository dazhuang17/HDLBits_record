module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    parameter S0=2'b00,
    		  S1=2'b01,
    		  S2=2'b10,
    		  S3=2'b11;

    reg [2:0] state,next_state;
    //reg [7:0] temp8;
    reg [23:0] temp;

    always @(*) begin
        case(state)
            S0: begin
                next_state = in[3] ? S1 : S0;
                //temp8 = in[3] ? in : temp8;
            end
            S1: begin
                next_state = S2;
                //temp8 = in;
            end
            S2: begin
                next_state = S3;
                //temp8 = in;
            end
            S3: begin
                next_state = in[3] ? S1 : S0;
                //temp8 = in[3] ? in : temp8;
            end
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end
        else state <= next_state;
    end

    always @(posedge clk) begin
        if (reset) temp <= 23'd0;
        else temp <= {temp[15:0],in};
    end

    /*
    always @(posedge clk) begin
        if (reset) temp <= 24'b0;
        else case(next_state)
            S1: temp[23:16] <= temp8;
            S2: temp[15:8] <= temp8;
            S3: temp[7:0] <= temp8;
            default: temp <= temp;
        endcase
    end
    */

    assign done = (state==S3);
    assign out_bytes = temp;

endmodule
