module adaptive_traffic_light_controller (
    input wire clk,                      // System clock
    input wire rst,                      // Reset signal
    input wire S1_NS,                    // Start sensor for North-South Lane 1
    input wire S1_SN,                    // Start sensor for North-South Lane 2
    input wire S1_EW,                    // Start sensor for East-West Lane 1
    input wire S1_WE,                    // Start sensor for East-West Lane 2
    input wire S5_NS,                    // Congestion sensor for North-South Lane 1
    input wire S5_SN,                    // Congestion sensor for North-South Lane 2
    input wire S5_EW,                    // Congestion sensor for East-West Lane 1
    input wire S5_WE,                    // Congestion sensor for East-West Lane 2
    output wire [1:0] NS_light,           // Traffic light signals for North-South Lane 1
    output wire [1:0] SN_light,           // Traffic light signals for North-South Lane 2
    output wire [1:0] EW_light,           // Traffic light signals for East-West Lane 1
    output wire [1:0] WE_light,           // Traffic light signals for East-West Lane 2
    output wire [3:0] current_state       // Current state of the FSM
);

    // Internal Signals
    wire [3:0] light_signal;             // Output from the FSM indicating the traffic light state
    wire timer_expired;                  // Timer expired signal to indicate transition timing

    // Instantiate the FSM (Finite State Machine)
    fsm FSM (
        .clk(timer_expired),             // Timer drives state transitions
        .rst(rst),                       // Reset signal for FSM
        .NS_S1(S1_NS),                   // Start sensor input for North-South Lane 1
        .SN_S1(S1_SN),                   // Start sensor input for North-South Lane 2
        .EW_S1(S1_EW),                   // Start sensor input for East-West Lane 1
        .WE_S1(S1_WE),                   // Start sensor input for East-West Lane 2
        .NS_S5(S5_NS),                   // Congestion sensor input for North-South Lane 1
        .SN_S5(S5_SN),                   // Congestion sensor input for North-South Lane 2
        .EW_S5(S5_EW),                   // Congestion sensor input for East-West Lane 1
        .WE_S5(S5_WE),                   // Congestion sensor input for East-West Lane 2
        .state(current_state),           // Current state output
        .light_signal(light_signal)      // Output signal indicating traffic light state
    );

    // Instantiate the Traffic Light Driver
    traffic_light_driver driver (
        .light_signal(light_signal),     // FSM light signal output
        .NS_light(NS_light),             // Traffic light output for North-South Lane 1
        .SN_light(SN_light),             // Traffic light output for North-South Lane 2
        .EW_light(EW_light),             // Traffic light output for East-West Lane 1
        .WE_light(WE_light)              // Traffic light output for East-West Lane 2
    );

    // Instantiate the Timer
    timer Timer (
        .clk(clk),                       // System clock
        .state(current_state),           // Current FSM state
        .expired(timer_expired)          // Output: Expired signal for state transitions
    );

endmodule
