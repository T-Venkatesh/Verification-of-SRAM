`ifndef _Mon_
`define _Mon_
`include "BASE PKT.sv"
class monitor;
basepkt pkt;
mailbox mon2sb;
virtual intif inf;
extern function new(basepkt pkt,mailbox mon2sb,virtual intif inf);
extern task run();
endclass

function monitor::new(basepkt pkt,mailbox mon2sb,virtual intif inf);
this.pkt=pkt;
this.mon2sb=mon2sb;
this.inf=inf;
endfunction

task monitor::run();
begin
while(1)
begin
@(posedge inf.clk);
pkt.en=inf.en;
pkt.wr=inf.wr;
begin
if((pkt.en==1)&&(pkt.wr==0))
begin
pkt.addr=inf.addr;
pkt.data_out=inf.data_out;
mon2sb.put(pkt);
$display($time,"monitor: read addr=%d dataout=%d",pkt.addr,pkt.data_out);
end
end
end
end
endtask
`endif

