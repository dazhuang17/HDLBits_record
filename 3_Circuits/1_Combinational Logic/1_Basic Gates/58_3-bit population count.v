module top_module(
    input [2:0] in,
    output [1:0] out );

    int i;
    always @(*) begin
        out = 0;
        for(i = 0;i < 3;i = i + 1)
            if (in[i])
            	out = out + 1'b1;
    end

endmodule
