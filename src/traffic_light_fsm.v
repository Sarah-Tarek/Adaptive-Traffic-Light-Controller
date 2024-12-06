module traffic_light_fsm (
    input wire clk,                 // System clock
    input wire rst,                 // Reset signal
    input wire [1:0] S1,            // Start of lane sensors (2 bits for simplicity)
    input wire [1:0] S5,            // Congestion sensors (2 bits for simplicity)
    output reg [3:0] light_signal   // FSM output for traffic light control
);

    // State encoding
    localparam NS1_GREEN  = 4'b0001,  // North-South Lane 1: GREEN
               NS1_YELLOW = 4'b0010,  // North-South Lane 1: YELLOW
               NS2_GREEN  = 4'b0011,  // North-South Lane 2: GREEN
               NS2_YELLOW = 4'b0100,  // North-South Lane 2: YELLOW
               EW1_GREEN  = 4'b0101,  // East-West Lane 1: GREEN
               EW1_YELLOW = 4'b0110,  // East-West Lane 1: YELLOW
               EW2_GREEN  = 4'b0111,  // East-West Lane 2: GREEN
               EW2_YELLOW = 4'b1000;  // East-West Lane 2: YELLOW

    // Internal state and next state signals
    reg [3:0] state, next_state;

    // State transition logic (sequential)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= NS1_GREEN;  // Default state on reset
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            // North-South Lane 1
            NS1_GREEN: begin
                if (S1[0] == 1'b0)  // No cars at NS1, skip to NS2
                    next_state = NS2_GREEN;
                else if (S5[0] == 1'b1)  // Extend GREEN if congestion detected
                    next_state = NS1_GREEN;
                else
                    next_state = NS1_YELLOW;
            end
            NS1_YELLOW: begin
                if (S1[1] == 1'b0)  // No cars at NS2, skip to EW1
                    next_state = EW1_GREEN;
                else
                    next_state = NS2_GREEN;  // Transition to NS2 GREEN
            end

            // North-South Lane 2
            NS2_GREEN: begin
                if (S1[1] == 1'b0)  // No cars at NS2, skip to EW1
                    next_state = EW1_GREEN;
                else if (S5[1] == 1'b1)  // Extend GREEN if congestion detected
                    next_state = NS2_GREEN;
                else
                    next_state = NS2_YELLOW;
            end
            NS2_YELLOW: begin
                next_state = EW1_GREEN;  // Transition to EW1 GREEN
            end

            // East-West Lane 1
            EW1_GREEN: begin
                if (S1[0] == 1'b0)  // No cars at EW1, skip to EW2
                    next_state = EW2_GREEN;
                else if (S5[0] == 1'b1)  // Extend GREEN if congestion detected
                    next_state = EW1_GREEN;
                else
                    next_state = EW1_YELLOW;
            end
            EW1_YELLOW: begin
                next_state = EW2_GREEN;  // Transition to EW2 GREEN
            end

            // East-West Lane 2
            EW2_GREEN: begin
                if (S1[1] == 1'b0)  // No cars at EW2, skip to NS1
                    next_state = NS1_GREEN;
                else if (S5[1] == 1'b1)  // Extend GREEN if congestion detected
                    next_state = EW2_GREEN;
                else
                    next_state = EW2_YELLOW;
            end
            EW2_YELLOW: begin
                next_state = NS1_GREEN;  // Loop back to NS1 GREEN
            end

            // Default case (should never occur)
            default: begin
                next_state = NS1_GREEN;
            end
        endcase
    end

    // Output logic (based on current state)
    always @(*) begin
        case (state)
            NS1_GREEN:  light_signal = NS1_GREEN;
            NS1_YELLOW: light_signal = NS1_YELLOW;
            NS2_GREEN:  light_signal = NS2_GREEN;
            NS2_YELLOW: light_signal = NS2_YELLOW;
            EW1_GREEN:  light_signal = EW1_GREEN;
            EW1_YELLOW: light_signal = EW1_YELLOW;
            EW2_GREEN:  light_signal = EW2_GREEN;
            EW2_YELLOW: light_signal = EW2_YELLOW;
            default:    light_signal = NS1_GREEN;  // Default to NS1_GREEN
        endcase
    end

endmodule
