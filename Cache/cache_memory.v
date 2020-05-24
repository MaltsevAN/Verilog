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

	output [31:0] cache_data_index,
	output [1:0] offset_plus_counter,
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
reg [31:0] cache_data_index;
wire [1:0] offset_plus_counter;

reg [156:0] cache_data [3:0];


assign index = addr[3:2];
assign tag = addr[31:4];
assign offset = addr[1:0];

assign v = cache_data[index][156];
assign hit = v & (tag == cache_data[index][155:128]);

assign IsStall = MemRead & !hit;
assign offset_plus_counter = offset + counter -1;
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
		  2'b00: cache_data[index][127 : 96] <= wdata;
		  2'b01: cache_data[index][95: 64] <= wdata;
		  2'b10: cache_data[index][63 : 32] <= wdata; 
		  2'b11: cache_data[index][31 : 0] <= wdata;
	  	endcase
		
	end
end

always @(posedge clk)
if(MemRead) begin
	if (!hit)
	begin
		if (counter != 0) begin
		if (counter < 5) begin
			case(offset_plus_counter)
			  0: begin cache_data[index][127 : 96] = memory_word;  cache_data_index <= cache_data[index][127 : 96]; end
			  1: begin cache_data[index][95: 64] = memory_word;   cache_data_index <= cache_data[index][95: 64]; end
			  2: begin cache_data[index][63 : 32] = memory_word;   cache_data_index <= cache_data[index][63 : 32]; end
			  3: begin cache_data[index][31 : 0] = memory_word;   cache_data_index <= cache_data[index][31 : 0]; end
		  	endcase
			cache_data[index][156] <= 0;
			
		end
		else
		begin
			cache_data_index <= cache_data[index][127 : 96];
			cache_data[index][156] <= 1;
			cache_data[index][155:128] <= tag;
		end
	end
	end
end

always @(*) begin 
	if (hit & MemRead) begin
	cache_data_index <= cache_data[index][127 : 96];
	case(offset)
	  2'b00: rdata <= cache_data[index][127 : 96];
	  2'b01: rdata <= cache_data[index][95: 64];
	  2'b10: rdata <= cache_data[index][63 : 32];
	  2'b11: rdata <= cache_data[index][31 : 0];
  	endcase
end
end


endmodule
