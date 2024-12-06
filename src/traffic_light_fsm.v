module traffic_light_fsm (
    input wire clk,                  // System clock
    input wire rst,                  // Reset signal
    input wire S1_NS1,               // Start sensor for North-South Lane 1
    input wire S1_NS2,               // Start sensor for North-South Lane 2
    input wire S1_EW1,               // Start sensor for East-West Lane 1
    input wire S1_EW2,               // Start sensor for East-West Lane 2
    input wire S5_NS1,               // Congestion sensor for North-South Lane 1
    input wire S5_NS2,               // Congestion sensor for North-South Lane 2
    input wire S5_EW1,               // Congestion sensor for East-West Lane 1
    input wire S5_EW2,               // Congestion sensor for East-West Lane 2
    output reg [3:0] state,          // FSM state
    output reg [3:0] next_state,     // Next FSM state
    output reg [3:0] light_signal    // Traffic light control signal
);

    // State encoding (Gray Code)
    localparam NS1_RED    = 4'b0000,
               NS1_GREEN  = 4'b0001,
               NS1_YELLOW = 4'b0011,
               NS2_RED    = 4'b0010,
               NS2_GREEN  = 4'b0110,
               NS2_YELLOW = 4'b0111,
               EW1_RED    = 4'b0101,
               EW1_GREEN  = 4'b0100,
               EW1_YELLOW = 4'b1100,
               EW2_RED    = 4'b1101,
               EW2_GREEN  = 4'b1111,
               EW2_YELLOW = 4'b1110;

    reg congestion_handled_NS1;
    reg congestion_handled_NS2;
    reg congestion_handled_EW1;
    reg congestion_handled_EW2;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= NS1_RED;
            congestion_handled_NS1 <= 0;
            congestion_handled_NS2 <= 0;
            congestion_handled_EW1 <= 0;
            congestion_handled_EW2 <= 0;
        end else begin
            state <= next_state;

            // Reset congestion flags when transitioning to a new lane
            case (next_state)
                NS1_RED, NS1_GREEN, NS1_YELLOW: congestion_handled_NS1 <= 0;
                NS2_RED, NS2_GREEN, NS2_YELLOW: congestion_handled_NS2 <= 0;
                EW1_RED, EW1_GREEN, EW1_YELLOW: congestion_handled_EW1 <= 0;
                EW2_RED, EW2_GREEN, EW2_YELLOW: congestion_handled_EW2 <= 0;
                default: begin
                    congestion_handled_NS1 <= 0;
                    congestion_handled_NS2 <= 0;
                    congestion_handled_EW1 <= 0;
                    congestion_handled_EW2 <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            // North-South Lane 1
            NS1_RED:    next_state = (S1_NS1 == 1'b1) ? NS1_GREEN : NS2_RED;
            NS1_GREEN: begin
                if (S5_NS1 == 1'b1 && congestion_handled_NS1 == 1'b0) begin
                    next_state = NS1_GREEN; // Extend green light
                    congestion_handled_NS1 = 1'b1; // Set congestion flag
                end else begin
                    next_state = NS1_YELLOW; // Transition to yellow
                end
            end
            NS1_YELLOW: next_state = NS2_RED;

            // North-South Lane 2
            NS2_RED:    next_state = (S1_NS2 == 1'b1) ? NS2_GREEN : EW1_RED;
            NS2_GREEN: begin
                if (S5_NS2 == 1'b1 && congestion_handled_NS2 == 1'b0) begin
                    next_state = NS2_GREEN; // Extend green light
                    congestion_handled_NS2 = 1'b1; // Set congestion flag
                end else begin
                    next_state = NS2_YELLOW; // Transition to yellow
                end
            end
            NS2_YELLOW: next_state = EW1_RED;

            // East-West Lane 1
            EW1_RED:    next_state = (S1_EW1 == 1'b1) ? EW1_GREEN : EW2_RED;
            EW1_GREEN: begin
                if (S5_EW1 == 1'b1 && congestion_handled_EW1 == 1'b0) begin
                    next_state = EW1_GREEN; // Extend green light
                    congestion_handled_EW1 = 1'b1; // Set congestion flag
                end else begin
                    next_state = EW1_YELLOW; // Transition to yellow
                end
            end
            EW1_YELLOW: next_state = EW2_RED;

            // East-West Lane 2
            EW2_RED:    next_state = (S1_EW2 == 1'b1) ? EW2_GREEN : NS1_RED;
            EW2_GREEN: begin
                if (S5_EW2 == 1'b1 && congestion_handled_EW2 == 1'b0) begin
                    next_state = EW2_GREEN; // Extend green light
                    congestion_handled_EW2 = 1'b1; // Set congestion flag
                end else begin
                    next_state = EW2_YELLOW; // Transition to yellow
                end
            end
            EW2_YELLOW: next_state = NS1_RED;

            default:    next_state = NS1_RED; // Safe default state
        endcase
    end

    // FSM Output Logic (Based on Current State)
    always @(*) begin
        case (state)
            NS1_GREEN:  light_signal = 4'b0001;  // NS1: GREEN, Others: RED
            NS1_YELLOW: light_signal = 4'b0010;  // NS1: YELLOW, Others: RED

            NS2_GREEN:  light_signal = 4'b0011;  // NS2: GREEN, Others: RED
            NS2_YELLOW: light_signal = 4'b0100;  // NS2: YELLOW, Others: RED

            EW1_GREEN:  light_signal = 4'b0101;  // EW1: GREEN, Others: RED
            EW1_YELLOW: light_signal = 4'b0110;  // EW1: YELLOW, Others: RED

            EW2_GREEN:  light_signal = 4'b0111;  // EW2: GREEN, Others: RED
            EW2_YELLOW: light_signal = 4'b1000;  // EW2: YELLOW, Others: RED

            default:    light_signal = 4'b0000;  // All RED (Safe state)
        endcase
    end

endmodule
