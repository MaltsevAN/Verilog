module GPRs(
	input clk, 
	input rst, 
	input [4:0] rs1, 
	input [4:0] rs2, 
	input [4:0] ws,
	input [31:0] wd,
	input RegWrite,

	output [31:0] rd1,
	output [31:0] rd2
	);
integer i;

reg [31:0] rf [31:0];

assign rd1 = rf[rs1];
assign rd2 = rf[rs2];

always @(posedge clk or posedge rst) begin
	if(rst) begin
		 for (i = 0; i < 32; i = i + 1) begin
		 	rf[i] <= 2;
		end
	end
	else begin
		if (RegWrite) begin
			rf[ws] <= wd;
		end
	end
end

endmodule