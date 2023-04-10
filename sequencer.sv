class sequencer extends uvm_sequencer#(arb_item);

  `uvm_component_utils(sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string str="sequencer", uvm_component parent);
    super.new(str,parent);
  endfunction
  
endclass