`include "agent.sv"
`include "scbd.sv"
class env extends uvm_env;
  
  `uvm_component_utils(env)
    
  function new(string str="env",uvm_component p);
    super.new(str,p);
  endfunction
    
  agent a0;
  scoreboard sb0;
    
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0=agent::type_id::create("a0",this);
    sb0=scoreboard::type_id::create("sb0",this);
  endfunction
    
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.mon_analysis_port.connect(sb0.m_analysis_imp);
  endfunction
  
endclass