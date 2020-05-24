module two_in_sum (
	input [31:0] in1,
	input [31:0] imm,

	output [31:0] out	
);



assign out = in1 + imm*4;

endmodule