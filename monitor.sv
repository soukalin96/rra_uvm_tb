`define MON_IF vif.MONITOR.monitor_cb

class monitor extends uvm_monitor;
  
  
  uvm_analysis_port #(arb_item) mon_analysis_port;
  
  virtual arb_if vif;
  
  //---------------------------------------
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  arb_item item;
  `uvm_component_utils(monitor)
  
  
  function new(string str="monitor",uvm_component p=null);
    super.new(str,p);
    item = new();
     mon_analysis_port = new("mon_analysis_port", this);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual arb_if)::get(this,"","arb_if",vif))
      `uvm_error("Mon","Could not get vif")         
  endfunction
      
      
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever
      begin
        
        item=arb_item::type_id::create("item",this);
        
          @(posedge vif.MONITOR.clk);
     wait(`MON_IF.req0 || `MON_IF.req1 || `MON_IF.req2 || `MON_IF.req3);
        item.req0     = `MON_IF.req0;
        item.req1     = `MON_IF.req1;
        item.req2     = `MON_IF.req2;
        item.req3     = `MON_IF.req3;
        $display("monitor - req0 = %0b,  req1 = %0b,  req2 = %0b,  req3 = %0b", item.req0, item.req1, item.req2, item.req3);
     @(posedge vif.MONITOR.clk);
        wait(`MON_IF.gnt0 || `MON_IF.gnt1 || `MON_IF.gnt2 || `MON_IF.gnt3);
        item.gnt0     = `MON_IF.gnt0;
        item.gnt1     = `MON_IF.gnt1;
        item.gnt2     = `MON_IF.gnt2;
        item.gnt3     = `MON_IF.gnt3;
        $display("monitor - gnt0 = %0b,  gnt1 = %0b,  gnt2 = %0b,  gnt3 = %0b", item.gnt0, item.gnt1, item.gnt2, item.gnt3);
      @(posedge vif.MONITOR.clk);
      	item.eot0     = `MON_IF.eot0;
        item.eot1     = `MON_IF.eot1;
        item.eot2     = `MON_IF.eot2;
     	item.eot3     = `MON_IF.eot3;
        	@(posedge vif.MONITOR.clk);
        mon_analysis_port.write(item);
        
      

	//@(posedge vif.MONITOR.clk);
        
        /*fork
          begin
            wait(vif.req0==1);
          	      begin
                  @(posedge vif.clk);
                  if(vif.eot0==1)
                  begin
            	   	item=arb_item::type_id::create("item",this);
                    item.req0=vif.req0;
                    item.gnt0=vif.gnt0;
                    item.eot0=vif.eot0;
                    `uvm_info("MONITOR", $psprintf("Got Agent0 Transaction %s",item.convert2string()),UVM_NONE);
                  end
                 end
          end
          
          begin
            wait(vif.req1==1);
            @(posedge vif.clk);
            if(vif.gnt1==1)
          		begin
                  @(posedge vif.clk);
                  if(vif.eot1==1)
                    begin
            	  item=arb_item::type_id::create("item",this);
                  item.req1=vif.req1;
                  item.gnt1=vif.gnt1;
                  item.eot1=vif.eot1;
            	  `uvm_info("MONITOR", $psprintf("Got Agent1 Transaction %s",item.convert2string()),UVM_NONE);
                  end
                end
           end
          
          begin
            wait(vif.req2==1);
            @(posedge vif.clk);
            if(vif.gnt2==1)
          		begin
                  @(posedge vif.clk);
                  if(vif.eot2==1)
                    begin
            	  item=arb_item::type_id::create("item",this);
                  item.req2=vif.req2;
                  item.gnt2=vif.gnt2;
                  item.eot2=vif.eot2;
            	`uvm_info("MONITOR", $psprintf("Got Agent2 Transaction %s",item.convert2string()),UVM_NONE);
                   end
                end
            
          end
        
          begin
            wait(vif.req3==1);
            @(posedge vif.clk);
            if(vif.gnt3==1)
              begin
                  @(posedge vif.clk);
                  if(vif.eot3==1)
                    begin
            	  item=arb_item::type_id::create("item",this);
                  item.req3=vif.req3;
                  item.gnt3=vif.gnt3;
                  item.eot3=vif.eot3;
            	`uvm_info("MONITOR", $psprintf("Got Agent3 Transaction 	%s",item.convert2string()),UVM_NONE);
                    end
                end
          end
        join_any */
       
        
      end
  endtask
endclass                  
  
  