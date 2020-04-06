module choose_write_reg (
	input [4:0] rs2, 
	input [4:0]	rs3,
	input [1:0] RegDst,

	output reg [4:0] ws
);

always @(*) begin
        case (RegDst)
        	2'b00: ws = 5'd31;
        	2'b01: ws = rs2;
        	2'b10: ws = rs3;
        endcase
    end

endmodule