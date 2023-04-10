class gen_arb_item extends uvm_sequence;
  `uvm_object_utils(gen_arb_item)
  
  function new(string str="gen_arb_item");
    super.new(str);
  endfunction
  
  rand int num;
  constraint c1 {num==2;}
  
  virtual task body();
    for(int i=0; i<num ;i++)
      begin
        arb_item m_item=arb_item::type_id::create("m_item");
       // start_item(m_item);
        wait_for_grant();
        m_item.randomize();
        `uvm_info("Seq",$sformatf(" Time=%0t Packet=%0d Generate new item:",$time,(i+1)),UVM_LOW)
        m_item.print();
        send_request(m_item);
        wait_for_item_done();
        //finish_item(m_item);
      end
    `uvm_info("Seq",$sformatf(" Done Generation of %0d",num),UVM_LOW)
  endtask
endclass