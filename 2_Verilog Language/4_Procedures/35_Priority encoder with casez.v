module top_module (
    input [7:0] in,
    output reg [2:0] pos  );

    always @(*) begin
        casez(in)
            8'bzzzzzzzz1: pos = 0;
            8'bzzzzzzz1z: pos = 1;
            8'bzzzzzz1zz: pos = 2;
            8'bzzzzz1zzz: pos = 3;
            8'bzzzz1zzzz: pos = 4;
            8'bzz1zzzzzz: pos = 5;
            8'bz1zzzzzzz: pos = 6;
            8'b1zzzzzzzz: pos = 7;
            default: pos = 0;
        endcase
    end

endmodule
