module imm_ext (
	input [15:0] imm,
	input ExtSel,

	output [31:0] ext	
);

assign ext = ExtSel ? {{16{imm[15]}}, imm} : {{16{1'b0}}, imm};

endmodule