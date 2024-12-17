module timer (
    input wire clk, rst,            // System clock and reset signal
    input wire [3:0] state,         // Current FSM state
    output reg expired              // Timer expired signal
);

    // Define time durations for different states
    parameter RED_TIME = 1;             // Duration for all-red state
    parameter PRIMARY_GREEN_TIME = 20;  // Default green light duration
    parameter EXTENDED_GREEN_TIME = 30; // Green light duration with congestion
    parameter YELLOW_TIME = 5;          // Yellow light duration

    reg [5:0] counter;        // Countdown timer (6-bit for up to 63 clock cycles)
    reg [5:0] load_value;     // Value to load into counter
    reg [3:0] prev_state;     // Previous state for detecting state changes

    // Determine counter value based on state
    always @(*) begin
        case (state)
            4'b0000: load_value = RED_TIME;                                      // All red
            4'b0001, 4'b0100, 4'b0111, 4'b1010: load_value = PRIMARY_GREEN_TIME; // Primary green
            4'b0010, 4'b0101, 4'b1000, 4'b1011: load_value = EXTENDED_GREEN_TIME;// Extended green
            4'b0011, 4'b0110, 4'b1001, 4'b1100: load_value = YELLOW_TIME;        // Yellow
            default: load_value = RED_TIME;                                      // Default to all-red
        endcase
    end

    // Timer countdown logic with state change detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= load_value; // Reset the counter to the load value
            expired <= 0;
            prev_state <= state;   // Initialize previous state
        end else begin
            if (state != prev_state) begin
                // On state change, reload the counter
                counter <= load_value;
                expired <= 0;
                prev_state <= state; // Update previous state
            end else if (counter == 0) begin
                expired <= 1;           // Signal timer expiration
                counter <= load_value;  // Reload the counter
            end else begin
                expired <= 0;           // Clear expired signal
                counter <= counter - 1; // Decrement counter
            end
        end
    end

endmodule
