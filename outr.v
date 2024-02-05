module outr(
	input clk,
	input reset,
	input ctrl_oi,
	input [7:0] bus,
	output reg [7:0] out = 0);
	
always @(posedge clk or posedge reset) begin
	if (reset)
		out <= 0;
	else if (ctrl_oi)
		out <= bus;
end

endmodule