module MEMWB(clock,WB,Memout,ALUOut,RegRD,WBreg,Memreg,ALUreg,RegRDreg);
input clock;
input [1:0] WB;
input [4:0] RegRD;
input [31:0] Memout,ALUOut;
output [1:0] WBreg;
output [31:0] Memreg,ALUreg;
output [4:0] RegRDreg;
reg [1:0] WBreg;
reg [31:0] Memreg,ALUreg;
reg [4:0] RegRDreg;

initial begin
	WBreg = 0;
	Memreg = 0;
	ALUreg = 0;
	RegRDreg = 0;
end

always@(posedge clock)
begin
	WBreg <= WB;
	Memreg <= Memout;
	ALUreg <= ALUOut;
	RegRDreg <= RegRD;
end

endmodule
