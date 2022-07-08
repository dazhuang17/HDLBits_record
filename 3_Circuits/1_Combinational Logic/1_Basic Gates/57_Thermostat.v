module top_module (
    input too_cold,
    input too_hot,
    input mode,
    input fan_on,
    output heater,
    output aircon,
    output fan
);
    // assign motor = mode ? (vibrate_mode ? 1'b1 : 1'b0) : 1'b0;
    always @(*) begin
        if (mode)begin
            if (too_cold) begin
                heater = 1'b1;
                aircon = 1'b0;
                // fan = 1'b1;
            end
            else begin
                heater = 1'b0;
                aircon = 1'b0;
                // fan = 1'b0;
            end
        end
        else begin
            if (too_hot) begin
                aircon = 1'b1;
                heater = 1'b0;
                // fan = 1'b1;
            end
            else begin
                heater = 1'b0;
                aircon = 1'b0;
                // fan = 1'b0;
            end
        end
    end

    always @(*) begin
        if (mode)begin
            if(too_cold | fan_on)
                fan = 1'b1;
            else
                fan = 1'b0;
        end
        else begin
            if(too_hot | fan_on)
                fan = 1'b1;
            else
                fan = 1'b0;
        end
    end

endmodule
