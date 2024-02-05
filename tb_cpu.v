`timescale 1ns/100ps
module tb_cpu();

reg clock = 0;
initial repeat (10000) #1 clock = ~clock;

reg reset = 1;
wire [7:0] outt = 0;

cpu m0(
	.clk(clock),
	.reset(reset),
	.out(outt));
	
initial begin
#100 reset = 0;
end

endmodule