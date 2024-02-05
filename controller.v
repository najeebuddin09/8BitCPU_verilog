module controller(
	input clk,
	input [7:0]ir,
	input [2:0] stage,
	input [1:0] flags,
	output reg ctrl_ai=0,
	output reg ctrl_ao=0,
	output reg ctrl_bi=0,
	output reg ctrl_ce=0,
	output reg ctrl_co=0,
	output reg ctrl_eo=0,
	output reg ctrl_fi=0,
	output reg ctrl_ht=0,
	output reg ctrl_ii=0,
	output reg ctrl_io=0,
	output reg ctrl_jp=0,
	output reg ctrl_mi=0,
	output reg ctrl_oi=0,
	output reg ctrl_ri=0,
	output reg ctrl_ro=0,
	output reg ctrl_su=0);

parameter OP_NOP = 4'b0000;
parameter OP_LDA = 4'b0001;
parameter OP_ADD = 4'b0010;
parameter OP_SUB = 4'b0011;
parameter OP_STA = 4'b0100;
parameter OP_LDI = 4'b0101;
parameter OP_JMP = 4'b0110;
parameter OP_JC  = 4'b0111;
parameter OP_JZ  = 4'b1000;
parameter OP_OUT = 4'b1110;
parameter OP_HLT = 4'b1111;


// Halt
always @(negedge clk) begin
	if (ir[7:4] == OP_HLT && stage == 2)
		ctrl_ht <= 1;
	else
		ctrl_ht <= 0;
end

// Memory Address Register In
always @(negedge clk) begin
	if (stage == 0)
		ctrl_mi <= 1;
	else if (ir[7:4] == OP_LDA && stage == 2)
		ctrl_mi <= 1;
	else if (ir[7:4] == OP_ADD && stage == 2)
		ctrl_mi <= 1;
	else if (ir[7:4] == OP_SUB && stage == 2)
		ctrl_mi <= 1;
	else if (ir[7:4] == OP_STA && stage == 2)
		ctrl_mi <= 1;
	else
		ctrl_mi <= 0;
end

// RAM In
always @(negedge clk) begin
	if (ir[7:4] == OP_STA && stage == 3)
		ctrl_ri <= 1;
	else
		ctrl_ri <= 0;
end

// RAM Out
always @(negedge clk) begin
	if (stage == 1)
		ctrl_ro <= 1;
	else if (ir[7:4] == OP_LDA && stage == 3)
		ctrl_ro <= 1;
	else if (ir[7:4] == OP_ADD && stage == 3)
		ctrl_ro <= 1;
	else if (ir[7:4] == OP_SUB && stage == 3)
		ctrl_ro <= 1;
	else
		ctrl_ro <= 0;
end

// Instruction Register Out
always @(negedge clk) begin
	if (ir[7:4] == OP_LDA && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_LDI && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_ADD && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_SUB && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_STA && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_JMP && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_JC && stage == 2)
		ctrl_io <= 1;
	else if (ir[7:4] == OP_JZ && stage == 2)
		ctrl_io <= 1;
	else
		ctrl_io <= 0;
end

// Instruction Register In
always @(negedge clk) begin
	if (stage == 1)
		ctrl_ii <= 1;
	else
		ctrl_ii <= 0;
end

// A Register In
always @(negedge clk) begin
	if (ir[7:4] == OP_LDI && stage == 2)
		ctrl_ai <= 1;
	else if (ir[7:4] == OP_LDA && stage == 3)
		ctrl_ai <= 1;
	else if (ir[7:4] == OP_ADD && stage == 4)
		ctrl_ai <= 1;
	else if (ir[7:4] == OP_SUB && stage == 4)
		ctrl_ai <= 1;
	else
		ctrl_ai <= 0;
end

// A Register Out
always @(negedge clk) begin
	if (ir[7:4] == OP_STA && stage == 3)
		ctrl_ao <= 1;
	else if (ir[7:4] == OP_OUT && stage == 2)
		ctrl_ao <= 1;
	else
		ctrl_ao <= 0;
end

// Sum Out
always @(negedge clk) begin
	if (ir[7:4] == OP_ADD && stage == 4)
		ctrl_eo <= 1;
	else if (ir[7:4] == OP_SUB && stage == 4)
		ctrl_eo <= 1;
	else
		ctrl_eo <= 0;
end

// Subtract
always @(negedge clk) begin
	if (ir[7:4] == OP_SUB && stage == 4)
		ctrl_su <= 1;
	else
		ctrl_su <= 0;
end

// B Register In
always @(negedge clk) begin
	if (ir[7:4] == OP_ADD && stage == 3)
		ctrl_bi <= 1;
	else if (ir[7:4] == OP_SUB && stage == 3)
		ctrl_bi <= 1;
	else
		ctrl_bi <= 0;
end

// Output Register In
always @(negedge clk) begin
	if (ir[7:4] == OP_OUT && stage == 2)
		ctrl_oi <= 1;
	else
		ctrl_oi <= 0;
end

// Counter Enable
always @(negedge clk) begin
	if (stage == 1)
		ctrl_ce <= 1;
	else
		ctrl_ce <= 0;
end

// Counter Out
always @(negedge clk) begin
	// Always in Stage 0
	if (stage == 0)
		ctrl_co <= 1;
	else
		ctrl_co <= 0;
end

// Jump
always @(negedge clk) begin
	if (ir[7:4] == OP_JMP && stage == 2)
		ctrl_jp <= 1;
	else if (ir[7:4] == OP_JC && stage == 2 && flags[1] == 1)
		ctrl_jp <= 1;
	else if (ir[7:4] == OP_JZ && stage == 2 && flags[0] == 1)
		ctrl_jp <= 1;
	else
		ctrl_jp <= 0;
end

// Flags Register In
always @(negedge clk) begin
	if (ir[7:4] == OP_ADD && stage == 4)
		ctrl_fi <= 1;
	else if (ir[7:4] == OP_SUB && stage == 4)
		ctrl_fi <= 1;
	else
		ctrl_fi <= 0;
end

endmodule