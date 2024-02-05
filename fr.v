module fr(
	input clk,
	input reset,
	input ctrl_fi,
	input flag_c,
	input flag_z,
	output reg [1:0] flags = 0);
	
always @(posedge clk or posedge reset) begin
	if (reset)
		flags <= 0;
	else if (ctrl_fi)
		flags <= {flag_c, flag_z};
end

endmodule