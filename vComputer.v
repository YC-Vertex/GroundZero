module vComputer(inPKey, outPDisp, outPCtrl, rst, clk);
	input rst, clk;
	
	input [6:0] inPKey;
	output [7:0] outPDisp;
	output [3:0] outPCtrl;

	wire [15:0] MRead, MWrite, instr;
	// wire [15:0] MRead, MWrite;
	wire [14:0] MAddr, outPC;
	wire loadM;
	/*
	wire [15:0] outA, outD;
	wire [15:0] aluX, aluY, outALU;
	wire [5:0] aluInstr;
	
	reg [15:0] instr;
	
	reg [31:0] cnt;
	*/
	
	// MyCPU4Test cpu(.MRead(MRead), .instr(instr), .MWrite(MWrite), .MAddr(MAddr), .loadM(loadM), .outPC(outPC), .rst(rst), .clk(clk), .outA(outA), .outD(outD), .aluX(aluX), .aluY(aluY), .outALU(outALU), .aluInstr(aluInstr));
	MyCPU cpu(.MRead(MRead), .instr(instr), .MWrite(MWrite), .MAddr(MAddr), .loadM(loadM), .outPC(outPC), .rst(rst), .clk(clk));
	MyMemory mem(.in(MWrite), .addr(MAddr), .wEna(loadM), .inPKey(inPKey), .out(MRead), .outPDisp(outPDisp), .outPCtrl(outPCtrl), .rst(rst), .clk(clk));
	ROM32K ins(.dina(16'b0), .addra(outPC[11:0]), .wea(1'b0), .douta(instr), .clka(clk));
	// MyMemory mem(.in(MWrite), .addr(MAddr), .wEna(loadM), .inPKey(inPKey), .out(MRead), .rst(rst), .clk(clk));
	// SegDisplayer seg(.in(outD), .out(outPDisp), .sel(outPCtrl), .clk(clk));
	
	/*
	always @ (posedge clk) begin
		cnt <= cnt + 1;
	end
	
	always @ (posedge clk) begin
		if	(cnt < 100)
			instr <= 16'b0000001001100110;
		else
			instr <= 16'b1110110000010000;
	end
	*/
endmodule
