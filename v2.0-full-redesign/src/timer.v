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

    reg [5:0] counter; // Countdown timer (6-bit for up to 63 clock cycles)

    // Set counter value based on state
    always @(state) begin
        case (state)
            4'b0000: counter = RED_TIME;                                       // All red
            4'b0001, 4'b0100, 4'b0111, 4'b1010: counter = PRIMARY_GREEN_TIME;  // Primary green
            4'b0010, 4'b0101, 4'b1000, 4'b1011: counter = EXTENDED_GREEN_TIME; // Extended green
            4'b0011, 4'b0110, 4'b1001, 4'b1100: counter = YELLOW_TIME;         // Yellow
            default: counter = RED_TIME;                                       // Default to all-red
        endcase
    end

    // Timer countdown logic
    always @(posedge clk) begin
        expired <= 0;               // Clear expired signal
        if (counter == 1) begin
            expired <= 1;           // Signal timer expiration
        end else begin
            counter <= counter - 1; // Decrement counter
        end
    end

    // Clear expired signal on falling edge of the clock
    always @(negedge clk) expired <= 0;

endmodule
