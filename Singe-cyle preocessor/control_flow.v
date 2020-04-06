module control_flow (
	input clk, 
	input rst, 
	
	input [5:0] OpCode,
	input zero,

	output reg [1:0] PCSrc,
	output reg [1:0] RegDst,
	output reg ExtSel,
	output reg RegWrite,
	output reg OpenSel,
	output reg BSrc,
	output reg MemWrite,
	output reg [1:0] WBSrc	
);

// PCSrc
always @(*) begin
    PCSrc = 2'b00;
    case (OpCode)
    6'b000010, 6'b010011: PCSrc = 2'b10;
    6'b000100: if (zero) begin
    			PCSrc = 2'b00;
    			end else begin
    			 PCSrc = 2'b11;
    			end
    default: PCSrc = 2'b11;
    endcase
end

// RegDst
always @(*) begin
    case (OpCode)
        6'b000000: RegDst = 2'b10;
        6'b000010: RegDst = 2'b00;
        default: RegDst = 2'b01;
    endcase
end

// RegWrite
always@* begin
    RegWrite = 1;
    case (OpCode)
    6'b101011: RegWrite = 0;
    6'b000010: RegWrite = 0;
    6'b000100: RegWrite = 0;
    endcase
end

// ExtSel
always @(*) begin
    ExtSel = 0;
    case (OpCode)
    6'b001000: ExtSel = 1;	
    6'b001010: ExtSel = 1;
    endcase
end



//BSrc
always @(*) begin
    case (OpCode)
        6'b000000, 6'b010000, 6'b000100: BSrc = 0;
        default: BSrc = 1;        
    endcase
end



// MemWrite
always @(*) begin
    MemWrite = 0;
    case (OpCode)
    6'b101011: MemWrite = 1;        
    endcase
end


// WBSrc
always @(*) begin
    WBSrc = 2'd1;
    case (OpCode)
    6'b100011: WBSrc = 2'd2;
    endcase
end

endmodule