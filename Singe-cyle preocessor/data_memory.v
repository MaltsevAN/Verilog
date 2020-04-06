module data_memory(
	input clk,
	input rst,
	input [31:0] addr,
	input [31:0] wdata,
	input MemWrite,

	output [31:0] rdata);

integer i;
reg [31:0] data [31:0];

assign rdata = data[addr];

always @(posedge clk or posedge rst) begin
	if(rst) begin
		 for (i = 0; i < 32; i = i + 1) begin
		 	data[i] <= i;
		end
	end
	else begin
		if (MemWrite) begin
			data[addr] <= wdata;
		end
	end
end

endmodule