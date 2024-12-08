module adaptive_traffic_light_controller (
    input wire clk,                      // System clock
    input wire rst,                      // Reset signal
    input wire raw_S1_NS1,               // Raw S1 sensor for North-South Lane 1
    input wire raw_S1_NS2,               // Raw S1 sensor for North-South Lane 2
    input wire raw_S1_EW1,               // Raw S1 sensor for East-West Lane 1
    input wire raw_S1_EW2,               // Raw S1 sensor for East-West Lane 2
    input wire raw_S5_NS1,               // Raw S5 congestion sensor for North-South Lane 1
    input wire raw_S5_NS2,               // Raw S5 congestion sensor for North-South Lane 2
    input wire raw_S5_EW1,               // Raw S5 congestion sensor for East-West Lane 1
    input wire raw_S5_EW2,               // Raw S5 congestion sensor for East-West Lane 2
    output wire [3:0] NS1_light,         // Traffic light signals for North-South Lane 1
    output wire [3:0] NS2_light,         // Traffic light signals for North-South Lane 2
    output wire [3:0] EW1_light,         // Traffic light signals for East-West Lane 1
    output wire [3:0] EW2_light          // Traffic light signals for East-West Lane 2
);

    // Internal signals
    wire debounced_S1_NS1, debounced_S1_NS2, debounced_S1_EW1, debounced_S1_EW2;
    wire debounced_S5_NS1, debounced_S5_NS2, debounced_S5_EW1, debounced_S5_EW2;
    wire [3:0] current_state;           // FSM current state
    wire timer_expired;                 // Timer expired signal
    wire yellow_mode;                   // Indicates yellow light timing
    wire start_timer;                   // Timer start signal
    wire extend_timer;                  // Timer extend signal

    // Instantiate sensor input handlers for debouncing
    sensor_input_handler s1_ns1_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S1_NS1),
        .debounced_sensor(debounced_S1_NS1)
    );

    sensor_input_handler s1_ns2_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S1_NS2),
        .debounced_sensor(debounced_S1_NS2)
    );

    sensor_input_handler s1_ew1_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S1_EW1),
        .debounced_sensor(debounced_S1_EW1)
    );

    sensor_input_handler s1_ew2_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S1_EW2),
        .debounced_sensor(debounced_S1_EW2)
    );

    sensor_input_handler s5_ns1_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S5_NS1),
        .debounced_sensor(debounced_S5_NS1)
    );

    sensor_input_handler s5_ns2_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S5_NS2),
        .debounced_sensor(debounced_S5_NS2)
    );

    sensor_input_handler s5_ew1_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S5_EW1),
        .debounced_sensor(debounced_S5_EW1)
    );

    sensor_input_handler s5_ew2_handler (
        .clk(clk),
        .rst(rst),
        .raw_sensor(raw_S5_EW2),
        .debounced_sensor(debounced_S5_EW2)
    );

    // Instantiate the FSM
    traffic_light_fsm fsm (
        .clk(clk),
        .rst(rst),
        .S1_NS1(debounced_S1_NS1),
        .S1_NS2(debounced_S1_NS2),
        .S1_EW1(debounced_S1_EW1),
        .S1_EW2(debounced_S1_EW2),
        .S5_NS1(debounced_S5_NS1),
        .S5_NS2(debounced_S5_NS2),
        .S5_EW1(debounced_S5_EW1),
        .S5_EW2(debounced_S5_EW2),
        .state(current_state)
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
        .light_signal(current_state),    // FSM output signal
        .NS1_light(NS1_light),           // Traffic light output for NS1
        .NS2_light(NS2_light),           // Traffic light output for NS2
        .EW1_light(EW1_light),           // Traffic light output for EW1
        .EW2_light(EW2_light)            // Traffic light output for EW2
    );

    // Timer control logic
    assign yellow_mode = (current_state == 4'b0010) ||  // NS1_YELLOW
                         (current_state == 4'b0100) ||  // NS2_YELLOW
                         (current_state == 4'b1110) ||  // EW1_YELLOW
                         (current_state == 4'b1000);    // EW2_YELLOW

    assign start_timer = (current_state != 4'b0000);    // Start timer for any non-RED state
    assign extend_timer = (current_state == 4'b0001 && debounced_S5_NS1) ||  // Extend for NS1_PRIMARY_GREEN
                          (current_state == 4'b0111 && debounced_S5_NS2) ||  // Extend for NS2_PRIMARY_GREEN
                          (current_state == 4'b1101 && debounced_S5_EW1) ||  // Extend for EW1_PRIMARY_GREEN
                          (current_state == 4'b1011 && debounced_S5_EW2);    // Extend for EW2_PRIMARY_GREEN

endmodule
