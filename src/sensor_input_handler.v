module sensor_input_handler (
    input wire clk,
    input wire rst,
    input wire raw_sensor,
    output reg debounced_sensor
);

    parameter DEBOUNCE_TIME = 4;  // Number of clock cycles for stable input

    reg [1:0] sync;               // Synchronizer
    reg [2:0] counter;            // Counter for stable time

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync <= 2'b00;
            counter <= 0;
            debounced_sensor <= 0;
        end else begin
            // Synchronize the raw input
            sync <= {sync[0], raw_sensor};

            // Debounce logic
            if (sync[1] == sync[0]) begin
                if (counter < DEBOUNCE_TIME)
                    counter <= counter + 1;
                else
                    debounced_sensor <= sync[1];  // Update only after stable period
            end else begin
                counter <= 0;  // Reset counter on input change
            end
        end
    end
endmodule
