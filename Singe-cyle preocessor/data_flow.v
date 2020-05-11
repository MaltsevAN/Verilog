module data_flow (
	input clk,    
	input rst,

	input [1:0] PCSrc,
	input [1:0] RegDst,
	input ExtSel,
	input RegWrite,
	input OpenSel,
	input BSrc,
	input MemWrite,
	input [1:0] WBSrc,

	output [5:0] OpCode,
	output zero

);

wire [31:0] pc_in;
wire [31:0] pc_out;

pc pc(
	.clk(clk), 
	.rst(rst),
	.in(pc_in),
	.out(pc_out)
	);

wire [31:0] command;

inst_memory inst_memory(
	.addr(pc_out),
	.inst(command)
	);


wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rs3;
wire [4:0] ws;
wire [15:0] imm;
wire [4:0] shamt;
wire [5:0] funct;
wire [25:0] address;

comand_parser comand_parser(
	.command(command),

	.op_code(OpCode),
	.rs1(rs1),
	.rs2(rs2),
	.ws(rs3),
	.imm(imm),
	.shamt(shamt),
	.funct(funct),
	.address(address)
	);

wire [31:0] wd;

wire [31:0] rd1;
wire [31:0] rd2;

choose_write_reg choose_write_reg (
	.rs2(rs2), 
	.rs3(rs3),
	.RegDst(RegDst),

	.ws(ws)
);

GPRs GPRs(
	.clk(сlk), 
	.rst(rst), 
	.rs1(rs1), 
	.rs2(rs2), 
	.ws(ws),
	.wd(wd),
	.RegWrite(RegWrite),

	.rd1(rd1),
	.rd2(rd2)
	);

wire [31:0] ext;

imm_ext imm_ext(
	.imm(imm),
	.ExtSel(ExtSel),
	.ext(ext)	
	);

wire [31:0] rd2_imm_out;

choose_rd2_imm choose_rd2_imm (
	.rd2(rd2),
	.imm(ext),
	.BSrc(BSrc),

	.out(rd2_imm_out)	
	);

wire [31:0] alu_res;

alu alu (
	.in1(rd1),
	.in2(rd2_imm_out),
	.op_code(OpCode),

	.zero(zero),
	.out(alu_res)
	);

wire [31:0] rdata;

data_memory data_memory(
	.clk(clk),
	.rst(rst),
	.addr(alu_res),
	.wdata(rd2),
	.MemWrite(MemWrite),

	.rdata(rdata)
	);

wire [31:0] plus_4_out;

WRcontrol WRcontrol (
	.data_memory_out(rdata),
	.alu_out(alu_res),
	.plus_4_out(plus_4_out),
	.WBSrc(WBSrc),

	.out(wd)
	);

plus_4 plus_4 (
	.in(pc_out),

	.out(plus_4_out)	
	);

wire [31:0] br;

two_in_sum two_in_sum (
	.in1(plus_4_out),
	.imm(ext),

	.out(br)	
	);

wire [31:0] jabs;

extend extend (
	.in(address),
	.out(jabs)
	);

PCcontrol PCcontrol (
	.br(br),
	.rind(rd1),
	.jabs(jabs),
	.pc_plus_4(plus_4_out),
	.PCSrc(PCSrc),

	.out(pc_in)	
	);

endmodule