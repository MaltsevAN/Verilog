module extend (
	input [25:0] in,  
	output [31:0] out	
);

assign out = {6'b000000,in};

endmodule