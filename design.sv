
module rrarbiter (clk,rstn, req0, req1, req2, req3, gnt0, gnt1,gnt2, gnt3,eot0,eot1,eot2, eot3);


   input            clk, rstn, req0, req1, req2, req3, eot0, eot1, eot2, eot3;
   output              gnt0, gnt1, gnt2, gnt3;


   /* arbiter state machine states*/
   localparam 
     IDLE = 3'd0, // awaiting requests or transition state for any GNTx to GNTy
     GNT0 = 3'd1, // currently grant is with agent0
     GNT1 = 3'd2, // currently grant is with agent1
     GNT2 = 3'd3, // currently grant is with agent2
     GNT3 = 3'd4; // currently grant is with agent3


   /* registers for storing arbiter_state, gnt, gnt history
    * Note that though arb_state_next, gnt_next and gnt_hist_next are defined as
    * reg, but they will not be synthesized as registers. These are defined as reg
    * as they are used in the always @(*) block */


   reg [2:0]              arb_state, arb_state_next; // stores arbiter state machine
   reg [3:0]              gnt, gnt_next;             // gnt bus drives gnt3 down to gnt0.
   reg [3:0]              gnt_hist, gnt_hist_next;   // gnt_hist keeps record of which agent got the last grant


   assign {gnt3,gnt2,gnt1,gnt0} = gnt; // equivalent to gnt3 = gnt[3], gnt2 = gnt[2] .. gnt0 = gnt[0] 


   /* Sequential logic 
    * gnt_hist is given a non-zero default value to resolve priority on reset.
    * A value of 4'b1000 means that agent3 got the last access to the resource and
    * therefore now resource will be allocated to agent0,1,2,3 in that order of
    * priority based on their request status. */


   always @(posedge clk or negedge rstn)
     begin
        if(!rstn)
          begin
             arb_state <= IDLE;    // Waiting mode
             gnt <= 'd0;           // Nobody has the grant.
             gnt_hist <= 4'b1000;  // This needs to be non-zero to resolve priority on reset.
             
          end
        else
          begin
             arb_state <= arb_state_next; // arb_state_next is having the value that should go to arb_state and so on..
             gnt <= gnt_next;
             gnt_hist <= gnt_hist_next;
          end
     end


   /* Combinational logic 
    * Primarily computing the arb_state_next, gnt_next, gnt_hist_next 


    * Given the order as 0,1,2,3 - RR would mean 0,1,2,3,0,1,2,3,0,1,2,3 and
    * so on.. So 
    * if previous grant happened to agent3, next grant should happen to
    * agent0,1,2,3 in that priority order
    * if previous grant happened to agent0, next grant should happen to 
    * agent1,2,3,0 in that priority order
    * if previous grant happened to agent1, next grant should happen to 
    * agent2,3,0,1 in that priority order
    * if previous grant happened to agent2, next grant should happen to 
    * agent3,0,1,2 in that priority order
    * */


   always @(*)
     begin
        arb_state_next = arb_state;
        gnt_next = gnt;
        gnt_hist_next = gnt_hist;


        case(arb_state)
          IDLE: begin
             case (1'b1)
               gnt_hist_next[3]: begin        // Priority order -- agent0, 1, 2, 3
                  if(req0) begin
                     arb_state_next = GNT0;
                     gnt_next = 4'b0001;
                  end
                  else if (req1) begin
                     arb_state_next = GNT1;
                     gnt_next = 4'b0010;
                  end
                  else if (req2) begin
                     arb_state_next = GNT2;
                     gnt_next = 4'b0100;
                  end
                  else if (req3) begin
                     arb_state_next = GNT3;
                     gnt_next = 4'b1000;
                  end
               end
               
               
               gnt_hist_next[0]: begin        // Priority order -- agent1, 2, 3, 0
                  if(req1) begin
                     arb_state_next = GNT1;
                     gnt_next = 4'b0010;
                  end
                  else if (req2) begin
                     arb_state_next = GNT2;
                     gnt_next = 4'b0100;
                  end
                  else if (req3) begin
                     arb_state_next = GNT3;
                     gnt_next = 4'b1000;
                  end
                  else if (req0) begin
                     arb_state_next = GNT0;
                     gnt_next = 4'b0001;
                  end
               end
               
               
               gnt_hist_next[1]: begin        // Priority order -- agent2, 3, 0, 1
                  if (req2) begin
                     arb_state_next = GNT2;
                     gnt_next = 4'b0100;
                  end
                  else if (req3) begin
                     arb_state_next = GNT3;
                     gnt_next = 4'b1000;
                  end
                  else if (req0) begin
                     arb_state_next = GNT0;
                     gnt_next = 4'b0001;
                  end
                  else if (req1) begin
                     arb_state_next = GNT1;
                     gnt_next = 4'b0010;
                  end
               end
               
               
               gnt_hist_next[2]: begin        // Priority order -- agent3, 0, 1, 2
                  if (req3) begin
                     arb_state_next = GNT3;
                     gnt_next = 4'b1000;
                  end
                  else if (req0) begin
                     arb_state_next = GNT0;
                     gnt_next = 4'b0001;
                  end
                  else if (req1) begin
                     arb_state_next = GNT1;
                     gnt_next = 4'b0010;
                  end
                  else if (req2) begin
                     arb_state_next = GNT2;
                     gnt_next = 4'b0100;
                  end
               end
               
               
               default: begin
               end


             endcase
          end


          /* For the following arbiter states, GNT0, .. GNT3, the
           * arbiter_next_state is set to be IDLE. This would mean that after
           * the agent sends an eot, the state machine would enter an IDLE
           * state for one cycle. In IDLE state, depending on the recently
           * granted agent history and request status, the next grant would
           * happen. This would simplify the state machine significantly. A more
           * complicated approach would have involved repeating the whole logic in
           * IDLE state even in GNT0,...GNT3 states. So even though it leads to
           * a 1 cycle lag in decision making, this is cheapter from hardware
           * perspective. */


          GNT0: begin
             if(eot0) begin
                arb_state_next = IDLE;  
                gnt_next = 'd0;
                gnt_hist_next = 4'b0001;
             end
          end
          
          
          GNT1: begin
             if(eot1) begin
                arb_state_next = IDLE;
                gnt_next = 'd0;
                gnt_hist_next = 4'b0010;
             end
          end
          
          
          GNT2: begin
             if(eot2) begin
                arb_state_next = IDLE;
                gnt_next = 'd0;
                gnt_hist_next = 4'b0100;
             end
          end
          
          
          GNT3: begin
             if(eot3) begin
                arb_state_next = IDLE;
                gnt_next = 'd0;
                gnt_hist_next = 4'b1000;
             end
          end


          default: begin
          end
        endcase
     end
endmodule