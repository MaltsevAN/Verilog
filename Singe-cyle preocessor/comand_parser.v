module comand_parser (
	input [31:0] command,

	output [5:0] op_code,
	output reg [4:0] rs1,
	output reg [4:0] rs2,
	output reg [4:0] ws,
	output reg [15:0] imm,
	output reg [4:0] shamt,
	output reg [5:0] funct,
	output reg [25:0] address
);

// wire [1:0] command_format;

// assign command_format = op_code[31:30];
assign op_code = command[31:26];

always @(*) begin
	case (op_code)
		6'b000000, 6'b010000: begin
			rs1 = command[25:21];
			rs2 = command[20:16];
			ws = command[15:11];
			shamt = command[10:6];
			funct = command[5:0];
			// imm = 0;
			// address = 0;
		end
		6'b000010, 6'b010011: begin
			// rs1 = 0;
			// rs2 = 0;
			// ws = 0;
			// shamt = 0;
			// funct = 0;
			// imm = 0;
			address = command[25:0];

		end
		default: begin
			rs1 = command[25:21];
			rs2 = command[20:16];
			// ws = 0;
			// shamt = 0;
			// funct = 0;
			imm = command[15:0];
			// address = 0;
		end
	endcase // command_format
end

endmodule