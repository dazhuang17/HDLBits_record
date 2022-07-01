module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter A=1'b0,
              B=1'b1;
    reg state,next_state;
    always @(*) begin
        case(state)
            A: next_state = s ? B : A;
            B : next_state = B;
            default: next_state = A;
        endcase
    end

    always @(posedge clk)begin
        if (reset) state <= A;
        else state <= next_state;
    end

    reg [1:0] temp;
    reg [1:0] cnt=2'b0;
    reg flag;
    always @(posedge clk)begin
        if (reset) begin
            flag <= 1'b0;
            cnt <= 3'b0;
        end
        else if (state==B) begin
            //flag <= 1'b1;
            if (cnt==3'd2)begin
                cnt <= 3'b0;
                if (temp[1]+temp[0]+w == 2'd2) begin
                //if(~(^temp ^ w))begin
                    flag <= 1'b1;
                    //temp <= 2'b0;
                end
                else flag <= 1'b0;
            end
            else begin
                temp <= {temp[0],w};
                cnt <= cnt + 1'b1;
                flag <= 1'b0;
            end
        end
    end

    assign z = flag;

endmodule
