module timer (
    input wire clk,rst,            // System clock
    input wire [3:0] state,         // Extend the green light duration
    output reg expired         // Timer expired signal
);
    
    parameter RED_TIME = 1;             // if all red check again next cycle
    parameter PRIMARY_GREEN_TIME = 20;  // Default green light duration
    parameter EXTENDED_GREEN_TIME = 30; // Extended green light duration
    parameter YELLOW_TIME = 5;    // Yellow light duration

    reg [5:0] counter; // Timer counter (6 bits for up to 63 counts)
 
  
  always@(state)begin

    case(state)
      4'b0000: counter = RED_TIME;
      4'b0001 , 4'b0100 , 4'b0111 , 4'b1010: counter = PRIMARY_GREEN_TIME;
      4'b0010 , 4'b0101 , 4'b1000 , 4'b1011: counter = EXTENDED_GREEN_TIME;
      4'b0011 , 4'b0110 , 4'b1001 , 4'b1100: counter = YELLOW_TIME;
      default: counter = RED_TIME;
      endcase

  end  
  
  always @(posedge clk) begin
    expired <= 0;
    if(counter == 1) expired <= 1;  
    else counter <= counter - 1;
    end
  
   always @(negedge clk) expired <= 0;     

endmodule
