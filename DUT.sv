module DUT(intif.dut infc);
logic [7:0]mem[0:63];
always@(posedge infc.clk)
begin
if(infc.en==0)
infc.data_out<=8'b0;
else if(infc.wr==1)
mem[infc.addr]<=infc.data_in;
else if(infc.wr==0)
infc.data_out<=mem[infc.addr];
end



endmodule

