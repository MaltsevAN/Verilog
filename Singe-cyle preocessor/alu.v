module alu(
	input [31:0] in1,
	input [31:0] in2,
	input [5:0] op_code,

	output zero,
	output reg [31:0] out
	);

assign zero = out == 0;

always @(*) begin
	case(op_code)
		6'b000000: out = in1 + in2; // 	Add Unsigned
		6'b001001: out = in1 + in2; // 	Add Immediate Unsigned
		6'b100011: out = in1 + in2; //  Load Word
		6'b101011: out = in1 + in2; // 	Store Word
		6'b000100: out = in1 - in2; //  Branch On Equal
		default: out = 0;
	endcase // op_code
end

endmodule
