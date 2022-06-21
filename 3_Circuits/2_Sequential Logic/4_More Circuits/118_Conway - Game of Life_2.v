module top_module(
input clk,
input load,
input [255:0] data,
output [255:0] q );

    int i,j;
    reg [255:0] q_temp;
    wire [17:0] q_ext[17:0];
    always@(*) begin
        for(i=0;i<18;i=i+1)begin
            if (i==0) q_ext[0][17:0] = {q_temp[240], q_temp[255:240], q_temp[255]};
            else if (i==17) q_ext[17][17:0] = {q_temp[0], q_temp[15:0], q_temp[15]};
            else q_ext[i][17:0] = {q_temp[16*i-16], q_temp[(i*16-1)-:16], q_temp[16*i-1]};
        end
    end


    wire [2:0] q_num_temp[15:0][15:0];
    always@(*) begin
        for(i=1;i<17;i=i+1)begin
            for(j=1;j<17;j=j+1)begin
                q_num_temp[i-1][j-1] = q_ext[i-1][j-1] + q_ext[i-1][j] + q_ext[i-1][j+1]
                                     + q_ext[i][j-1]                   + q_ext[i][j+1]
                                     + q_ext[i+1][j-1] + q_ext[i+1][j] + q_ext[i+1][j+1];
            end
        end
    end

    always @(posedge clk)begin
        if(load)begin
            q_temp <= data;
        end
        else begin
            for(i=0; i<16; i=i+1)begin
                for(j=0; j<16; j=j+1)begin
                    case(q_num_temp[i][j])
                        3'd2: q_temp[16*i+j] <= q_temp[16*i+j];
                        3'd3: q_temp[16*i+j] <= 1'b1;
                        default: q_temp[16*i+j] <= 1'b0;
                    endcase
                end
            end
        end
    end

    assign q = q_temp;

endmodule
