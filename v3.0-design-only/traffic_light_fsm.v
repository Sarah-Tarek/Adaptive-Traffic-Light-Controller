module fsm(
  input wire clk,                    // System clock
  input wire rst,                    // Reset signal
  input wire NS_S1,                  // Vehicle presence sensor for North-South Lane 1
  input wire SN_S1,                  // Vehicle presence sensor for South-North Lane 2
  input wire EW_S1,                  // Vehicle presence sensor for East-West Lane 1
  input wire WE_S1,                  // Vehicle presence sensor for West-East Lane 2
  input wire NS_S5,                  // Congestion sensor for North-South Lane 1
  input wire SN_S5,                  // Congestion sensor for South-North Lane 2
  input wire EW_S5,                  // Congestion sensor for East-West Lane 1
  input wire WE_S5,                  // Congestion sensor for West-East Lane 2
  input wire expired,                //expired signal
  output reg [3:0] state,            // Current state of the FSM
  output reg [3:0] light_signal      // Output signal to control traffic lights
);

  // Internal signals
  reg [3:0] next_state;              // Next state of the FSM

  // State encoding
  localparam   ALL_RED           = 4'b0000, // All lights are red
               NS_PRIMARY_GREEN  = 4'b0001, // North-South Lane 1 has green light
               NS_EXTENDED_GREEN = 4'b0010, // Extended green for North-South Lane 1
               NS_YELLOW         = 4'b0011, // Yellow light for North-South Lane 1
               SN_PRIMARY_GREEN  = 4'b0100, // South-North Lane 2 has green light
               SN_EXTENDED_GREEN = 4'b0101, // Extended green for South-North Lane 2
               SN_YELLOW         = 4'b0110, // Yellow light for South-North Lane 2
               EW_PRIMARY_GREEN  = 4'b0111, // East-West Lane 1 has green light
               EW_EXTENDED_GREEN = 4'b1000, // Extended green for East-West Lane 1
               EW_YELLOW         = 4'b1001, // Yellow light for East-West Lane 1
               WE_PRIMARY_GREEN  = 4'b1010, // West-East Lane 2 has green light
               WE_EXTENDED_GREEN = 4'b1011, // Extended green for West-East Lane 2
               WE_YELLOW         = 4'b1100; // Yellow light for West-East Lane 2

  // State transition logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= ALL_RED;              // Reset to the initial state: ALL_RED
    end else if(expired == 1) begin
      state <= next_state;           // Move to the next state
    end
    else begin
      state <= state;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      // Initial state: All lights are red
      ALL_RED:
        if (NS_S5) next_state = NS_EXTENDED_GREEN;      // Congestion on North-South Lane 1
        else if (SN_S5) next_state = SN_EXTENDED_GREEN; // Congestion on South-North Lane 2
        else if (EW_S5) next_state = EW_EXTENDED_GREEN; // Congestion on East-West Lane 1
        else if (WE_S5) next_state = WE_EXTENDED_GREEN; // Congestion on West-East Lane 2
        else if (NS_S1) next_state = NS_PRIMARY_GREEN;  // Vehicle detected on North-South Lane 1
        else if (SN_S1) next_state = SN_PRIMARY_GREEN;  // Vehicle detected on South-North Lane 2
        else if (EW_S1) next_state = EW_PRIMARY_GREEN;  // Vehicle detected on East-West Lane 1
        else if (WE_S1) next_state = WE_PRIMARY_GREEN;  // Vehicle detected on West-East Lane 2
        else next_state = ALL_RED;                      // Remain in ALL_RED state

      // Transition from North-South Lane 1 yellow light
      NS_YELLOW:
        if (SN_S5) next_state = SN_EXTENDED_GREEN;      // Congestion on South-North Lane 2
        else if (EW_S5) next_state = EW_EXTENDED_GREEN; // Congestion on East-West Lane 1
        else if (WE_S5) next_state = WE_EXTENDED_GREEN; // Congestion on West-East Lane 2
        else if (SN_S1) next_state = SN_PRIMARY_GREEN;  // Vehicle detected on South-North Lane 2
        else if (EW_S1) next_state = EW_PRIMARY_GREEN;  // Vehicle detected on East-West Lane 1
        else if (WE_S1) next_state = WE_PRIMARY_GREEN;  // Vehicle detected on West-East Lane 2
        else next_state = ALL_RED;                      // Default transition

      // Transition from South-North Lane 2 yellow light
      SN_YELLOW:
        if (EW_S5) next_state = EW_EXTENDED_GREEN;      // Congestion on East-West Lane 1
        else if (WE_S5) next_state = WE_EXTENDED_GREEN; // Congestion on West-East Lane 2
        else if (NS_S5) next_state = NS_EXTENDED_GREEN; // Congestion on North-South Lane 1
        else if (EW_S1) next_state = EW_PRIMARY_GREEN;  // Vehicle detected on East-West Lane 1
        else if (WE_S1) next_state = WE_PRIMARY_GREEN;  // Vehicle detected on West-East Lane 2
        else if (NS_S1) next_state = NS_PRIMARY_GREEN;  // Vehicle detected on North-South Lane 1
        else next_state = ALL_RED;                      // Default transition

      // Transition from East-West Lane 1 yellow light
      EW_YELLOW:
        if (WE_S5) next_state = WE_EXTENDED_GREEN;      // Congestion on West-East Lane 2
        else if (NS_S5) next_state = NS_EXTENDED_GREEN; // Congestion on North-South Lane 1
        else if (SN_S5) next_state = SN_EXTENDED_GREEN; // Congestion on South-North Lane 2
        else if (WE_S1) next_state = WE_PRIMARY_GREEN;  // Vehicle detected on West-East Lane 2
        else if (NS_S1) next_state = NS_PRIMARY_GREEN;  // Vehicle detected on North-South Lane 1
        else if (SN_S1) next_state = SN_PRIMARY_GREEN;  // Vehicle detected on South-North Lane 2
        else next_state = ALL_RED;                      // Default transition

      // Transition from West-East Lane 2 yellow light
      WE_YELLOW:
        if (NS_S5) next_state = NS_EXTENDED_GREEN;      // Congestion on North-South Lane 1
        else if (SN_S5) next_state = SN_EXTENDED_GREEN; // Congestion on South-North Lane 2
        else if (EW_S5) next_state = EW_EXTENDED_GREEN; // Congestion on East-West Lane 1
        else if (NS_S1) next_state = NS_PRIMARY_GREEN;  // Vehicle detected on North-South Lane 1
        else if (SN_S1) next_state = SN_PRIMARY_GREEN;  // Vehicle detected on South-North Lane 2
        else if (EW_S1) next_state = EW_PRIMARY_GREEN;  // Vehicle detected on East-West Lane 1
        else next_state = ALL_RED;                      // Default transition

      // Green light states transition directly to yellow
      NS_PRIMARY_GREEN: next_state = NS_YELLOW;
      NS_EXTENDED_GREEN: next_state = NS_YELLOW;
      SN_PRIMARY_GREEN: next_state = SN_YELLOW;
      SN_EXTENDED_GREEN: next_state = SN_YELLOW;
      EW_PRIMARY_GREEN: next_state = EW_YELLOW;
      EW_EXTENDED_GREEN: next_state = EW_YELLOW;
      WE_PRIMARY_GREEN: next_state = WE_YELLOW;
      WE_EXTENDED_GREEN: next_state = WE_YELLOW;

      // Safe default state
      default: next_state = ALL_RED;
    endcase
  end

  // FSM Output Logic (Based on Current State)
  always @(*) begin
    case (state)
      NS_PRIMARY_GREEN, NS_EXTENDED_GREEN: light_signal = 4'b0001; // GREEN for NS
      NS_YELLOW:                           light_signal = 4'b0010; // YELLOW for NS

      SN_PRIMARY_GREEN, SN_EXTENDED_GREEN: light_signal = 4'b0011; // GREEN for SN
      SN_YELLOW:                           light_signal = 4'b0100; // YELLOW for SN

      EW_PRIMARY_GREEN, EW_EXTENDED_GREEN: light_signal = 4'b0101; // GREEN for EW
      EW_YELLOW:                           light_signal = 4'b0110; // YELLOW for EW

      WE_PRIMARY_GREEN, WE_EXTENDED_GREEN: light_signal = 4'b0111; // GREEN for WE
      WE_YELLOW:                           light_signal = 4'b1000; // YELLOW for WE

      ALL_RED: light_signal = 4'b0000; // All directions RED

      default: light_signal = 4'b0000; // Default to RED
    endcase
  end
endmodule
