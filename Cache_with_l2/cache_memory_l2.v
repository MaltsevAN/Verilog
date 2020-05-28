module cache_memory_l2(
	input clk,
	input rst,
	input l1_hit,
	input [31:0] addr,
	input [31:0] wdata,
	input [31:0] memory_word,
	input [3:0] counter,
	input MemWrite,
	input MemRead,
	// input EndRead_from_memory,
	output [2:0] l2_counter,
	output hit,
	output [31:0] rdata);

integer i;

wire v;
wire [25:0] tag;
wire [2:0] index;
wire [2:0] offset;

integer int_offset;

wire [2:0] l2_plus_offset;
reg [2:0] l2_counter;
reg [31:0] rdata;
reg [31:0] cache_data_index;
reg [31:0] l2_plus_offset_index;
wire [2:0] offset_plus_counter;

reg [282:0] cache_data [7:0];


assign index = addr[5:3];
assign tag = addr[31:6];
assign offset = addr[2:0];

assign v = cache_data[index][282];
assign hit = v & (tag == cache_data[index][281:256]);

// assign IsStall = MemRead & !hit;
assign offset_plus_counter = offset + counter -1;
assign l2_plus_offset = offset + l2_counter;

initial begin

end

always @(posedge rst) begin
	if(rst) begin
		for (i = 0; i < 8; i = i + 1) begin
		 	cache_data[i] <= 0;
		end
		l2_counter <= 0;
	end
end


always @(posedge clk)
if(MemWrite) begin
	if (hit) begin
		case(offset)
		  0: cache_data[index][255 : 224] <= wdata;
		  1: cache_data[index][223: 192] <= wdata;
		  2: cache_data[index][191 : 160] <= wdata; 
		  3: cache_data[index][159 : 128] <= wdata;
		  4: cache_data[index][127 : 96] <= wdata;
		  5: cache_data[index][95: 64] <= wdata;
		  6: cache_data[index][63 : 32] <= wdata; 
		  7: cache_data[index][31 : 0] <= wdata;
	  	endcase
		
	end
end

always @(posedge clk)
if(MemRead) begin
	if (!l1_hit) begin
		if (!hit)
		begin
			if (counter != 0) begin
				if (counter < 9) begin
					case(offset_plus_counter)
					  0: begin cache_data[index][255:224] = memory_word;   cache_data_index <= cache_data[index][255:224];end
					  1: begin cache_data[index][223:192] = memory_word;   cache_data_index <= cache_data[index][223:192];end
					  2: begin cache_data[index][191:160] = memory_word;   cache_data_index <= cache_data[index][191:160];end
					  3: begin cache_data[index][159:128] = memory_word;   cache_data_index <= cache_data[index][159:128];end
					  4: begin cache_data[index][127:96] = memory_word;   cache_data_index <= cache_data[index][127:96];end
					  5: begin cache_data[index][95: 64] = memory_word;   cache_data_index <= cache_data[index][95: 64];end
					  6: begin cache_data[index][63 : 32] = memory_word;   cache_data_index <= cache_data[index][63 : 32];end
					  7: begin cache_data[index][31 : 0] = memory_word;   cache_data_index <= cache_data[index][31 : 0];end
				  	endcase
					cache_data[index][282] <= 0;
					
				end
				else
				begin
					cache_data[index][282] <= 1;
					cache_data[index][281:256] <= tag;
				end
			end
		end else begin
			if (l2_counter < 4) begin
				case(l2_plus_offset)
				  0: begin rdata <= cache_data[index][255 : 224]; l2_plus_offset_index <= cache_data[index][255:224]; end
				  1: begin rdata <= cache_data[index][223: 192]; l2_plus_offset_index <= cache_data[index][223: 192];end
				  2: begin rdata <= cache_data[index][191 : 160]; l2_plus_offset_index <= cache_data[index][191 : 160];end
				  3: begin rdata <= cache_data[index][159 : 128]; l2_plus_offset_index <= cache_data[index][159 : 128];end
				  4: begin rdata <= cache_data[index][127 : 96]; l2_plus_offset_index <= cache_data[index][127 : 96];end
				  5: begin rdata <= cache_data[index][95: 64]; l2_plus_offset_index <= cache_data[index][95: 64];end
				  6: begin rdata <= cache_data[index][63 : 32]; l2_plus_offset_index <= cache_data[index][63 : 32];end
				  7: begin rdata <= cache_data[index][31 : 0]; l2_plus_offset_index <= cache_data[index][31 : 0];end
			  	endcase
				l2_counter <= l2_counter + 1;
			end
			else begin
				if (l2_counter == 4)
					l2_counter <= l2_counter + 1;
				else
					l2_counter <= 0;
			end
		end
	end 
end

// always @(*) begin 
// 	if (hit & MemRead) begin
// 	cache_data_index <= cache_data[index][127 : 96];
// 	case(offset)
// 	  2'b00: rdata <= cache_data[index][127 : 96];
// 	  2'b01: rdata <= cache_data[index][95: 64];
// 	  2'b10: rdata <= cache_data[index][63 : 32];
// 	  2'b11: rdata <= cache_data[index][31 : 0];
//   	endcase
// end
// end


endmodule
