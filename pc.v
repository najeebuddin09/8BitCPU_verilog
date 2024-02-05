module pc(
	input clk,
	input reset,
	input ctrl_ce,
	input ctrl_jp,
	input [7:0] bus,
	output reg [3:0] pc = 0);
	
always @(posedge clk or posedge reset) begin
	if (reset)
		pc <= 0;
	else if (ctrl_ce)
		pc <= pc + 1;
	else if (ctrl_jp)
		pc <= bus[3:0];
end

endmodule