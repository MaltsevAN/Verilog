module data_flow (
	input clk,    
	input rst,

	input [8:0] ConOut,
	input jump,
	input bne,
	input imm_command,
	input andi,
	input ori,
	input addi,

	output [5:0] OpCode

);
wire [31:0] wd;
wire [31:0] rd1;
wire [31:0] rd2;

wire [8:0] IDcontrol;
wire [31:0] pc_in;
wire [31:0] pc_out;
wire ExtSel;
wire ALUSrc;
wire PCWrite;
wire HazMuxCon;
wire PCSrc;

assign ALUSrc = ConOut[2];
assign ExtSel = 1;
assign IDcontrol = HazMuxCon ? ConOut : 0;
assign PCSrc = ((rd1==rd2)&IDcontrol[6])|((rd1!=rd2)&bne);
assign IFFlush = PCSrc|jump; 


pc pc(
	.clk(clk), 
	.rst(rst),
	.PCWrite(PCWrite),
	.in(pc_in),
	.out(pc_out)
	);

wire [31:0] command;

inst_memory inst_memory(
	.addr(pc_out),
	.inst(command)
	);


wire IFIDWrite;
wire IDEXWrite;
wire EXMEMWrite;
wire MEMWBWrite;
wire [31:0] InstReg;
wire [31:0] PC_Plus4Reg;
wire [31:0] plus_4_out;

IFID IFID(
	.flush(IFFlush),
	.clock(clk),
	.rst(rst),
	.IFIDWrite(IFIDWrite),
	.PC_Plus4(plus_4_out),
	.Inst(command),
	//output
	.InstReg(InstReg),
	.PC_Plus4Reg(PC_Plus4Reg)
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
	.command(InstReg),
	.op_code(OpCode),
	.rs1(rs1),
	.rs2(rs2),
	.ws(rs3),
	.imm(imm),
	.shamt(shamt),
	.funct(funct),
	.address(address)
	);


GPRs GPRs(
	.clk(clk), 
	.rst(rst), 
	.rs1(rs1), 
	.rs2(rs2), 
	.ws(ws),
	.wd(wd),
	.RegWrite(WBreg_mem_wb[0]),

	.rd1(rd1),
	.rd2(rd2)
	);

wire [31:0] ext;

imm_ext imm_ext(
	.imm(imm),
	.ExtSel(ExtSel),
	.ext(ext)	
	);


wire [1:0] WBreg_idex;
wire [2:0] Mreg_idex;
wire [3:0] EXreg;
wire [4:0] RegRsreg;
wire [4:0] RegRtreg;
wire [4:0] RegRdreg;
wire [31:0] DataAreg;
wire [31:0] DataBreg;
wire [31:0] imm_valuereg;
wire [5:0] RegOpCode;

IDEX IDEX(
	.clock(clk),
	.rst(rst),
	.WB(IDcontrol[8:7]),
	.M(IDcontrol[6:4]),
	.EX(IDcontrol[3:0]),
	.DataA(rd1),
	.DataB(rd2),
	.imm_value(ext),
	.RegRs(rs1),
	.RegRt(rs2),
	.RegRd(rs3),
	.OpCode(OpCode),
	.IDEXWrite(IDEXWrite),
	//out
	.WBreg(WBreg_idex),
	.Mreg(Mreg_idex),
	.EXreg(EXreg),
	.DataAreg(DataAreg),
	.DataBreg(DataBreg),
	.imm_valuereg(imm_valuereg),
	.RegRsreg(RegRsreg),
	.RegRtreg(RegRtreg),
	.RegRdreg(RegRdreg),
	.RegOpCode(RegOpCode)
	);

choose_write_reg choose_write_reg (
	.rs2(RegRtreg), 
	.rs3(RegRdreg),
	.RegDst(EXreg[3]),

	.ws(ws)
);

wire [31:0] MUX3_forwardRD1_out;
wire [31:0] ALUreg;
wire [1:0] ForwardA;
wire [1:0] ForwardB;

MUX3  MUX3_forwardRD1(
	.A(ForwardA),
	.X0(DataAreg),
	.X1(wd),
	.X2(ALUreg),
	.Out(MUX3_forwardRD1_out)
	);

wire [31:0] MUX3_forwardRD2_out;

MUX3 MUX3_forwardRD2(
	.A(ForwardB),
	.X0(DataBreg),
	.X1(wd),
	.X2(ALUreg),
	.Out(MUX3_forwardRD2_out)
	);

wire [31:0] rd2_imm_out;

choose_rd2_imm choose_rd2_imm (
	.rd2(MUX3_forwardRD2_out),
	.imm(imm_valuereg),
	.BSrc(ALUSrc),

	.out(rd2_imm_out)	
	);

