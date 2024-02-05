module alu(
	input clk,
	input reset,
	input ctrl_ai,
	input ctrl_bi,
	input ctrl_su,
	input [7:0] bus,
	output wire flag_c,
	output wire flag_z,
	output reg[7:0] a_reg = 0,
	output wire [8:0] alu);
	
reg[7:0] b_reg;
wire[7:0] b_reg_out;
always @(posedge clk or posedge reset) begin
	if (reset)
		a_reg <= 0;
	else if (ctrl_ai)
		a_reg <= bus;
end

always @(posedge clk or posedge reset) begin
	if (reset)
		b_reg <= 0;
	else if (ctrl_bi)
		b_reg <= bus;
end

// Zero flag is set if ALU is zero
assign flag_z = (alu[7:0] == 0) ? 1 : 0;

// Use twos-complement for subtraction
assign b_reg_out = ctrl_su ? ~b_reg + 1 : b_reg;

// Carry flag is set if there's an overflow into bit 8 of the ALU
assign flag_c = alu[8];

assign alu = a_reg + b_reg_out;

endmodule