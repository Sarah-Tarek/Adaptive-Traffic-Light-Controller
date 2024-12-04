module sensor_input_handler (
    input wire clk,
    input wire rst,
    input wire raw_sensor,
    output reg debounced_sensor
);

    reg [1:0] sync;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync <= 2'b00;
            debounced_sensor <= 0;
        end else begin
            sync <= {sync[0], raw_sensor};
            if (sync == 2'b11)
                debounced_sensor <= 1;
            else if (sync == 2'b00)
                debounced_sensor <= 0;
        end
    end
endmodule
