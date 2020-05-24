module choose_write_reg (
	input [4:0] rs2, 
	input [4:0]	rs3,
	input  RegDst,

	output reg [4:0] ws
);

always @(*) begin
        case (RegDst)
        	1'b0: ws = rs2;
        	1'b1: ws = rs3;
        endcase
    end

endmodule