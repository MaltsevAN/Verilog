module IFID(flush,clock,IFIDWrite,PC_Plus4,Inst,InstReg,PC_Plus4Reg);
 input [31:0] PC_Plus4,Inst;
 input clock,IFIDWrite,flush;
 output [31:0] InstReg, PC_Plus4Reg;

 reg [31:0] InstReg, PC_Plus4Reg;

initial begin
	InstReg = 0;
	PC_Plus4Reg = 0;
end

always@(posedge clock)
begin
	if(flush)
		begin
		InstReg <= 0;
		PC_Plus4Reg <=0;
		end
	else if(IFIDWrite)
		begin
		InstReg <= Inst;
		PC_Plus4Reg <= PC_Plus4;
	end
end

endmodule 
