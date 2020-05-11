module pc(
	input clk,
	input rst,
	input PCWrite,
	input [31:0] in, 

	output reg [31:0] out);

always @(posedge clk or posedge rst)
begin
	if(rst) begin
		out = 0;
	end 
	else if (PCWrite) begin
		out = in;
	end
end

endmodule