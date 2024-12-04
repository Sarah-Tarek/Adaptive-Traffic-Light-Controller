module traffic_light_driver (
    input wire clk,
    input wire rst,
    input wire [3:0] light_signal,
    output reg [3:0] traffic_lights
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            traffic_lights <= 4'b0000;
        end else begin
            traffic_lights <= light_signal;
        end
    end
endmodule
