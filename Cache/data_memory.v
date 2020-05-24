module data_memory(
	input clk,
	input rst,
	input hit,
	input [31:0] addr,
	input [31:0] wdata,
	input MemWrite,
	input MemRead,

	output [2:0] counter,
	// output EndRead,
	output [31:0] rdata);

integer i;

wire [31:0] mask;
reg [2:0] counter;
reg [31:0] rdata;
reg [31:0] data [31:0];

assign mask = 32'b11111111111111111111111111110000;

always @(posedge rst) begin
	if(rst) begin
		for (i = 0; i < 32; i = i + 1) begin
		 	data[i] <= i;
		 		
		end
		counter <= 3'b000;
	// EndRead <= 1;
	end
end

always @(posedge clk)
if(MemWrite) begin
	data[addr] <= wdata;
end

always @(posedge clk) begin
if(MemRead) begin
	if (!hit) begin
		if (counter < 4) begin
			rdata <= data[addr+counter];
			counter = counter + 1;
			// EndRead <= 0;
		end
		// else begin
		// 	EndRead <= 1;
		// 	counter = 0;
		// end
	end
end
end


endmodule
