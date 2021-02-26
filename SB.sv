`ifndef _sb_
`define _sb_
`include "BASE PKT.sv"
class scoreboard;
bit [7:0]mem[0:63];
basepkt pkt1,pkt2;
mailbox tx2sb,mon2sb;

function new(basepkt pkt1,pkt2,mailbox tx2sb,mon2sb);
this.pkt1=pkt1;
this.pkt2=pkt2;
this.tx2sb=tx2sb;
this.mon2sb=mon2sb;
endfunction

extern task run();
extern task rcvd();
extern task expctd();
endclass

task scoreboard::run();
$display($time,"scoreboard::run phase");
fork
rcvd();
expctd();

join_none
endtask

task scoreboard::expctd();
while(1)
begin
tx2sb.get(pkt1);
$display("pkt1=%p",pkt1);
if(pkt1.wr==1)
begin
mem[pkt1.addr]=pkt1.data_in; // pkt1 from TXGEN
end
end
endtask

task scoreboard::rcvd();
while(1)
begin
mon2sb.get(pkt2);
$display("pkt2=%p",pkt2);   //PKT2 FROM MONITOR
if(pkt2.data_out!=mem[pkt2.addr])
$display($time,"scoreboard---->MISMATCHED, pkt2.addr=%p,pkt2.data_out=%p",pkt2.addr,pkt2.data_out);
else
$display($time,"scoreboard---->MATCHED, pkt2.addr=%p,pkt2.data_out=%p",pkt2.addr,pkt2.data_out);
end
endtask
`endif
