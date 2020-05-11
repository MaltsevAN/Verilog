module MUX3(A,X0,X1,X2,Out);//non-clocked mux
input [1:0] A;
input [31:0] X2,X1,X0;
output [31:0] Out;
reg [31:0] Out;
always@(A,X2,X1,X0)
begin
    case(A)
        2'b00:
            Out <= X0;
        2'b01:
            Out <= X1;
        2'b10:
            Out <= X2;
    endcase
end
endmodule 
