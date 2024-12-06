`timescale 1ns/1ps

module traffic_light_fsm_tb;

    // Inputs
    reg clk;
    reg rst;
    reg S1_NS1, S1_NS2, S1_EW1, S1_EW2;
    reg S5_NS1, S5_NS2, S5_EW1, S5_EW2;

    // Outputs
    wire [3:0] state;
    wire [3:0] next_state;
    wire [3:0] light_signal;

    // Instantiate the traffic_light_fsm
    traffic_light_fsm uut (
        .clk(clk),
        .rst(rst),
        .S1_NS1(S1_NS1),
        .S1_NS2(S1_NS2),
        .S1_EW1(S1_EW1),
        .S1_EW2(S1_EW2),
        .S5_NS1(S5_NS1),
        .S5_NS2(S5_NS2),
        .S5_EW1(S5_EW1),
        .S5_EW2(S5_EW2),
        .state(state),
        .next_state(next_state),
        .light_signal(light_signal)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        S1_NS1 = 0; S1_NS2 = 0; S1_EW1 = 0; S1_EW2 = 0;
        S5_NS1 = 0; S5_NS2 = 0; S5_EW1 = 0; S5_EW2 = 0;

        // Release reset
        #10 rst = 0;

        // Test case 1: Simulate NS1 traffic and congestion
        #10 S1_NS1 = 1;
        #20 S5_NS1 = 1;
        #30 S1_NS1 = 0; S5_NS1 = 0;

        // Test case 2: Simulate NS2 traffic
        #40 S1_NS2 = 1;
        #20 S1_NS2 = 0;

        // Test case 3: Simulate EW1 traffic and congestion
        #40 S1_EW1 = 1;
        #20 S5_EW1 = 1;
        #30 S1_EW1 = 0; S5_EW1 = 0;

        // Test case 4: Simulate EW2 traffic
        #40 S1_EW2 = 1;
        #20 S1_EW2 = 0;

        // Test case 5: Ensure EW2_YELLOW is reached
        #40 S1_EW2 = 1;
        #20 S1_EW2 = 0;

        #50 $stop;
    end

    // Monitor state transitions
    initial begin
        $monitor("Time=%0d | State=%b | Next_State=%b | Light_Signal=%b | S1=%b | S5=%b",
                 $time, state, next_state, light_signal, {S1_NS1, S1_NS2, S1_EW1, S1_EW2},
                 {S5_NS1, S5_NS2, S5_EW1, S5_EW2});
    end

endmodule
