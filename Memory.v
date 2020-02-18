module Reg16(in, load, out, rst, clk);
	input clk;
	input rst;
	
	input [15:0] in;
	input load;
	output [15:0] out;
	
	reg [15:0] data;
	assign out = data;
	
	always @ (posedge clk) begin
		if (rst)
			data <= 1'b0;
		else
			if (load)
				data <= in;
	end
endmodule

module MyMemory(in, addr, wEna, inPKey, out, outPDisp, outPCtrl, rst, clk);
	input clk;
	input rst;
	
	input [15:0] in;
	input [14:0] addr;
	input wEna;
	input [6:0] inPKey;
	output [15:0] out;
	output [7:0] outPDisp;
	output [3:0] outPCtrl;
	
	wire [13:0] addrM;
	wire addrP;
	wire loadMem;
	wire loadSeg;
	wire [15:0] inKey;
	wire [15:0] outSeg;
	wire [15:0] outKey;
	wire [15:0] outM;
	wire [15:0] outP;
	wire [15:0] out;
	
	RAM16K mem(.dina(in), .addra(addrM), .wea(loadMem), .douta(outM), .rsta(rst), .clka(clk));
	SegDisplayer seg(.in(outSeg), .out(outPDisp), .sel(outPCtrl), .clk(clk));
	KeyHandler key(.in(inPKey), .out(inKey), .clk(clk));
	Reg16 regSeg(.in(in), .load(loadSeg), .out(outSeg), .rst(rst), .clk(clk));
	Reg16 regKey(.in(inKey), .load(1'b1), .out(outKey), .rst(rst), .clk(clk));
	
	assign addrM = addr[14] ? 14'b0 : addr[13:0];
	assign addrP = addr[14] ? addr[13] : 1'b0;
	assign loadMem = wEna & !addr[14];
	assign loadSeg = wEna & addr[14] & !addrP;
	assign outP = addrP ? outKey : outSeg;
	assign out = addr[14] ? outP : outM;
endmodule
