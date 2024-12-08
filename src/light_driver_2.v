module traffic_light_driver (

  input wire [3:0] light_signal, // FSM output signal
  output reg [1:0] NS_light,    // Traffic light signals for NS
  output reg [1:0] SN_light,    // Traffic light signals for SN
  output reg [1:0] EW_light,    // Traffic light signals for EW
  output reg [1:0] WE_light     // Traffic light signals for WE
);

    // Traffic light states
    localparam RED    = 2'b00;
    localparam GREEN  = 2'b01;
    localparam YELLOW = 2'b10;

    // Light control logic
  always @(*) begin

            // Decode FSM signal to control traffic lights
            case (light_signal)
                //All red
                4'b0000: begin
                    NS_light <= RED;
                    SN_light <= RED;
           		    EW_light <= RED;
                    WE_light <= RED;  
                end  
                  
                // North-South Lane 1
                4'b0001: begin
                    NS_light <= GREEN;
                    SN_light <= RED;
                    EW_light <= RED;
                    WE_light <= RED;
                end
                4'b0010: begin
                    NS_light <= YELLOW;
                    SN_light <= RED;
                    EW_light <= RED;
                    WE_light <= RED;
                end

                // North-South Lane 2
                4'b0011: begin
                    NS_light <= RED;
                    SN_light <= GREEN;
                    EW_light <= RED;
                    WE_light <= RED;
                end
                4'b0100: begin
                    NS_light <= RED;
                    SN_light <= YELLOW;
                    EW_light <= RED;
                    WE_light <= RED;
                end

                // East-West Lane 1
                4'b0101: begin
                    NS_light <= RED;
                    SN_light <= RED;
                    EW_light <= GREEN;
                    WE_light <= RED;
                end
                4'b0110: begin
                    NS_light <= RED;
                    SN_light <= RED;
                    EW_light <= YELLOW;
                    WE_light <= RED;
                end

                // East-West Lane 2
                4'b0111: begin
                    NS_light <= RED;
                    SN_light <= RED;
                    EW_light <= RED;
                    WE_light <= GREEN;
                end
                4'b1000: begin
                    NS_light <= RED;
                    SN_light <= RED;
                    EW_light <= RED;
                    WE_light <= YELLOW;
                end

                // Default case: All RED
                default: begin
                    NS_light <= RED;
                    SN_light <= RED;
                    EW_light <= RED;
                    WE_light <= RED;
                end
            endcase
        end
endmodule
