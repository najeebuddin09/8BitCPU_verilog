module ir(
	input clk,
	input reset,
	input ctrl_ii,
	input [7:0] bus,
	output reg[7:0] ir = 0);
	
always @(posedge clk or posedge reset) begin
	if (reset)
		ir <= 0;
	else if (ctrl_ii)
		ir <= bus;
end

endmodule