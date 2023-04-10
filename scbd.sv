class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
   arb_item pkt_qu[$];
  
  function new(string str="scoreboard",uvm_component p=null);
    super.new(str,p);
  endfunction
  
  uvm_analysis_imp#(arb_item,scoreboard) m_analysis_imp;
  
  int     no_transactions,i,j;
  bit [3:0]gnt_history;
  bit [3:0]gnt_actual,gnt_expected;
  bit[3:0]req;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp=new("m_analysis_imp",this);
     gnt_history = 4'b1000;
    i = 0;
    j = 0;
  endfunction
  
  virtual function write (arb_item item);
    $display("scbd item");
    item.print();
    pkt_qu.push_back(item);
  endfunction : write
  
    //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    arb_item item;
    
    forever begin
      wait(pkt_qu.size() > 0);
      item = pkt_qu.pop_front();
    
       gnt_actual = {item.gnt3,item.gnt2,item.gnt1,item.gnt0};
       req = {item.req3,item.req2,item.req1,item.req0};
    
    
      if(req == 4'b0)begin
      gnt_history = 4'b1000;
      gnt_expected = 4'b0000;
      //$display("gnt_history = %0d",gnt_history);
        `uvm_info("SCBD",$sformatf("gnt_history = %0d",gnt_history),UVM_INFO)
  
    end
       
          case(1'b1)
          gnt_history[3]: begin// Priority order -- agent0, 1, 2, 3
                  if(item.req0) begin
                     gnt_expected = 4'b0001;
                     gnt_history = 4'b0001;
                  end
                  else if (item.req1) begin
                     gnt_expected = 4'b0010;
                     gnt_history = 4'b0010;
                  end
                  else if (item.req2) begin
                     gnt_expected = 4'b0100;
                     gnt_history = 4'b0100;
                  end
                  else if (item.req3) begin
                     gnt_expected = 4'b1000;
                     gnt_history = 4'b1000;
                  end
               end
               
               
    gnt_history[0]: begin  // Priority order -- agent1, 2, 3, 0
                  if(item.req1) begin
                     gnt_expected = 4'b0010;
                     gnt_history = 4'b0010;
                  end
                  else if (item.req2) begin
                     gnt_expected = 4'b0100;
                     gnt_history = 4'b0100;
                  end
                  else if (item.req3) begin
                     gnt_expected = 4'b1000;
                     gnt_history = 4'b1000;
                  end
                  else if (item.req0) begin
                     gnt_expected = 4'b0001;
                     gnt_history = 4'b0001;
                  end
               end
               
               
     gnt_history[1]: begin   // Priority order -- agent2, 3, 0, 1
                  if (item.req2) begin
                     gnt_expected = 4'b0100;
                     gnt_history = 4'b0100;
                  end
                  else if (item.req3) begin
                     gnt_expected = 4'b1000;
                     gnt_history = 4'b1000;
                  end
                  else if (item.req0) begin
                     gnt_expected = 4'b0001;
                     gnt_history = 4'b0001;
                  end
                  else if (item.req1) begin
                     gnt_expected = 4'b0010;
                     gnt_history = 4'b0010;
                  end
               end
               
               
   gnt_history[2]: begin   // Priority order -- agent3, 0, 1, 2
                  if (item.req3) begin
                     gnt_expected = 4'b1000;
                     gnt_history = 4'b1000;
                  end
                  else if (item.req0) begin
                     gnt_expected = 4'b0001;
                     gnt_history = 4'b0001;
                  end
                  else if (item.req1) begin
                     gnt_expected =4'b0010;
                     gnt_history = 4'b0010;
                  end
                  else if (item.req2) begin
                     gnt_expected = 4'b0100;
                     gnt_history = 4'b0100;
                  end
               end
               
               
               default: begin
               end


             endcase
    
       if(gnt_actual == gnt_expected)
      //$display("Recieved Grant = %0b and Expected Grant = %0b <<PASS>>",gnt_actual,gnt_expected);
      `uvm_info("SCBD",$sformatf("Recieved Grant = %0b and Expected Grant = %0b <<PASS>>",gnt_actual,gnt_expected),UVM_INFO)
     

   
    else
      `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
 
   //   `uvm_info("SCBD",$sformatf("Recieved Grant = %0b and Expected Grant = %0b <<FAIL>>",gnt_actual,gnt_expected),UVM_INFO)
      $display("***************************************************");
      
      if(gnt_actual == gnt_expected)
        i = i+1;
      else 
        j = j+1;
    
    //  no_transaction++;
    end
  /*            
    if((item.req0==1) & (item.eot3==1))
      begin
        if(item.gnt0==1)
          `uvm_info("SCBD",$sformatf("Pass Match GNT0 Found req0=%0b gnt0=%0b eot0=%0b ",item.req0,item.gnt0,item.eot0),UVM_INFO)
          else if((item.gnt0==0)&(item.req1==1))
            `uvm_info("SCBD",$sformatf("Pass Match 2nd Priority GNT1 Found req1=%0b gnt1=%0b eot1=%0b ",item.req1,item.gnt1,item.eot1),UVM_INFO)
            else if((item.gnt1==0)&(item.req2==1))
              `uvm_info("SCBD",$sformatf("Pass Match 3nd Priority GNT2 Found req2=%0b gnt2=%0b eot2=%0b ",item.req2,item.gnt2,item.eot2),UVM_INFO)
              else
                `uvm_info("SCBD","/////// No GNT Found  ////////",UVM_LOW)
      end
          
            if((item.req1==1) & (item.eot0==1))
       begin
        if(item.gnt1==1)
          `uvm_info("SCBD",$sformatf("Pass Match GNT1 Found req1=%0b gnt1=%0b eot1=%0b ",item.req1,item.gnt1,item.eot1),UVM_INFO)
          else
            `uvm_info("SCBD",$sformatf("Fail Match Not Found req1=%0b gnt1=%0b eot1=%0b ",item.req1,item.gnt1,item.eot1),UVM_INFO)
      end
     if((item.req2==1) & (item.eot1==1))
      begin
        if(item.gnt2==1)
          `uvm_info("SCBD",$sformatf("Pass Match GNT2 Found req2=%0b gnt2=%0b eot2=%0b ",item.req2,item.gnt2,item.eot2),UVM_INFO)
          else
            `uvm_info("SCBD",$sformatf("Fail Match Not Found req2=%0b gnt2=%0b eot2=%0b ",item.req2,item.gnt2,item.eot2),UVM_INFO)
      end
    if((item.req3==1) &  (item.eot2==1))
      begin
        if(item.gnt3==1)
          `uvm_info("SCBD",$sformatf("Pass Match GNT3 Found req3=%0b gnt3=%0b eot3=%0b ",item.req3,item.gnt3,item.eot3),UVM_INFO)
          else
          `uvm_info("SCBD",$sformatf("Fail Match Not Found req3=%0b gnt3=%0b eot3=%0b ",item.req3,item.gnt3,item.eot3),UVM_INFO)
      end      */
      
      endtask
           
  
endclass