
`ifndef _drv_
`define _drv_
`include "BASE PKT.sv"

class driver;
basepkt pkt;
mailbox tx2drv;
virtual intif inf;
extern function new(basepkt pkt,mailbox tx2drv,virtual intif inf);
extern  task run();
endclass

function driver::new(basepkt pkt,mailbox tx2drv,virtual intif inf);
this.pkt=pkt;
this.tx2drv=tx2drv;
this.inf=inf;
endfunction

task driver::run();
while(1)
begin
@(posedge inf.clk);
tx2drv.get(pkt);
pkt.en=1'b1;
inf.en=pkt.en;
begin

if(pkt.wr==1)
begin
inf.wr=pkt.wr;
inf.addr=pkt.addr;
inf.data_in=pkt.data_in;
$display($time,"driver:wrtten pkt.wr=%b,pkt.addr=%d,pkt.datain=%d",pkt.wr,pkt.addr,pkt.data_in);
end
else
begin
inf.wr=pkt.wr;
inf.addr=pkt.addr;
$display($time,"driver:wrtten pkt.wr=%b,pkt.addr=%d",pkt.wr,pkt.addr);
end
end

end
endtask
`endif