wire [31:0] alu_res;



alu alu (
	.in1(MUX3_forwardRD1_out),
	.in2(rd2_imm_out),
	.op_code(RegOpCode),

	.out(alu_res)
	);

wire [1:0] WBreg;
wire [2:0] Mreg;
wire [31:0] WriteDataOut;
wire [4:0] RegRDreg;

EXMEM EXMEM(
	.clock(clk),
	.rst(rst),
	.WB(WBreg_idex),
	.M(Mreg_idex),
	.ALUOut(alu_res),
	.RegRD(ws),
	.WriteDataIn(MUX3_forwardRD2_out),
	.EXMEMWrite(EXMEMWrite),
	//out
	.Mreg(Mreg),
	.WBreg(WBreg),
	.ALUreg(ALUreg),
	.RegRDreg(RegRDreg),
	.WriteDataOut(WriteDataOut)
	);

// 
wire [31:0] rdata;
wire hit, l2_hit;
wire [31:0] memory_word;
wire [31:0] l2_word;

wire [3:0] counter;
wire [2:0] l2_counter;

wire CacheStall;

cache_memory_l1 cache_memory_l1(
	.clk(clk),
	.rst(rst),
	.addr(ALUreg),
	.wdata(WriteDataOut),
	.l2_word(l2_word),
	.counter(l2_counter),
	.MemWrite(Mreg[0]),
	.MemRead(Mreg[1]),

	.IsStall(CacheStall),
	.hit(hit),
	.rdata(rdata)
	);

cache_memory_l2 cache_memory_l2(
	.clk(clk),
	.rst(rst),
	.l1_hit(hit),
	.addr(ALUreg),
	.wdata(WriteDataOut),
	.memory_word(memory_word),
	.counter(counter),
	.MemWrite(Mreg[0]),
	.MemRead(Mreg[1]),

	.l2_counter(l2_counter),
	.hit(l2_hit),
	.rdata(l2_word)
	);

data_memory data_memory(
	.clk(clk),
	.rst(rst),
	.l2_hit(l2_hit),
	.addr(ALUreg),
	.wdata(WriteDataOut),
	.MemWrite(Mreg[0]),
	.MemRead(Mreg[1]),

	.counter(counter),
	.rdata(memory_word)
	);
// 




 	

wire [1:0] WBreg_mem_wb;
wire [31:0] Memreg;
wire [31:0] ALUreg_mem_wb;
wire [4:0] RegRDreg_mem_wb;

MEMWB MEMWB(
	.clock(clk),
	.rst(rst),
	.WB(WBreg),
	.Memout(rdata),
	.ALUOut(ALUreg),
	.RegRD(RegRDreg),
	.MEMWBWrite(MEMWBWrite),
	// out
	.WBreg(WBreg_mem_wb),
	.Memreg(Memreg),
	.ALUreg(ALUreg_mem_wb),
	.RegRDreg(RegRDreg_mem_wb)
	);



ForwardUnit ForwardUnit(
	.MEMRegRd(RegRDreg),
	.WBRegRd(RegRDreg_mem_wb),
	.EXRegRs(RegRsreg),
	.EXRegRt(RegRtreg), 
	.MEM_RegWrite(WBreg[0]),
	.WB_RegWrite(WBreg_mem_wb[0]),
	//out
	.ForwardA(ForwardA),
	.ForwardB(ForwardB)
	);



HazardUnit HazardUnit(
	.IDRegRs(rs1),
	.IDRegRt(rs2),
	.EXRegRt(RegRtreg),
	.EXMemRead(Mreg[1]),
	.CacheStall(CacheStall),
	//out
	.PCWrite(PCWrite),
	.IFIDWrite(IFIDWrite),
	.HazMuxCon(HazMuxCon),
	.IDEXWrite(IDEXWrite),
	.EXMEMWrite(EXMEMWrite),
	.MEMWBWrite(MEMWBWrite)
	);


WRcontrol WRcontrol (
	.data_memory_out(Memreg),
	.alu_out(ALUreg_mem_wb),
	//.plus_4_out(plus_4_out),
	.WBSrc(WBreg_mem_wb[1]),

	.out(wd)
	);

plus_4 plus_4 (
	.in(pc_out),

	.out(plus_4_out)	
	);

wire [31:0] br;


two_in_sum two_in_sum (
	.in1(PC_Plus4Reg),
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
	.jabs(jabs),
	.pc_plus_4(plus_4_out),
	.PCSrc(PCSrc),
	.jump(jump),

	.out(pc_in)	
	);

endmodule