module FSM_tb();
  reg clk_tb;
  reg rst_tb;
  reg NS1_S1_tb;
  reg NS2_S1_tb;
  reg EW1_S1_tb;
  reg EW2_S1_tb;
  reg NS1_S5_tb;
  reg NS2_S5_tb;
  reg EW1_S5_tb;
  reg EW2_S5_tb;
  wire [3:0] state_tb;
  wire [3:0] next_state_tb;
  wire [3:0] light_signal_tb;
  
//instantiate DUT  
  traffic_light_fsm DUT(.clk(clk_tb) , .rst(rst_tb) , .NS1_S1(NS1_S1_tb) , .NS2_S1(NS2_S1_tb) ,.EW1_S1(EW1_S1_tb) ,.EW2_S1(EW2_S1_tb) , .NS1_S5(NS1_S5_tb) , .NS2_S5(NS2_S5_tb) ,.EW1_S5(EW1_S5_tb) ,.EW2_S5(EW2_S5_tb) , .state(state_tb) , .next_state(next_state_tb) , .light_signal(light_signal_tb));
  
  //clk generator
  initial begin
    clk_tb = 1'b0;
    forever begin #5 clk_tb = ~clk_tb; end
  end
  
  
  //testing rst
  initial begin
       rst_tb <= 1'b0;
    #3 rst_tb <= 1'b1;
    #1 rst_tb <= 1'b0;
  end
  
  //test cases: testing every transition
  initial begin
  // NS1_RED --> NS2_RED --> EW1_RED --> EW2_RED --> NS1_RED
  NS1_S1_tb <= 1'b0;
  NS2_S1_tb <= 1'b0;
  EW1_S1_tb <= 1'b0;
  EW2_S1_tb <= 1'b0;
    
  NS1_S5_tb <= 1'b0;
  NS2_S5_tb <= 1'b0;
  EW1_S5_tb <= 1'b0;
  EW2_S5_tb <= 1'b0;  
  #42
  //NS1  
  //NS1_RED --> NS1_GREEN  
  NS1_S1_tb <= 1'b1;
  #8
  //NS1_GREEN --> NS1_GREEN_2
  NS1_S5_tb <= 1'b1;
  #10
  //NS1_GREEN_2 --> NS1_YELLOW
  #10
  //NS1_YELLOW --> NS2_RED
  #10
  //NS2 
  //NS2_RED --> NS2_GREEN
  NS2_S1_tb <= 1'b1; 
  #10
  //NS2_GREEN --> NS2_GREEN_2
  NS2_S5_tb <= 1'b1;
  #10
  //NS2_GREEN_2 --> NS2_YELLOW
  #10  
  //NS2_YELLOW --> EW1_RED
  #10
  //EW1
  //EW1_RED --> EW1_GREEN
  EW1_S1_tb <= 1'b1; 
  #10
  //EW1_GREEN --> EW1_GREEN_2
  EW1_S5_tb <= 1'b1;
  #10
  //EW1_GREEN_2 --> EW1_YELLOW
  #10  
  //EW1_YELLOW --> EW2_RED
  #10
   //EW2
  //EW2_RED --> EW2_GREEN
  EW2_S1_tb <= 1'b1; 
  #10
  //EW2_GREEN --> EW2_GREEN_2
  EW2_S5_tb <= 1'b1;
  #10
  //EW2_GREEN_2 --> EW2_YELLOW
  #10  
  //EW2_YELLOW --> NS1_RED
  #20
  rst_tb <= 1'b1;
  #12
  rst_tb <= 1'b0;
  #30  
    
  $finish ;    
  end
  
  //
  always@(posedge clk_tb)begin
    $display("state = %0b , next state = %0b , Light signal = %0b" , state_tb , next_state_tb , light_signal_tb);
  end 
  
  endmodule
