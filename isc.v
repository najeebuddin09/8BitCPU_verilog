module isc(
	input clk,
	input reset,
	input ctrl_ht,
	input ctrl_jp,
	output reg[2:0] stage = 0);
	
always @(posedge clk or posedge reset) begin
	if (reset)
		stage <= 0;
	else if (stage == 5 || ctrl_jp)
		stage <= 0;
	else if (ctrl_ht || stage == 6)
		// For a halt, put it into a stage it can never get out of
		stage <= 6;
	else
		stage <= stage + 1;
end

endmodule