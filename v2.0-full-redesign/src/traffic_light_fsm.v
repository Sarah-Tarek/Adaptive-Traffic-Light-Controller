module fsm(
    input wire clk, rst,                   // System clock and reset signal
    input wire NS_S1, SN_S1, EW_S1, WE_S1, // Start sensors for respective directions
    input wire NS_S5, SN_S5, EW_S5, WE_S5, // Congestion sensors for respective directions
    output reg [3:0] state,                // Current FSM state
    output reg [3:0] light_signal          // Encoded traffic light signals
);

    // Internal signals
    reg [3:0] next_state;                  // Next FSM state logic

    // State encoding with Gray Code for minimal transitions
    localparam   ALL_RED           = 4'b0000, // All directions red
                 NS_PRIMARY_GREEN  = 4'b0001, // North-South primary green
                 NS_EXTENDED_GREEN = 4'b0010, // North-South extended green
                 NS_YELLOW         = 4'b0011, // North-South yellow
                 SN_PRIMARY_GREEN  = 4'b0100, // South-North primary green
                 SN_EXTENDED_GREEN = 4'b0101, // South-North extended green
                 SN_YELLOW         = 4'b0110, // South-North yellow
                 EW_PRIMARY_GREEN  = 4'b0111, // East-West primary green
                 EW_EXTENDED_GREEN = 4'b1000, // East-West extended green
                 EW_YELLOW         = 4'b1001, // East-West yellow
                 WE_PRIMARY_GREEN  = 4'b1010, // West-East primary green
                 WE_EXTENDED_GREEN = 4'b1011, // West-East extended green
                 WE_YELLOW         = 4'b1100; // West-East yellow

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= ALL_RED;              // Initialize to all red on reset
        end else begin
            state <= next_state;           // Transition to the next state
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            // Initial state: All red, evaluate sensors
            ALL_RED:
                if (NS_S5) next_state = NS_EXTENDED_GREEN;
                else if (SN_S5) next_state = SN_EXTENDED_GREEN;
                else if (EW_S5) next_state = EW_EXTENDED_GREEN;
                else if (WE_S5) next_state = WE_EXTENDED_GREEN;
                else if (NS_S1) next_state = NS_PRIMARY_GREEN;
                else if (SN_S1) next_state = SN_PRIMARY_GREEN;
                else if (EW_S1) next_state = EW_PRIMARY_GREEN;
                else if (WE_S1) next_state = WE_PRIMARY_GREEN;
                else next_state = ALL_RED;

            // Transition logic for yellow and other states
            NS_YELLOW:
                if (SN_S5) next_state = SN_EXTENDED_GREEN;
                else if (EW_S5) next_state = EW_EXTENDED_GREEN;
                else if (WE_S5) next_state = WE_EXTENDED_GREEN;
                else next_state = ALL_RED;

            SN_YELLOW:
                if (EW_S5) next_state = EW_EXTENDED_GREEN;
                else if (WE_S5) next_state = WE_EXTENDED_GREEN;
                else if (NS_S5) next_state = NS_EXTENDED_GREEN;
                else next_state = ALL_RED;

            // Handle greens transitioning to yellow
            NS_PRIMARY_GREEN: next_state = NS_YELLOW;
            NS_EXTENDED_GREEN: next_state = NS_YELLOW;
            SN_PRIMARY_GREEN: next_state = SN_YELLOW;
            SN_EXTENDED_GREEN: next_state = SN_YELLOW;
            EW_PRIMARY_GREEN: next_state = EW_YELLOW;
            EW_EXTENDED_GREEN: next_state = EW_YELLOW;
            WE_PRIMARY_GREEN: next_state = WE_YELLOW;
            WE_EXTENDED_GREEN: next_state = WE_YELLOW;

            default: next_state = ALL_RED; // Safe fallback state
        endcase
    end

    // FSM Output Logic
    always @(*) begin
        case (state)
            NS_PRIMARY_GREEN, NS_EXTENDED_GREEN: light_signal = 4'b0001; // North-South green
            NS_YELLOW: light_signal = 4'b0010;                           // North-South yellow

            SN_PRIMARY_GREEN, SN_EXTENDED_GREEN: light_signal = 4'b0011; // South-North green
            SN_YELLOW: light_signal = 4'b0100;                           // South-North yellow

            EW_PRIMARY_GREEN, EW_EXTENDED_GREEN: light_signal = 4'b0101; // East-West green
            EW_YELLOW: light_signal = 4'b0110;                           // East-West yellow

            WE_PRIMARY_GREEN, WE_EXTENDED_GREEN: light_signal = 4'b0111; // West-East green
            WE_YELLOW: light_signal = 4'b1000;                           // West-East yellow

            ALL_RED: light_signal = 4'b0000;                             // All directions red

            default: light_signal = 4'b0000;                             // Safe fallback output
        endcase
    end

endmodule
