module traffic_light_driver (
    input wire clk,
    input wire rst,
    input wire [3:0] light_signal, // FSM output signal
    output reg [3:0] NS1_light,    // Traffic light signals for NS1
    output reg [3:0] NS2_light,    // Traffic light signals for NS2
    output reg [3:0] EW1_light,    // Traffic light signals for EW1
    output reg [3:0] EW2_light     // Traffic light signals for EW2
);

    // Traffic light states
    localparam RED    = 4'b0001;
    localparam GREEN  = 4'b0010;
    localparam YELLOW = 4'b0100;

    // Light control logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Default state: All lights are RED
            NS1_light <= RED;
            NS2_light <= RED;
            EW1_light <= RED;
            EW2_light <= RED;
        end else begin
            // Decode FSM signal to control traffic lights
            case (light_signal)
                // North-South Lane 1
                4'b0001: begin
                    NS1_light <= GREEN;
                    NS2_light <= RED;
                    EW1_light <= RED;
                    EW2_light <= RED;
                end
                4'b0010: begin
                    NS1_light <= YELLOW;
                    NS2_light <= RED;
                    EW1_light <= RED;
                    EW2_light <= RED;
                end

                // North-South Lane 2
                4'b0011: begin
                    NS1_light <= RED;
                    NS2_light <= GREEN;
                    EW1_light <= RED;
                    EW2_light <= RED;
                end
                4'b0100: begin
                    NS1_light <= RED;
                    NS2_light <= YELLOW;
                    EW1_light <= RED;
                    EW2_light <= RED;
                end

                // East-West Lane 1
                4'b0101: begin
                    NS1_light <= RED;
                    NS2_light <= RED;
                    EW1_light <= GREEN;
                    EW2_light <= RED;
                end
                4'b0110: begin
                    NS1_light <= RED;
                    NS2_light <= RED;
                    EW1_light <= YELLOW;
                    EW2_light <= RED;
                end

                // East-West Lane 2
                4'b0111: begin
                    NS1_light <= RED;
                    NS2_light <= RED;
                    EW1_light <= RED;
                    EW2_light <= GREEN;
                end
                4'b1000: begin
                    NS1_light <= RED;
                    NS2_light <= RED;
                    EW1_light <= RED;
                    EW2_light <= YELLOW;
                end

                // Default case: All RED
                default: begin
                    NS1_light <= RED;
                    NS2_light <= RED;
                    EW1_light <= RED;
                    EW2_light <= RED;
                end
            endcase
        end
    end
endmodule
