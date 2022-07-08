module top_module(
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );

    int i;
    always @(*) begin
        for(i=0;i<100;i=i+1)begin
            {cout[i],sum[i]} = a[i] + b[i] + ((i == 0) ? cin : cout[i-1]);
        end
    end

endmodule
