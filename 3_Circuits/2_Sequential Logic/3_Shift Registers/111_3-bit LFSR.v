module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q

    reg [2:0] temp;
    always @(posedge KEY[0]) begin
        temp <= KEY[1] ? SW : {temp[1] ^ temp[2], temp[0], temp[2]};
    end
    assign LEDR = temp;

endmodule
