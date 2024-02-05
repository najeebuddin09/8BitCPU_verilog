module clkdiv #(parameter divider = 2)(
	input fastClk,
	output reg slowClk = 0
);

integer count = 0;

//parameter divider = 2;

always @(posedge fastClk) begin
	if (count == divider-1) begin
		slowClk <= ~slowClk;
		count <= 0;
	end else begin
		count <= count + 1;
	end
end

endmodule