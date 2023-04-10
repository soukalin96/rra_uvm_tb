interface arb_if(input bit clk);
  logic rstn;
  logic req0;
  logic req1;
  logic req2;
  logic req3;
  logic gnt0;
  logic gnt1;
  logic gnt2;
  logic gnt3;
  logic eot0;
  logic eot1;
  logic eot2;
  logic eot3;
  
    //driver clocking block
  clocking driver_cb @(posedge clk);
    default input #1 output #1; 
    output 		 req0; 
    output 		 req1;
    output  req2;
    output 		 req3;
    input          gnt0;
    input           gnt1;
    input          gnt2;
    input           gnt3;
    output 		 eot0;
    output 		  eot1;
    output 		 eot2;
    output  		 eot3; 
  endclocking
  
  //monitor clocking block
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input          req0;
    input 		 req1;
    input  		 req2;
    input 		 req3;
    input          gnt0;
    input           gnt1;
    input          gnt2;
    input           gnt3;
    input 		 eot0;
    input 		  eot1;
    input 		 eot2;
    input  		 eot3;
  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input clk,rstn);
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input clk,rstn);
  
endinterface
  