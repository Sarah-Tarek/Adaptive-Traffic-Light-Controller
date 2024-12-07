module traffic_light_fsm (
    input wire clk,                  // System clock
    input wire rst,                  // Reset signal
    input wire NS1_S1,               // Start sensors for North-South Lane 1
    input wire NS2_S1,               // Start sensors for North-South Lane 2
    input wire EW1_S1,               // Start sensors for East-West Lane 1
    input wire EW2_S1,               // Start sensors for East-West Lane 2
    input wire NS1_S5,               // Congestion sensors for North-South Lane 1
    input wire NS2_S5,               // Congestion sensors for North-South Lane 2
    input wire EW1_S5,               // Congestion sensors for East-West Lane 1
    input wire EW2_S5,               // Congestion sensors for East-West Lane 2
    output reg [3:0] state,          // FSM current state
    output reg [3:0] next_state,     // FSM next state
    output reg [3:0] light_signal    // Traffic light control signal
);

    // State encoding
    localparam NS1_RED            = 4'b0000, // RED for NS1
               NS1_PRIMARY_GREEN  = 4'b0001, // Primary GREEN for NS1
               NS1_EXTENDED_GREEN = 4'b0011, // Extended GREEN for NS1
               NS1_YELLOW         = 4'b0010, // YELLOW for NS1

               NS2_RED            = 4'b0110, // RED for NS2
               NS2_PRIMARY_GREEN  = 4'b0111, // Primary GREEN for NS2
               NS2_EXTENDED_GREEN = 4'b0101, // Extended GREEN for NS2
               NS2_YELLOW         = 4'b0100, // YELLOW for NS2

               EW1_RED            = 4'b1100, // RED for EW1
               EW1_PRIMARY_GREEN  = 4'b1101, // Primary GREEN for EW1
               EW1_EXTENDED_GREEN = 4'b1111, // Extended GREEN for EW1
               EW1_YELLOW         = 4'b1110, // YELLOW for EW1

               EW2_RED            = 4'b1010, // RED for EW2
               EW2_PRIMARY_GREEN  = 4'b1011, // Primary GREEN for EW2
               EW2_EXTENDED_GREEN = 4'b1001, // Extended GREEN for EW2
               EW2_YELLOW         = 4'b1000; // YELLOW for EW2

    // Sequential logic for state transitions
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= NS1_RED;     // Reset to initial state
        end else begin
            state <= next_state;  // Transition to the next state
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            // North-South Lane 1
            NS1_RED:            next_state = (NS1_S1) ? NS1_PRIMARY_GREEN : NS2_RED;
            NS1_PRIMARY_GREEN:  next_state = (NS1_S5) ? NS1_EXTENDED_GREEN : NS1_YELLOW;
            NS1_EXTENDED_GREEN: next_state = NS1_YELLOW;
            NS1_YELLOW:         next_state = NS2_RED;

            // North-South Lane 2
            NS2_RED:            next_state = (NS2_S1) ? NS2_PRIMARY_GREEN : EW1_RED;
            NS2_PRIMARY_GREEN:  next_state = (NS2_S5) ? NS2_EXTENDED_GREEN : NS2_YELLOW;
            NS2_EXTENDED_GREEN: next_state = NS2_YELLOW;
            NS2_YELLOW:         next_state = EW1_RED;

            // East-West Lane 1
            EW1_RED:            next_state = (EW1_S1) ? EW1_PRIMARY_GREEN : EW2_RED;
            EW1_PRIMARY_GREEN:  next_state = (EW1_S5) ? EW1_EXTENDED_GREEN : EW1_YELLOW;
            EW1_EXTENDED_GREEN: next_state = EW1_YELLOW;
            EW1_YELLOW:         next_state = EW2_RED;

            // East-West Lane 2
            EW2_RED:            next_state = (EW2_S1) ? EW2_PRIMARY_GREEN : NS1_RED;
            EW2_PRIMARY_GREEN:  next_state = (EW2_S5) ? EW2_EXTENDED_GREEN : EW2_YELLOW;
            EW2_EXTENDED_GREEN: next_state = EW2_YELLOW;
            EW2_YELLOW:         next_state = NS1_RED;

            // Default safe state
            default:            next_state = NS1_RED;
        endcase
    end

    // FSM Output Logic
    always @(*) begin
        case (state)
            // North-South Lane 1
            NS1_RED:            light_signal = 4'b0000;  // NS1: RED, Others: OFF
            NS1_PRIMARY_GREEN:  light_signal = 4'b0001;  // NS1: GREEN, Others: RED
            NS1_EXTENDED_GREEN: light_signal = 4'b0001;  // NS1: GREEN, Others: RED
            NS1_YELLOW:         light_signal = 4'b0010;  // NS1: YELLOW, Others: RED

            // North-South Lane 2
            NS2_RED:            light_signal = 4'b0000;  // NS2: RED, Others: OFF
            NS2_PRIMARY_GREEN:  light_signal = 4'b0011;  // NS2: GREEN, Others: RED
            NS2_EXTENDED_GREEN: light_signal = 4'b0011;  // NS2: GREEN, Others: RED
            NS2_YELLOW:         light_signal = 4'b0100;  // NS2: YELLOW, Others: RED

            // East-West Lane 1
            EW1_RED:            light_signal = 4'b0000;  // EW1: RED, Others: OFF
            EW1_PRIMARY_GREEN:  light_signal = 4'b0101;  // EW1: GREEN, Others: RED
            EW1_EXTENDED_GREEN: light_signal = 4'b0101;  // EW1: GREEN, Others: RED
            EW1_YELLOW:         light_signal = 4'b0110;  // EW1: YELLOW, Others: RED

            // East-West Lane 2
            EW2_RED:            light_signal = 4'b0000;  // EW2: RED, Others: OFF
            EW2_PRIMARY_GREEN:  light_signal = 4'b0111;  // EW2: GREEN, Others: RED
            EW2_EXTENDED_GREEN: light_signal = 4'b0111;  // EW2: GREEN, Others: RED
            EW2_YELLOW:         light_signal = 4'b1000;  // EW2: YELLOW, Others: RED

            // Default all RED
            default:            light_signal = 4'b0000;  // All RED (Safe state)
        endcase
    end

endmodule
