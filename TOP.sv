`include "INTERFACE.sv"
`include "DUT.sv"
`include "TEST.sv"

module TOP_sram();
bit clk;
initial
begin
clk=0;
forever #5clk=~clk;
end
intif infc(clk);
DUT dut(infc);
test tb(infc);

endmodule
