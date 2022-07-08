module top_module(
    input [3:0] in,
    output [2:0] out_both,
    output [3:1] out_any,
    output [3:0] out_different );
    int i,n,m;
    always @(*) begin
        for(i = 0; i < 3; i = i + 1)
            out_both[i] = in[i] & in[i + 1];
    end

    always @(*) begin
        for(n = 1; n < 4; n = n + 1)
            out_any[n] = in[n] | in[n - 1];
    end

    always @(*) begin
        for(m = 0; m < 4; m = m + 1) begin
            if (m != 3)
                out_different[m] = in[m] ^ in[m + 1];
            else
                out_different[3] = in[3] ^ in[0];
        end
    end

endmodule
