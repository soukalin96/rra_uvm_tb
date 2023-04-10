// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "test.sv"

module tb_top;
  
 bit clk;
  always #5 clk<= ~clk;
  
  arb_if if1(clk);
  rrarbiter a1 (.clk(clk),
                .rstn(if1.rstn),
                .req0(if1.req0),
                .req1(if1.req1),
                .req2(if1.req2),
                .req3(if1.req3),
                .gnt0(if1.gnt0),
                .gnt1(if1.gnt1),
                .gnt2(if1.gnt2),
                .gnt3(if1.gnt3),
                .eot0(if1.eot0),
                .eot1(if1.eot1),
                .eot2(if1.eot2),
                .eot3(if1.eot3));
  initial
    begin
      uvm_config_db#(virtual arb_if)::set(null,"uvm_test_top","arb_if",if1);
      run_test("test");
    end
  

 initial begin 
    $dumpfile("dump.vcd"); 
   $dumpvars(0,a1);

end
  
  endmodule
                