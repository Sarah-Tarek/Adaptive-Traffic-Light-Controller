module timer (
    input wire clk,
    input wire rst,
    input wire start,
    input wire extend,
    output reg expired
);

    parameter DEFAULT_TIME = 20;
    parameter EXTENDED_TIME = 30;

    reg [5:0] counter; // Timer counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            expired <= 0;
        end else if (start) begin
            if (counter == (extend ? EXTENDED_TIME : DEFAULT_TIME)) begin
                expired <= 1;
            end else begin
                counter <= counter + 1;
                expired <= 0;
            end
        end
    end
endmodule
