module EXMEM(clock,rst,WB,M,ALUOut,RegRD,WriteDataIn,Mreg,WBreg,ALUreg,RegRDreg,WriteDataOut);
input clock;
input rst;
input [1:0] WB;
input [2:0] M;
input [4:0] RegRD;
input [31:0] ALUOut,WriteDataIn;
output [1:0] WBreg;
output [2:0] Mreg;
output [31:0] ALUreg,WriteDataOut;
output [4:0] RegRDreg;
reg [1:0] WBreg;
reg [2:0] Mreg;
reg [31:0] ALUreg,WriteDataOut;
reg [4:0] RegRDreg;


always@(posedge clock, posedge rst)
begin
	if (rst)
	begin 
		WBreg=0;
		Mreg=0;
		ALUreg=0;
		WriteDataOut=0;
		RegRDreg=0;
	end
	else begin
		WBreg <= WB;
		Mreg <= M;
		ALUreg <= ALUOut;
		RegRDreg <= RegRD;
		WriteDataOut <= WriteDataIn;
	end
end

endmodule
