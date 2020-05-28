module inst_memory(
	input [31:0] addr, 
	output reg [31:0] inst);

always @(*) // мб в скобчках
begin 
	case(addr)
		32'h00000000: inst = 32'b100011_00000_00001_0000000000000001; //	Load Word	r2 = ${&r1+inst} 8C010001
		32'h00000004: inst = 32'b001001_00000_00001_0000000000000101; // Add Immediate Unsigned $r2=$r1+inst 24010005
		32'h00000008: inst = 32'b000100_00001_00001_0000000000000111; //	Branch On Equal if($r1==$r2) go to PC+4+inst*4  10210007
		32'h00000028: inst = 32'b000010_00000000000000000000011000; // Jump	go to address  8000018
		32'h00000018: inst = 32'b000000_00000_00001_00010_00000_100001; // Add Unsigned $r3=$r1 + $r2 11021
		32'h0000001C: inst = 32'b101011_00011_00010_0000000000000001; //	Store Word Memory[$r1+inst]=$r2 AC620001

		default: inst <= 0;
	endcase 
end

endmodule
