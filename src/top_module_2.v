module adaptive_traffic_light_controller (
    input wire clk,                      // System clock
    input wire rst,                      // Reset signal
    input wire S1_NS,               // Raw S1 sensor for North-South Lane 1
    input wire S1_SN,               // Raw S1 sensor for North-South Lane 2
    input wire S1_EW,               // Raw S1 sensor for East-West Lane 1
    input wire S1_WE,               // Raw S1 sensor for East-West Lane 2
    input wire S5_NS,               // Raw S5 congestion sensor for North-South Lane 1
    input wire S5_SN,               // Raw S5 congestion sensor for North-South Lane 2
    input wire S5_EW,               // Raw S5 congestion sensor for East-West Lane 1
    input wire S5_WE,               // Raw S5 congestion sensor for East-West Lane 2
  output reg [1:0] NS_light,         // Traffic light signals for North-South Lane 1
  output reg [1:0] SN_light,         // Traffic light signals for North-South Lane 2
  output reg [1:0] EW_light,         // Traffic light signals for East-West Lane 1
  output reg [1:0] WE_light,          // Traffic light signals for East-West Lane 2
  output reg [3:0] current_state
);

    // Internal signals

    //wire [3:0] current_state;           // FSM current state
    wire [3:0] light_signal;
    wire timer_expired;                 // Timer expired signal

   
    // Instantiate the FSM
    fsm FSM (
      .clk(timer_expired),
        .rst(rst),
        .NS_S1(S1_NS),
        .SN_S1(S1_SN),
        .EW_S1(S1_EW),
        .WE_S1(S1_WE),
        .NS_S5(S5_NS),
        .SN_S5(S5_SN),
        .EW_S5(S5_EW),
        .WE_S5(S5_WE),
      .state(current_state) ,
      .light_signal(light_signal)
    );


    // Instantiate the traffic light driver
    traffic_light_driver driver (
      .light_signal(light_signal),    // FSM output signal
        .NS_light(NS_light),           // Traffic light output for NS
        .SN_light(SN_light),           // Traffic light output for SN
        .EW_light(EW_light),           // Traffic light output for EW
        .WE_light(WE_light)            // Traffic light output for WE
    );

    // Timer control logic
  timer Timer(.clk(clk) , .state(current_state) , .expired(timer_expired)) ;

endmodule
