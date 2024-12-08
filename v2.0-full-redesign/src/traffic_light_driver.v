module traffic_light_driver (
    input wire [3:0] light_signal, // FSM output signal
    output reg [1:0] NS_light,     // Traffic light signals for North-South Lane 1
    output reg [1:0] SN_light,     // Traffic light signals for South-North Lane 2
    output reg [1:0] EW_light,     // Traffic light signals for East-West Lane 1
    output reg [1:0] WE_light      // Traffic light signals for West-East Lane 2
);

    // Traffic light states
    localparam RED    = 2'b00;    // Traffic light is RED
    localparam GREEN  = 2'b01;    // Traffic light is GREEN
    localparam YELLOW = 2'b10;    // Traffic light is YELLOW

    // Light control logic
    always @(*) begin
        // Decode FSM signal to control traffic lights
        case (light_signal)
            // All lanes red (safe state)
            4'b0000: begin
                NS_light = RED;
                SN_light = RED;
                EW_light = RED;
                WE_light = RED;
            end

            // North-South Lane 1: GREEN
            4'b0001: begin
                NS_light = GREEN;
                SN_light = RED;
                EW_light = RED;
                WE_light = RED;
            end

            // North-South Lane 1: YELLOW
            4'b0010: begin
                NS_light = YELLOW;
                SN_light = RED;
                EW_light = RED;
                WE_light = RED;
            end

            // South-North Lane 2: GREEN
            4'b0011: begin
                NS_light = RED;
                SN_light = GREEN;
                EW_light = RED;
                WE_light = RED;
            end

            // South-North Lane 2: YELLOW
            4'b0100: begin
                NS_light = RED;
                SN_light = YELLOW;
                EW_light = RED;
                WE_light = RED;
            end

            // East-West Lane 1: GREEN
            4'b0101: begin
                NS_light = RED;
                SN_light = RED;
                EW_light = GREEN;
                WE_light = RED;
            end

            // East-West Lane 1: YELLOW
            4'b0110: begin
                NS_light = RED;
                SN_light = RED;
                EW_light = YELLOW;
                WE_light = RED;
            end

            // West-East Lane 2: GREEN
            4'b0111: begin
                NS_light = RED;
                SN_light = RED;
                EW_light = RED;
                WE_light = GREEN;
            end

            // West-East Lane 2: YELLOW
            4'b1000: begin
                NS_light = RED;
                SN_light = RED;
                EW_light = RED;
                WE_light = YELLOW;
            end

            // Default case: All lanes red
            default: begin
                NS_light = RED;
                SN_light = RED;
                EW_light = RED;
                WE_light = RED;
            end
        endcase
    end

endmodule
