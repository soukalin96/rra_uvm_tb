`define DRIV_IF vif.DRIVER.driver_cb
class driver extends uvm_driver#(arb_item);
  
  `uvm_component_utils(driver)
  
  function new(string str="driver",uvm_component p=null);
    super.new(str,p);
  endfunction
  
  virtual arb_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual arb_if)::get(this,"","arb_if",vif))
      `uvm_error("DRV","Could not get vif")
      
   endfunction
      
   virtual task run_phase(uvm_phase phase);
   super.run_phase(phase);
  reset();
    forever
      begin
        arb_item m_item;
        `uvm_info("DRV"," Wait for item from Sequencer",UVM_LOW)
        seq_item_port.get_next_item(m_item);
       // m_item.print();
       
        drive(m_item);
        seq_item_port.item_done();
      end
    endtask
    
    virtual task reset();
      wait(!vif.rstn);
      vif.req0<=0;
      vif.req1<=0;
      vif.req2<=0;
      vif.req3<=0;
      vif.eot0<=0;
      vif.eot1<=0;
      vif.eot2<=0;
      vif.eot3<=0;
       wait(vif.rstn);
      $display("waiting for reset completed"); 
    endtask
    
    virtual task drive(arb_item m_item);
      
      fork
        drive_a0(m_item);
        drive_a1(m_item);
        drive_a2(m_item);
        drive_a3(m_item);
      join
      
    endtask
       
    virtual task drive_a0(arb_item m_item);
      if(m_item.req0==1)
        begin
          `DRIV_IF.req0<=m_item.req0;
          if(m_item.req0==1);
          @(posedge vif.DRIVER.clk);
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot0<=1;
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot0<=0;
          `DRIV_IF.req0<=0;
        end
    endtask
    
    virtual task drive_a1(arb_item m_item);
      if(m_item.req1==1)
        begin
         `DRIV_IF.req1<=m_item.req1;
          if(m_item.req1==1);
          @(posedge vif.DRIVER.clk);
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot1<=1;
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot1<=0;
          `DRIV_IF.req1<=0;
        end
    endtask
    
    virtual task drive_a2(arb_item m_item);
      if(m_item.req2==1)
        begin
          `DRIV_IF.req2<=m_item.req2;
          if(m_item.req2);
          @(posedge vif.DRIVER.clk);
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot2<=1;
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot2<=0;
          `DRIV_IF.req2<=0;
        end
    endtask
    
    virtual task drive_a3(arb_item m_item);
      if(m_item.req3==1)
        begin
          `DRIV_IF.req3<=m_item.req3;
          if(m_item.req3);
          @(posedge vif.DRIVER.clk);
          @(posedge vif.DRIVER.clk);																																				
          `DRIV_IF.eot3<=1;
          @(posedge vif.DRIVER.clk);
          `DRIV_IF.eot3<=0;
          `DRIV_IF.req3<=0;
        end
    endtask
      
      
    
endclass
      
      
      
        
      