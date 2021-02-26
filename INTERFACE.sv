interface intif(input clk);
logic en;
logic wr;
logic [7:0]data_in;
logic [5:0]addr;
logic [7:0]data_out;

clocking cb@(posedge clk);
default input #1ns output #1ns;
endclocking 


modport dut(input clk,en,wr,data_in,addr,output data_out);
modport tb(output en,wr,data_in,addr,input clk,data_out);
endinterface

