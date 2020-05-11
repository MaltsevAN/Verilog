module PCcontrol (
	input [31:0] br,
	input [31:0] rind,
	input [31:0] jabs,
	input [31:0] pc_plus_4,
	input PCSrc,
	input jump,

	output [31:0] out	
);

wire [31:0] PCMuxOut;
assign PCMuxOut = jump ? jabs : pc_plus_4;
assign out = PCSrc ? br : PCMuxOut;


// always @(*) begin

// 	case(PCSrc)
// 		2'b00: out = br;
// 		2'b01: out = jabs;
// 		2'b10: out = pc_plus_4;
// 		default: out = 0;
// 	endcase // PCSrc
// end

endmodule
