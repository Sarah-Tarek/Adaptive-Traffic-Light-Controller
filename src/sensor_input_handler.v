module sensor_input_handler (
    input wire clk,
    input wire rst,
    input wire [7:0] raw_sensor,       // 8 raw sensor inputs
    output reg [7:0] debounced_sensor  // 8 debounced outputs
);

    parameter DEBOUNCE_TIME = 4;  // Number of clock cycles for stable input

    reg [1:0] sync[7:0];          // Synchronizers for each sensor
    reg [2:0] counter[7:0];       // Counters for each sensor

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) begin
                sync[i] <= 2'b00;
                counter[i] <= 0;
                debounced_sensor[i] <= 0;
            end
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                // Synchronize raw input
                sync[i] <= {sync[i][0], raw_sensor[i]};
                
                // Debounce logic
                if (sync[i][1] == sync[i][0]) begin
                    if (counter[i] < DEBOUNCE_TIME)
                        counter[i] <= counter[i] + 1;
                    else
                        debounced_sensor[i] <= sync[i][1];  // Update after stable period
                end else begin
                    counter[i] <= 0;  // Reset counter on input change
                end
            end
        end
    end
endmodule
