module HazardUnit(
	IDRegRs,
	IDRegRt,
	EXRegRt,
	EXMemRead,
	CacheStall,

	PCWrite,
	IFIDWrite,
	HazMuxCon,
	IDEXWrite,
	EXMEMWrite,
	MEMWBWrite
	);
input [4:0] IDRegRs,IDRegRt,EXRegRt;
input EXMemRead, CacheStall;
output PCWrite, IFIDWrite, HazMuxCon, IDEXWrite, EXMEMWrite, MEMWBWrite;

reg PCWrite, IFIDWrite, HazMuxCon, IDEXWrite, EXMEMWrite, MEMWBWrite;

always@(IDRegRs,IDRegRt,EXRegRt,EXMemRead)
	if (CacheStall)
	begin
		PCWrite = 0;
		IFIDWrite = 0;
		HazMuxCon = 0;

		IDEXWrite = 0;
		EXMEMWrite = 0;
		MEMWBWrite = 0;
	end
	else begin
		if(EXMemRead&((EXRegRt == IDRegRs)|(EXRegRt == IDRegRt)))
		begin//stall
			PCWrite = 0;
			IFIDWrite = 0;
			HazMuxCon = 0;

			IDEXWrite = 1;
			EXMEMWrite = 1;
			MEMWBWrite = 1;
		end
		else
		begin//no stall
			PCWrite = 1;
			IFIDWrite = 1;
			HazMuxCon = 1;

			IDEXWrite = 1;
			EXMEMWrite = 1;
			MEMWBWrite = 1;
		end
	end
endmodule 
