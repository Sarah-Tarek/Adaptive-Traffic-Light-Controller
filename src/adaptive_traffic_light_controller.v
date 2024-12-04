module adaptive_traffic_light_controller (
    input wire clk,                      // System clock
    input wire rst,                      // Reset signal
    input wire [3:0] raw_s1,             // Raw S1 sensors for each lane
    input wire [3:0] raw_s5,             // Raw S5 congestion sensors
    output wire [3:0] traffic_lights     // Traffic light outputs
);

    // Internal signals
    wire [3:0] debounced_s1;             // Debounced S1 signals
    wire [3:0] debounced_s5;             // Debounced S5 signals
    wire [3:0] fsm_light_signal;         // FSM-generated traffic light signal
    wire expired;                        // Timer expired signal
    reg start_timer;                     // Start timer control signal
    reg extend_timer;                    // Extend timer control signal

    // Instantiate sensor input handler for debouncing
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : sensor_debounce
            sensor_input_handler s1_handler (
                .clk(clk),
                .rst(rst),
                .raw_sensor(raw_s1[i]),
                .debounced_sensor(debounced_s1[i])
            );

            sensor_input_handler s5_handler (
                .clk(clk),
                .rst(rst),
                .raw_sensor(raw_s5[i]),
                .debounced_sensor(debounced_s5[i])
            );
        end
    endgenerate

    // Instantiate the FSM
    traffic_light_fsm fsm (
        .clk(clk),
        .rst(rst),
        .S1(debounced_s1[1:0]),          // Use two bits for S1 sensors
        .S5(debounced_s5[1:0]),          // Use two bits for S5 congestion sensors
        .state(),
        .next_state(),
        .light_signal(fsm_light_signal)
    );

    // Instantiate the timer
    timer traffic_timer (
        .clk(clk),
        .rst(rst),
        .start(start_timer),
        .extend(extend_timer),
        .expired(expired)
    );

    // Instantiate the traffic light driver
    traffic_light_driver driver (
        .clk(clk),
        .rst(rst),
        .light_signal(fsm_light_signal),
        .traffic_lights(traffic_lights)
    );

    // Timer control logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_timer <= 0;
            extend_timer <= 0;
        end else begin
            // Start the timer when FSM transitions to a GREEN state
            start_timer <= (fsm_light_signal == 4'b0010);  // GREEN signal
            // Extend timer if congestion is detected in the GREEN state
            extend_timer <= (fsm_light_signal == 4'b0010) && (|debounced_s5); // Any S5 signal active
        end
    end

endmodule
