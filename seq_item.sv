class arb_item extends uvm_sequence_item;
  randc bit req0;
  randc bit req1;
  randc bit req2;
  randc bit req3;
  bit eot0;
  bit eot1;
  bit eot2;
  bit eot3;
  bit gnt0;
  bit gnt1;
  bit gnt2;
  bit gnt3;
  
  `uvm_object_utils_begin(arb_item)
  `uvm_field_int(req0,UVM_DEFAULT)
  `uvm_field_int(req1,UVM_DEFAULT)
  `uvm_field_int(req2,UVM_DEFAULT)
  `uvm_field_int(req3,UVM_DEFAULT)
  `uvm_field_int(eot0,UVM_DEFAULT)
  `uvm_field_int(eot1,UVM_DEFAULT)
  `uvm_field_int(eot2,UVM_DEFAULT)
  `uvm_field_int(eot3,UVM_DEFAULT)
  `uvm_field_int(gnt0,UVM_DEFAULT)
  `uvm_field_int(gnt1,UVM_DEFAULT)
  `uvm_field_int(gnt2,UVM_DEFAULT)
  `uvm_field_int(gnt3,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new(string str="arb_item");
    super.new(str);
  endfunction
  
endclass
  
  
  
 