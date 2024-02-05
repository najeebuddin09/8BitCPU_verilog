module cpu(
	input wire fclk,
	input wire reset,
	output wire [7:0] out
	);
	
wire clk;

clkdiv #(500000) mclk(.fastClk(fclk), .slowClk(clk));
	
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

wire ctrl_ai;
wire ctrl_ao;	// put register A on bus
wire ctrl_bi;	// read from bus into B register
wire ctrl_ce;	// increment PC
wire ctrl_co;	// put PC on bus
wire ctrl_eo;
wire ctrl_fi;
wire ctrl_ht;
wire ctrl_ii;
wire ctrl_io;	// put operand of IR on bus
wire ctrl_jp;
wire ctrl_mi;	// memory in from bus
wire ctrl_oi;	// read from bus into out register
wire ctrl_ri;
wire ctrl_ro;	// put memory pointed by mar on bus
wire ctrl_su;

wire [3:0] pc;
wire [7:0] ir;
wire [3:0] mar;
wire [8:0] alu;
wire [1:0] flags;
wire [2:0] stage;
wire [7:0] a_reg;

wire flag_c;
wire flag_z;

reg[7:0] mem[16];

wire[7:0] bus;
assign bus =
	ctrl_co ? pc :
	ctrl_ro ? mem[mar] :
	ctrl_io ? ir[3:0] :
	ctrl_ao ? a_reg :
	ctrl_eo ? alu :
	8'b0;

initial begin
	mem[0]  = {OP_OUT, 4'b0};
	mem[1]  = {OP_ADD, 4'hF};
	mem[2]  = {OP_JC,  4'h4};
	mem[3]  = {OP_JMP, 4'h0};
	mem[4]  = {OP_SUB, 4'hF};
	mem[5]  = {OP_OUT, 4'h0};
	mem[6]  = {OP_JZ,  4'h0};
	mem[7]  = {OP_JMP, 4'h4};
	mem[8]  = {OP_NOP, 4'h0};
	mem[9]  = {OP_NOP, 4'h0};
	mem[10] = {OP_NOP, 4'h0};
	mem[11] = {OP_NOP, 4'h0};
	mem[12] = {OP_NOP, 4'h0};
	mem[13] = {OP_NOP, 4'h0};
	mem[14] = {OP_NOP, 4'h0};
	mem[15] = {8'h01};        // DATA = 1
end	

always @(posedge clk) begin
	if (ctrl_ri)
		mem[mar] <= bus;
end
	
pc pc0(
	.clk(clk),
	.reset(reset),
	.ctrl_ce(ctrl_ce),
	.ctrl_jp(ctrl_jp),
	.bus(bus),
	.pc(pc));

ir ir0(
	.clk(clk),
	.reset(reset),
	.ctrl_ii(ctrl_ii),
	.bus(bus),
	.ir(ir));
	
mar mar0(
	.clk(clk),
	.reset(reset),
	.ctrl_mi(ctrl_mi),
	.bus(bus),
	.mar(mar));
	
outr outr0(
	.clk(clk),
	.reset(reset),
	.ctrl_oi(ctrl_oi),
	.bus(bus),
	.out(out));
	
alu alu0(
	.clk(clk),
	.reset(reset),
	.ctrl_ai(ctrl_ai),
	.ctrl_bi(ctrl_bi),
	.ctrl_su(ctrl_su),
	.bus(bus),
	.flag_c(flag_c),
	.flag_z(flag_z),
	.a_reg(a_reg),
	.alu(alu));
	
fr fr0(
	.clk(clk),
	.reset(reset),
	.ctrl_fi(ctrl_fi),
	.flag_c(flag_c),
	.flag_z(flag_z),
	.flags(flags));
	
controller cont0(
	.clk(clk),
	.ir(ir),
	.stage(stage),
	.flags(flags),
	.ctrl_ai(ctrl_ai),
	.ctrl_ao(ctrl_ao),
	.ctrl_bi(ctrl_bi),
	.ctrl_ce(ctrl_ce),
	.ctrl_co(ctrl_co),
	.ctrl_eo(ctrl_eo),
	.ctrl_fi(ctrl_fi),
	.ctrl_ht(ctrl_ht),
	.ctrl_ii(ctrl_ii),
	.ctrl_io(ctrl_io),
	.ctrl_jp(ctrl_jp),
	.ctrl_mi(ctrl_mi),
	.ctrl_oi(ctrl_oi),
	.ctrl_ri(ctrl_ri),
	.ctrl_ro(ctrl_ro),
	.ctrl_su(ctrl_su));
	
isc isc0(
	.clk(clk),
	.reset(reset),
	.ctrl_ht(ctrl_ht),
	.ctrl_jp(ctrl_jp),
	.stage(stage));
	
endmodule