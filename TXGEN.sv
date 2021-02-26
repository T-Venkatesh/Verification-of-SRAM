`ifndef _txgen_  
`define _txgen_
`include "BASE PKT.sv"
`include "CFG.sv"

class txgen;
basepkt pkt;
mailbox tx2drv,tx2sb;
configuration cfg;
bit[7:0]datainout;
bit[7:0]addrinout;
int i;
int j;

extern function new(basepkt pkt,mailbox tx2drv,tx2sb,configuration cfg);
extern task run();
extern function bit[7:0]calc_addr(configuration cfg);
extern function bit[7:0]calc_datain(configuration cfg);
endclass

function txgen::new(basepkt pkt,mailbox tx2drv,tx2sb,configuration cfg);
this.pkt=pkt;
this.tx2drv=tx2drv;
this.tx2sb=tx2sb;
this.cfg=cfg;
this.datainout=cfg.txdata;
this.addrinout=cfg.txaddr;
i=0;
j=0;
endfunction


task txgen::run();
begin
$display($time, "TXGEN::RUN PHASE");
repeat(cfg.num_txns)
begin
  case(cfg.cmd)


BURST_WR:
    repeat(20)
    begin
      
    pkt.addr=calc_addr(cfg);
    pkt.data_in=calc_datain(cfg);
    pkt.wr=1'b1;
    tx2drv.put(pkt);
    tx2sb.put(pkt);
    end

BURST_RD:
  repeat(8)
  begin
 
  pkt.addr=calc_addr(cfg);
  pkt.wr=1'b0;
  tx2drv.put(pkt);
  tx2sb.put(pkt);
  $display($time,"generated basepkt=%p",pkt);
end

WR_RD:
   repeat(10)
   begin
#10;
begin
     
    pkt.addr=calc_addr(cfg);
    pkt.data_in=calc_datain(cfg);
    pkt.wr=1'b1;
    tx2drv.put(pkt);
    tx2sb.put(pkt);
 #10; 
  
    pkt.wr=1'b0;
    tx2drv.put(pkt);
   tx2sb.put(pkt);
end

//$display($time,"RD_TX1::pkt.wr=%b, pkt.addr=%p pkt.data_in=%p",pkt.wr, pkt.addr,pkt.data_in);
   
 end
endcase
end
end
endtask

function bit[7:0]txgen::calc_addr(configuration cfg);
begin
 case(cfg.addr1)
random:begin addrinout=$random; return addrinout;end                                                                                                    
constant_addr:begin return addrinout;end
incremental:begin  return addrinout++;end
decremental:begin return addrinout--;end
userpattern:begin addrinout=cfg.user_addr[i++];return addrinout;end
endcase
end
endfunction

 
 

function bit[7:0]txgen::calc_datain(configuration cfg);
begin
 case(cfg.data1)
random1:begin datainout=$random; return datainout;end                                                                                                    
constant_data:begin return datainout;end
incremental1:begin  return datainout++;end
decremental1:begin return datainout--;end
userpattern1:begin datainout=cfg.user_data[j++];return datainout;end
endcase
end
endfunction
`endif

 
 





