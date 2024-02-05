module mar(
	input clk,
	input reset,
	input ctrl_mi,
	input [7:0] bus,
	output reg[3:0] mar = 0);
	
always @(posedge clk or posedge reset) begin
	if (reset)
		mar <= 0;
	else if (ctrl_mi)
		mar <= bus[3:0];
end

endmodule