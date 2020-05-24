module choose_rd2_imm (
	input [31:0] rd2,
	input [31:0] imm,
	input BSrc,

	output [31:0] out	

);

assign out = BSrc ? imm : rd2;

endmodule