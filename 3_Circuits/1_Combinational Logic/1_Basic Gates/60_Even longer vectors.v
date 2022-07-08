module top_module(
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );
    int i,n,m;
    always @(*) begin
        for(i = 0; i < 99; i = i + 1)
            out_both[i] = in[i] & in[i + 1];
    end

    always @(*) begin
        for(n = 1; n < 100; n = n + 1)
            out_any[n] = in[n] | in[n - 1];
    end

    always @(*) begin
        for(m = 0; m < 100; m = m + 1) begin
            if (m != 99)
                out_different[m] = in[m] ^ in[m + 1];
            else
                out_different[99] = in[99] ^ in[0];
        end
    end

endmodule
