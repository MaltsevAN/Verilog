module WRcontrol (
	input [31:0] data_memory_out,
	input [31:0] alu_out,
	//input [31:0] plus_4_out,
	input  WBSrc,

	output reg [31:0] out
);

always @(*) begin
	case(WBSrc)
		//2'b00: out = plus_4_out;
		1'b1: out = alu_out;
		1'b0: out = data_memory_out;
		default: out = 0;
	endcase // WBSrc
end

endmodule