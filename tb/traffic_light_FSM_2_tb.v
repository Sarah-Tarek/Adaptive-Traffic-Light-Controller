module FSM_tb();
  reg clk_tb;
  reg rst_tb;
  reg NS_S1_tb;
  reg SN_S1_tb;
  reg EW_S1_tb;
  reg WE_S1_tb;
  reg NS_S5_tb;
  reg SN_S5_tb;
  reg EW_S5_tb;
  reg WE_S5_tb;
  wire [3:0] state_tb;
  wire [3:0] next_state_tb;
  wire [3:0] light_signal_tb;
  
//instantiate DUT  
  traffic_light_fsm DUT(.clk(clk_tb) , .rst(rst_tb) , .NS_S1(NS_S1_tb) , .SN_S1(SN_S1_tb) ,.EW_S1(EW_S1_tb) ,.WE_S1(WE_S1_tb) , .NS_S5(NS_S5_tb) , .SN_S5(SN_S5_tb) ,.EW_S5(EW_S5_tb) ,.WE_S5(WE_S5_tb) , .state(state_tb) , .next_state(next_state_tb) , .light_signal(light_signal_tb));
  
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
  // NS_RED --> SN_RED --> EW_RED --> WE_RED --> NS_RED
  NS_S1_tb <= 1'b0;
  SN_S1_tb <= 1'b0;
  EW_S1_tb <= 1'b0;
  WE_S1_tb <= 1'b0;
    
  NS_S5_tb <= 1'b0;
  SN_S5_tb <= 1'b0;
  EW_S5_tb <= 1'b0;
  WE_S5_tb <= 1'b0;  
  #42
  //NS  
  //NS_RED --> NS_PRIMARY_GREEN  
  NS_S1_tb <= 1'b1;
  #8
  //NS_PRIMARY_GREEN --> NS_EXTENDED_GREEN
  NS_S5_tb <= 1'b1;
  #10
  //NS_EXTENDED_GREEN --> NS_YELLOW
  #10
  //NS_YELLOW --> SN_RED
  #10
  //SN 
  //SN_RED --> SN_PRIMARY_GREEN
  SN_S1_tb <= 1'b1; 
  #10
  //SN_PRIMARY_GREEN --> SN_EXTENDED_GREEN
  SN_S5_tb <= 1'b1;
  #10
  //SN_EXTENDED_GREEN --> SN_YELLOW
  #10  
  //SN_YELLOW --> EW_RED
  #10
  //EW
  //EW_RED --> EW_PRIMARY_GREEN
  EW_S1_tb <= 1'b1; 
  #10
  //EW_PRIMARY_GREEN --> EW_EXTENDED_GREEN
  EW_S5_tb <= 1'b1;
  #10
  //EW_EXTENDED_GREEN --> EW_YELLOW
  #10  
  //EW_YELLOW --> WE_RED
  #10
   //WE
  //WE_RED --> WE_PRIMARY_GREEN
  WE_S1_tb <= 1'b1; 
  #10
  //WE_PRIMARY_GREEN --> WE_EXTENDED_GREEN
  WE_S5_tb <= 1'b1;
  #10
  //WE_EXTENDED_GREEN --> WE_YELLOW
  #10  
  //WE_YELLOW --> NS_RED
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
