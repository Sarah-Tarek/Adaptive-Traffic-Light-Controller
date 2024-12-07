module traffic_light_fsm (
    input wire clk,                  // System clock
    input wire rst,                  // Reset signal
    input wire NS1_S1,             // Start sensors for all 4 lanes
    input wire NS2_S1,
    input wire EW1_S1,
    input wire EW2_S1,
    input wire NS1_S5,             // Congestion sensors for all 4 lanes
    input wire NS2_S5,    
    input wire EW1_S5,    
    input wire EW2_S5,    
    output reg [3:0] state,          // FSM state
    output reg [3:0] next_state,     // Next FSM state
    output reg [3:0] light_signal    // Traffic light control signal
);

    // State encoding
    localparam NS1_RED      = 4'b0000, // Gray Code: 0
               NS1_GREEN    = 4'b0001, // Gray Code: 1
               NS1_GREEN_2  = 4'b0011, // Gray Code: 3
               NS1_YELLOW   = 4'b0010, // Gray Code: 2
               NS2_RED      = 4'b0110, // Gray Code: 6
               NS2_GREEN    = 4'b0111, // Gray Code: 7
               NS2_GREEN_2  = 4'b0101, // Gray Code: 5
               NS2_YELLOW   = 4'b0100, // Gray Code: 4
               EW1_RED      = 4'b1100, // Gray Code: 12
               EW1_GREEN    = 4'b1101, // Gray Code: 13
               EW1_GREEN_2  = 4'b1111, // Gray Code: 15
               EW1_YELLOW   = 4'b1110, // Gray Code: 14
               EW2_RED      = 4'b1010, // Gray Code: 10
               EW2_GREEN    = 4'b1011, // Gray Code: 11
               EW2_GREEN_2  = 4'b1001, // Gray Code: 9
               EW2_YELLOW   = 4'b1000; // Gray Code: 8

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= NS1_RED;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
          NS1_RED:     next_state = (NS1_S1 == 1'b1) ? NS1_GREEN : NS2_RED;
          NS1_GREEN:   next_state = (NS1_S5 == 1'b1) ? NS1_GREEN_2 : NS1_YELLOW;
            NS1_GREEN_2: next_state = NS1_YELLOW;
            NS1_YELLOW:  next_state = NS2_RED;

            NS2_RED:     next_state = (NS2_S1 == 1'b1) ? NS2_GREEN : EW1_RED;
            NS2_GREEN:   next_state = (NS2_S5 == 1'b1) ? NS2_GREEN_2 : NS2_YELLOW;
            NS2_GREEN_2: next_state = NS2_YELLOW;
            NS2_YELLOW:  next_state = EW1_RED;

            EW1_RED:     next_state = (EW1_S1 == 1'b1) ? EW1_GREEN : EW2_RED;
            EW1_GREEN:   next_state = (EW1_S5 == 1'b1) ? EW1_GREEN_2 : EW1_YELLOW;
            EW1_GREEN_2: next_state = EW1_YELLOW;
            EW1_YELLOW:  next_state = EW2_RED;

            EW2_RED:     next_state = (EW2_S1 == 1'b1) ? EW2_GREEN : NS1_RED;
            EW2_GREEN:   next_state = (EW2_S5 == 1'b1) ? EW2_GREEN_2 : EW2_YELLOW;
            EW2_GREEN_2: next_state = EW2_YELLOW;
            EW2_YELLOW:  next_state = NS1_RED;

            default:    next_state = NS1_RED;  // Safe default state
        endcase
    end

    // FSM Output Logic (Based on Current State)
    always @(*) begin
        case (state)
            // North-South Lane 1
            NS1_GREEN:    light_signal = 4'b0001;  // NS1: GREEN, Others: RED
            NS1_GREEN_2:  light_signal = 4'b0001;  // NS1: GREEN, Others: RED
            NS1_YELLOW:   light_signal = 4'b0010;  // NS1: YELLOW, Others: RED

            // North-South Lane 2
            NS2_GREEN:    light_signal = 4'b0011;  // NS2: GREEN, Others: RED
            NS2_GREEN_2:  light_signal = 4'b0011;  // NS2: GREEN, Others: RED
            NS2_YELLOW:   light_signal = 4'b0100;  // NS2: YELLOW, Others: RED

            // East-West Lane 1
            EW1_GREEN:    light_signal = 4'b0101;  // EW1: GREEN, Others: RED
            EW1_GREEN_2:  light_signal = 4'b0101;  // EW1: GREEN, Others: RED
            EW1_YELLOW:   light_signal = 4'b0110;  // EW1: YELLOW, Others: RED

            // East-West Lane 2
            EW2_GREEN:    light_signal = 4'b0111;  // EW2: GREEN, Others: RED
            EW2_GREEN_2:  light_signal = 4'b0111;  // EW2: GREEN, Others: RED
            EW2_YELLOW:   light_signal = 4'b1000;  // EW2: YELLOW, Others: RED

            default:    light_signal = 4'b0000;  // All RED (Safe state)
        endcase
end


endmodule