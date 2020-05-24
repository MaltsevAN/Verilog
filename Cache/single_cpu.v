module single_cpu (input clk, input rst);
    
    wire [5:0] OpCode;
    wire [8:0] ConOut;
    wire jump,bne,imm,andi,ori,addi;
 
    control_flow control_flow(OpCode,ConOut,jump,bne,imm,andi,ori,addi);
    data_flow data_flow (clk, rst, 
        ConOut, jump, bne, imm_command, andi, ori, addi,
        OpCode);
endmodule
