module single_cpu (input clk, input rst);
    
    wire [1:0] PCSrc;
    wire RegWrite;
    wire MemWrite;
    wire [1:0] RegDst;
    wire ExtSel;
    wire [3:0]OpSel;
    wire BSrc;
    wire [1:0] WBSrc;
    wire [1:0] comFormat;  
    wire [5:0] OpCode;
    wire zero;
 
    control_flow control_flow(clk, rst, 
        OpCode, zero, 
        PCSrc, RegDst, ExtSel, RegWrite, OpenSel, BSrc, MemWrite, WBSrc);
    data_flow data_flow (clk, rst, 
        PCSrc, RegDst, ExtSel, RegWrite, OpenSel, BSrc, MemWrite, WBSrc, 
        OpCode, zero);
endmodule