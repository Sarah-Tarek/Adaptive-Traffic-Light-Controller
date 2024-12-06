module adaptive_traffic_light_controller (
    input wire clk,                      // System clock
    input wire rst,                      // Reset signal
    input wire [3:0] raw_s1,             // Raw S1 sensors for each lane
    input wire [3:0] raw_s5,             // Raw S5 congestion sensors
    output wire [3:0] NS1_light,         // Traffic light signals for North-South Lane 1
    output wire [3:0] NS2_light,         // Traffic light signals for North-South Lane 2
    output wire [3:0] EW1_light,         // Traffic light signals for East-West Lane 1
    output wire [3:0] EW2_light          // Traffic light signals for East-West Lane 2
);

    // Internal signals
    wire [3:0] debounced_s1;             // Debounced S1 signals
    wire [3:0] debounced_s5;             // Debounced S5 signals
    wire [3:0] light_signal;             // FSM output for traffic light control
    wire timer_expired;                  // Timer expired signal
    wire yellow_mode;                    // Timer mode for yellow light
    wire start_timer;                    // Timer start signal
    wire extend_timer;                   // Timer extend signal

    // Instantiate sensor input handlers for debouncing
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
        .S1(debounced_s1),               // Use all debounced S1 sensors
        .S5(debounced_s5),               // Use all debounced S5 sensors
        .light_signal(light_signal)      // Output: current FSM state
    );

    // Instantiate the timer
    timer traffic_timer (
        .clk(clk),
        .rst(rst),
        .start(start_timer),             // Signal to start the timer
        .extend(extend_timer),           // Signal to extend the timer
        .yellow_mode(yellow_mode),       // Signal for yellow light mode
        .expired(timer_expired)          // Output: timer expired signal
    );

    // Instantiate the traffic light driver
    traffic_light_driver driver (
        .clk(clk),
        .rst(rst),
        .light_signal(light_signal),     // FSM output signal
        .NS1_light(NS1_light),           // Traffic light output for NS1
        .NS2_light(NS2_light),           // Traffic light output for NS2
        .EW1_light(EW1_light),           // Traffic light output for EW1
        .EW2_light(EW2_light)            // Traffic light output for EW2
    );

    // Timer control logic
    assign yellow_mode = (light_signal == 4'b0010) ||  // NS1_YELLOW
                         (light_signal == 4'b0100) ||  // NS2_YELLOW
                         (light_signal == 4'b0110) ||  // EW1_YELLOW
                         (light_signal == 4'b1000);    // EW2_YELLOW

    assign start_timer = (light_signal != 4'b0000);    // Start timer for any non-RED state
    assign extend_timer = (light_signal == 4'b0001 && debounced_s5[0]) ||  // Extend for NS1_GREEN
                          (light_signal == 4'b0011 && debounced_s5[1]) ||  // Extend for NS2_GREEN
                          (light_signal == 4'b0101 && debounced_s5[2]) ||  // Extend for EW1_GREEN
                          (light_signal == 4'b0111 && debounced_s5[3]);    // Extend for EW2_GREEN

endmodule
