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
  wire [3:0] light_signal_tb;

//instantiate DUT
  fsm DUT(.clk(clk_tb) , .rst(rst_tb) , .NS_S1(NS_S1_tb) , .SN_S1(SN_S1_tb) ,.EW_S1(EW_S1_tb) ,.WE_S1(WE_S1_tb) , .NS_S5(NS_S5_tb) , .SN_S5(SN_S5_tb) ,.EW_S5(EW_S5_tb) ,.WE_S5(WE_S5_tb) , .state(state_tb), .light_signal(light_signal_tb));

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

  //test cases: testing every transition and reset
  initial begin
  NS_S1_tb <= 1'b0;
  SN_S1_tb <= 1'b0;
  EW_S1_tb <= 1'b0;
  WE_S1_tb <= 1'b0;

  NS_S5_tb <= 1'b0;
  SN_S5_tb <= 1'b0;
  EW_S5_tb <= 1'b0;
  WE_S5_tb <= 1'b0;
  #42
  NS_S1_tb <= 1'b1;
  #8
  NS_S5_tb <= 1'b1;
  #10
  SN_S1_tb <= 1'b1;
  #10
  SN_S5_tb <= 1'b1;
  #10
  EW_S1_tb <= 1'b1;
  #10
  EW_S5_tb <= 1'b1;
  #10
  #10
  #10
  WE_S1_tb <= 1'b1;
  #10
  WE_S5_tb <= 1'b1;
  #10
  #10
  #20
  rst_tb <= 1'b1;
  #12
  rst_tb <= 1'b0;
  #20
  NS_S5_tb <= 1'b0;
  #10
  SN_S5_tb <= 1'b0;
  #10
  EW_S5_tb <= 1'b0;
  #10
  WE_S5_tb <= 1'b0;
  #10
  SN_S1_tb <= 1'b0;
  #10

  $finish ;
  end

  //
  always@(posedge clk_tb)begin
    $display("state = %0b , next state = %0b , Light signal = %0b" , state_tb , DUT.next_state , light_signal_tb);
  end

  endmodule
