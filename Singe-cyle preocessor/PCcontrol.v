module PCcontrol (
	input [31:0] br,
	input [31:0] rind,
	input [31:0] jabs,
	input [31:0] pc_plus_4,
	input [1:0] PCSrc,

	output reg [31:0] out	
);

always @(*) begin
	case(PCSrc)
		2'b00: out = br;
		2'b01: out = rind;
		2'b10: out = jabs;
		2'b11: out = pc_plus_4;
		default: out = 0;
	endcase // PCSrc
end

endmodule