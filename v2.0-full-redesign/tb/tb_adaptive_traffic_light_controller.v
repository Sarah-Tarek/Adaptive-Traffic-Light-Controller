`timescale 1ns/1ns

module adaptive_traffic_light_controller_tb();
  reg clk_tb;
  reg rst_tb;
  reg S1_NS_tb;
  reg S1_SN_tb;
  reg S1_EW_tb;
  reg S1_WE_tb;
  reg S5_NS_tb;
  reg S5_SN_tb;
  reg S5_EW_tb;
  reg S5_WE_tb;
  wire [3:0] state_tb;
  wire [1:0] NS_light_tb;
  wire [1:0] SN_light_tb;
  wire [1:0] EW_light_tb;
  wire [1:0] WE_light_tb;


//instantiate DUT
  adaptive_traffic_light_controller DUT(.clk(clk_tb) , .rst(rst_tb) , .S1_NS(S1_NS_tb) , .S1_SN(S1_SN_tb) ,.S1_EW(S1_EW_tb) ,.S1_WE(S1_WE_tb) , .S5_NS(S5_NS_tb) , .S5_SN(S5_SN_tb) ,.S5_EW(S5_EW_tb) ,.S5_WE(S5_WE_tb) , .current_state(state_tb), .NS_light(NS_light_tb) , .SN_light(SN_light_tb) , .EW_light(EW_light_tb) , .WE_light(WE_light_tb));

  //clk generator
  initial begin
    clk_tb = 1'b0;
    forever begin #2 clk_tb = ~clk_tb; end
  end


  //testing rst
  initial begin
       rst_tb <= 1'b0;
    #1 rst_tb <= 1'b1;
    #1 rst_tb <= 1'b0;
  end

  //test cases: testing every transition and reset
  //test case all s1 and s5 == 0
  initial begin
  S1_NS_tb <= 1'b0;
  S1_SN_tb <= 1'b0;
  S1_EW_tb <= 1'b0;
  S1_WE_tb <= 1'b0;
  S5_NS_tb <= 1'b0;
  S5_SN_tb <= 1'b0;
  S5_EW_tb <= 1'b0;
  S5_WE_tb <= 1'b0;
  #20
  //NS has cars all others no cars
  S1_NS_tb <= 1'b1;
  #10
  //NS has congestion  all others no cars
  S5_NS_tb <= 1'b1;
  #100
  //NS no congestion  all others no cars
  S5_NS_tb <= 1'b0;
  #10
  //SN has cars and NS has cars
  S1_SN_tb <= 1'b1;
  #30
  //SN has cogestion and NS have cars
  S5_SN_tb <= 1'b1;
  #120
  //SN no congestion and NS have cars
  S5_SN_tb <= 1'b0;
  #10
  //EW has cars and SN , NS have cars
  S1_EW_tb <= 1'b1;
  #10
  //EW has cogestion and SN , NS have cars
  S5_EW_tb <= 1'b1;
  #140
  //EW no congestion and SN , NS have cars
  S5_EW_tb <= 1'b0;
  #10
  //WE , EW , SN , NS have cars
  S1_WE_tb <= 1'b1;
  #10
  //WE has cogestion  and EW , SN , NS have cars
  S5_WE_tb <= 1'b1;
  #160
  //WE no congestion  and EW , SN , NS have cars
  S5_WE_tb <= 1'b0;
  #50
  //WE has no cars and EW, NS , SN have cars
  S1_WE_tb <= 1'b0;
  #100
  //NS has no cars and EW , SN have cars
  S1_NS_tb <= 1'b0;
  #100
  //SN no cars and EW has cars
  S1_SN_tb <= 1'b0;
  #100
  //ALL no cars
  S1_EW_tb <= 1'b0;
  #50
  //WE has cars
  S1_WE_tb <= 1'b1;
  #100
  //SN no cars and EW has cars
  S1_SN_tb <= 1'b0;
  #120
  //NO cars at all traffic
  S1_WE_tb <= 1'b0;
  #100
  //SN has traffic and NS has cars
  S1_SN_tb <= 1'b1;
  #10
  S1_NS_tb <= 1'b1;
  #10
  S5_SN_tb <= 1'b1;

  #50
  S5_SN_tb <= 1'b0;
  #20
  S1_SN_tb <= 1'b0;
  #30
  S1_NS_tb <= 1'b0;
  #20
  $finish ;
  end

  endmodule
