module timer (
    input wire clk,            // System clock
    input wire rst,            // Reset signal
    input wire start,          // Start the timer
    input wire extend,         // Extend the green light duration
    input wire yellow_mode,    // Signal to indicate yellow light mode
    output reg expired         // Timer expired signal
);

    parameter DEFAULT_TIME = 20;  // Default green light duration
    parameter EXTENDED_TIME = 30; // Extended green light duration
    parameter YELLOW_TIME = 5;    // Yellow light duration

    reg [5:0] counter; // Timer counter (6 bits for up to 63 counts)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            expired <= 0;
        end else if (start) begin
            if (yellow_mode) begin
                // Handle yellow light duration
                if (counter == YELLOW_TIME) begin
                    expired <= 1;
                    counter <= 0; // Reset counter after expiration
                end else begin
                    counter <= counter + 1;
                    expired <= 0;
                end
            end else begin
                // Handle green or extended green light durations
                if (counter == (extend ? EXTENDED_TIME : DEFAULT_TIME)) begin
                    expired <= 1;
                    counter <= 0; // Reset counter after expiration
                end else begin
                    counter <= counter + 1;
                    expired <= 0;
                end
            end
        end else begin
            counter <= 0; // Reset counter when timer is not started
            expired <= 0;
        end
    end
endmodule
