
module fsm(
  input wire clk , rst,
  input wire NS_S1 , SN_S1 , EW_S1 , WE_S1,
  input wire NS_S5 , SN_S5 , EW_S5 , WE_S5,
  output reg[3:0] state,
  output reg[3:0] light_signal
);
  //internal signals
  reg[3:0] next_state;
  
  
  localparam   ALL_RED           = 4'b0000, //0
               NS_PRIMARY_GREEN  = 4'b0001, //1
               NS_EXTENDED_GREEN = 4'b0010, //2
               NS_YELLOW         = 4'b0011, //3
               SN_PRIMARY_GREEN  = 4'b0100, //4
               SN_EXTENDED_GREEN = 4'b0101, //5
               SN_YELLOW         = 4'b0110, //6
               EW_PRIMARY_GREEN  = 4'b0111, //7
               EW_EXTENDED_GREEN = 4'b1000, //8
               EW_YELLOW         = 4'b1001, //9
               WE_PRIMARY_GREEN  = 4'b1010, //10
               WE_EXTENDED_GREEN = 4'b1011, //11
               WE_YELLOW         = 4'b1100; //12
  
      // State transition logic
  always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= ALL_RED;
        end else begin
            state <= next_state;
        end
    end
  
  
     // Next state logic
    always @(*) begin
        case (state)
            //initial state
             ALL_RED:  
                     if(NS_S5) next_state = NS_EXTENDED_GREEN;
                      else if(SN_S5)  next_state = SN_EXTENDED_GREEN;
                       else if(EW_S5) next_state = EW_EXTENDED_GREEN;
                        else if(WE_S5) next_state = WE_EXTENDED_GREEN;
                         else if(NS_S1) next_state = NS_PRIMARY_GREEN;
                          else if(SN_S1) next_state = SN_PRIMARY_GREEN;
                           else if(EW_S1) next_state = EW_PRIMARY_GREEN;
                            else if(WE_S1) next_state = WE_PRIMARY_GREEN;
                             else next_state = ALL_RED;
          
            NS_YELLOW:
                      if(SN_S5)  next_state = SN_EXTENDED_GREEN;
					   else if(EW_S5) next_state = EW_EXTENDED_GREEN;
						else if(WE_S5) next_state = WE_EXTENDED_GREEN;
						 else if(SN_S1) next_state = SN_PRIMARY_GREEN;
						  else if(EW_S1) next_state = EW_PRIMARY_GREEN;
						   else if(WE_S1) next_state = WE_PRIMARY_GREEN;
                            else if(NS_S5) next_state = NS_EXTENDED_GREEN;
                            else if(NS_S1) next_state = NS_PRIMARY_GREEN;
                			  else next_state = ALL_RED;
            
            SN_YELLOW:
					  if(EW_S5) next_state = EW_EXTENDED_GREEN;
					   else if(WE_S5) next_state = WE_EXTENDED_GREEN;
						else if(NS_S5) next_state = NS_EXTENDED_GREEN;
						 else if(EW_S1) next_state = EW_PRIMARY_GREEN;
						  else if(WE_S1) next_state = WE_PRIMARY_GREEN;
						   else if(NS_S1) next_state = NS_PRIMARY_GREEN;
                            else if(SN_S5)  next_state = SN_EXTENDED_GREEN;
						    else if(SN_S1) next_state = SN_PRIMARY_GREEN;
                			 else next_state = ALL_RED;

            EW_YELLOW:
					  if(WE_S5) next_state = WE_EXTENDED_GREEN;
					   else if(NS_S5) next_state = NS_EXTENDED_GREEN;
						else if(SN_S5)  next_state = SN_EXTENDED_GREEN;
						 else if(WE_S1) next_state = WE_PRIMARY_GREEN;
						  else if(NS_S1) next_state = NS_PRIMARY_GREEN;
						   else if(SN_S1) next_state = SN_PRIMARY_GREEN;
                            else if(EW_S5)  next_state = EW_EXTENDED_GREEN;
                            else if(EW_S1) next_state = EW_PRIMARY_GREEN;
                			 else next_state = ALL_RED;
          
            WE_YELLOW:
                      if(NS_S5) next_state = NS_EXTENDED_GREEN;
					   else if(SN_S5)  next_state = SN_EXTENDED_GREEN;
						else if(EW_S5) next_state = EW_EXTENDED_GREEN;
						 else if(NS_S1) next_state = NS_PRIMARY_GREEN;
						  else if(SN_S1) next_state = SN_PRIMARY_GREEN;
						   else if(EW_S1) next_state = EW_PRIMARY_GREEN;
        				    else if(WE_S5)  next_state = WE_EXTENDED_GREEN;
          					else if(WE_S1) next_state = WE_PRIMARY_GREEN;          
                			 else next_state = ALL_RED;


            NS_PRIMARY_GREEN: next_state = NS_YELLOW;
            NS_EXTENDED_GREEN: next_state = NS_YELLOW;
            SN_PRIMARY_GREEN: next_state = SN_YELLOW;
            SN_EXTENDED_GREEN: next_state = SN_YELLOW;            
            EW_PRIMARY_GREEN: next_state = EW_YELLOW;
            EW_EXTENDED_GREEN: next_state = EW_YELLOW;            
            WE_PRIMARY_GREEN: next_state = WE_YELLOW;
            WE_EXTENDED_GREEN: next_state = WE_YELLOW;
          

            default:            next_state = ALL_RED;  // Safe default state
        endcase
    end
  
        // FSM Output Logic (Based on Current State)
    always @(*) begin
        case (state)
            // North-South Lane 1
            NS_PRIMARY_GREEN:    light_signal = 4'b0001;  // NS: PRIMARY_GREEN, Others: RED
            NS_EXTENDED_GREEN:   light_signal = 4'b0001;  // NS: EXTENDED_GREEN, Others: RED
            NS_YELLOW:           light_signal = 4'b0010;  // NS: YELLOW, Others: RED

            // North-South Lane 2
            SN_PRIMARY_GREEN:    light_signal = 4'b0011;  // SN: PRIMARY_GREEN, Others: RED
            SN_EXTENDED_GREEN:   light_signal = 4'b0011;  // SN: EXTENDED_GREEN, Others: RED
            SN_YELLOW:           light_signal = 4'b0100;  // SN: YELLOW, Others: RED

            // East-West Lane 1
            EW_PRIMARY_GREEN:    light_signal = 4'b0101;  // EW: PRIMARY_GREEN, Others: RED
            EW_EXTENDED_GREEN:   light_signal = 4'b0101;  // EW: EXTENDED_GREEN, Others: RED
            EW_YELLOW:           light_signal = 4'b0110;  // EW: YELLOW, Others: RED

            // East-West Lane 2
            WE_PRIMARY_GREEN:    light_signal = 4'b0111;  // WE: PRIMARY_GREEN, Others: RED
            WE_EXTENDED_GREEN:   light_signal = 4'b0111;  // WE: EXTENDED_GREEN, Others: RED
            WE_YELLOW:           light_signal = 4'b1000;  // WE: YELLOW, Others: RED
          
            //all red
            ALL_RED: light_signal = 4'b0000;

            default:             light_signal = 4'b0000;  // All RED (Safe state)
        endcase
end
  
  
  
endmodule 
