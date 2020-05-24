module cache_memory(
	input clk,
	input rst,
	input [31:0] addr,
	input [31:0] wdata,
	input [31:0] memory_word,
	input [2:0] counter,
	input MemWrite,
	input MemRead,
	// input EndRead_from_memory,

	output [154:0] cache_data_index,
	output IsStall,
	output hit,
	output [31:0] rdata);

integer i;

wire v;
wire [25:0] tag;
wire [1:0] index;
wire [1:0] offset;

integer int_offset;

reg [31:0] rdata;
reg [154:0] cache_data_index;
reg [154:0] cache_data [3:0];


assign index = addr[5:4];
assign tag = addr[31:6];
assign offset = addr[3:2];

assign v = cache_data[index][154];
assign hit = v & (tag == cache_data[index][153:128]);

assign IsStall = MemRead & !hit;

initial begin

end

always @(posedge rst) begin
	if(rst) begin
		for (i = 0; i < 4; i = i + 1) begin
		 	cache_data[i] <= 0;
		end
	end
end


always @(posedge clk)
if(MemWrite) begin
	if (hit) begin
		case(offset)
		  2'b00: cache_data[index][127-32*0 : 128-32*(0+1)] <= wdata;
		  2'b01: cache_data[index][127-32*1 : 128-32*(1+1)] <= wdata;
		  2'b10: cache_data[index][127-32*2 : 128-32*(2+1)] <= wdata; 
		  2'b11: cache_data[index][127-32*3 : 128-32*(3+1)] <= wdata;
	  	endcase
		
	end
end

always @(posedge clk)
if(MemRead) begin
	if (hit) begin
		cache_data_index <= cache_data[index];
		case(offset)
		  2'b00: rdata <= cache_data[index][127-32*0 : 128-32*(0+1)];
		  2'b01: rdata <= cache_data[index][127-32*1 : 128-32*(1+1)];
		  2'b10: rdata <= cache_data[index][127-32*2 : 128-32*(2+1)];
		  2'b11: rdata <= cache_data[index][127-32*3 : 128-32*(3+1)];
	  	endcase
	end
	else begin
		if (counter < 4) begin
			cache_data_index <= cache_data[index];
			case(counter)
			  3'b000: cache_data[index][127-32*0 : 128-32*(0+1)] <= memory_word; 
			  3'b001: cache_data[index][127-32*1 : 128-32*(1+1)] <= memory_word;
			  3'b010: cache_data[index][127-32*2 : 128-32*(2+1)] <= memory_word;
			  3'b011: cache_data[index][127-32*3 : 128-32*(3+1)] <= memory_word; 
		  	endcase
			cache_data[index][154] <= 0;
			
		end
		else
		begin
			cache_data_index <= cache_data[index];
			cache_data[index][154] <= 1;
			cache_data[index][153:128] <= tag;
		end
	end
end


endmodule
