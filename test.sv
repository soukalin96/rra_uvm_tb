`include "env.sv"
class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(string str="test",uvm_component p=null);
    super.new(str,p);
  endfunction
  
  virtual arb_if vif;
  env e0;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e0=env::type_id::create("e0",this);
    
    if(!uvm_config_db#(virtual arb_if)::get(this,"","arb_if",vif))
      `uvm_fatal("Test","Did not get vif")
      
     // argument "e0.a0.* error
      uvm_config_db#(virtual arb_if)::set(this,"e0.a0.*","arb_if",vif);
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    gen_arb_item seq=gen_arb_item::type_id::create("seq");
    phase.raise_objection(this);
    apply_reset();
    seq.randomize();
    seq.start(e0.a0.s0);
    phase.drop_objection(this);
  endtask
  
  virtual task apply_reset();
    vif.rstn<=0;
    repeat(2)@(posedge vif.clk);
    vif.rstn<=1;
    @(posedge vif.clk);
  endtask

endclass
  
       
    