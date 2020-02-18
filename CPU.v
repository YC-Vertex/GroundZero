module ALU(x, y, instr, out, eq, lt, gt);
	input [15:0] x;
	input [15:0] y;
	input [5:0] instr;
	output [15:0] out;
	output eq, lt, gt;
	
	wire [15:0] xz;
	wire [15:0] yz;
	assign xz = instr[5] ? 16'b0 : x;
	assign yz = instr[3] ? 16'b0 : y;
	wire [15:0] xf;
	wire [15:0] yf;
	assign xf = instr[4] ? ~xz : xz;
	assign yf = instr[2] ? ~yz : yz;
	wire [15:0] pResult;
	wire [15:0] aResult;
	assign pResult = xf + yf;
	assign aResult = xf & yf;
	wire [15:0] r;
	assign r = instr[1] ? pResult : aResult;
	assign out = instr[0] ? ~r : r;
	
	assign eq = (out == 16'b0);
	assign lt = out[15];
	assign gt = !eq & !lt;
endmodule

module PC(in, load, inc, out, rst, clk);
	input clk;
	input rst;
	
	input [14:0] in;
	input load;
	input inc;
	output [14:0] out;
	
	reg [14:0] data;
	assign out = data;
	
	always @ (posedge clk) begin
		if (rst)
			data <= 16'b0;
		else
			if (load)
				data <= in;
			else
				if (inc)
					data <= data + 1;
	end
endmodule

module MyCPU(MRead, instr, MWrite, MAddr, loadM, outPC, rst, clk);
	input clk;
	input rst;
	
	input [15:0] MRead;
	input [15:0] instr;
	output [15:0] MWrite;
	output [14:0] MAddr;
	output loadM;
	output [14:0] outPC;
	
	wire [15:0] inA, inD, outA, outD, aluX, aluY, outALU;
	wire [14:0] inPC, outPC;
	wire loadA, loadD, loadPC;
	wire lt, eq, gt;
	reg haltPC;
	reg halt;
	
	Reg16 regA(.in(inA), .load(loadA), .out(outA), .rst(rst), .clk(clk));
	Reg16 regD(.in(inD), .load(loadD), .out(outD), .rst(rst), .clk(clk));
	PC pc(.in(inPC), .load(loadPC), .inc(!haltPC), .out(outPC), .rst(rst), .clk(clk));
	ALU alu(.x(aluX), .y(aluY), .instr(instr[11:6]), .out(outALU), .eq(eq), .lt(lt), .gt(gt));
	
	assign inA = instr[15] ? outALU : instr;
	assign inD = outALU;
	assign aluX = outD;
	assign aluY = instr[12] ? MRead : outA;
	
	assign loadA = !instr[15] | instr[5];
	assign loadD = instr[15] & instr[4] & !halt;
	assign loadM = instr[15] & instr[3] & !halt;
	assign MWrite = outALU;
	assign MAddr = outA[14:0];
	
	assign inPC = outA[14:0];
	assign loadPC = instr[15] & ((instr[2] & lt) | (instr[1] & eq) | (instr[0] & gt));
	
	initial begin
		haltPC <= 1'b0;
		halt <= 1'b0;
	end
	
	always @ (negedge clk) begin
		if (!haltPC && loadA)
			haltPC <= 1'b1;
		else
			haltPC <= 1'b0;
	end
	
	always @ (posedge clk) begin
		halt <= haltPC;
	end
endmodule

module MyCPU4Test(MRead, instr, MWrite, MAddr, loadM, outPC, rst, clk, outA, outD, aluX, aluY, outALU, aluInstr);
	input clk;
	input rst;
	
	input [15:0] MRead;
	input [15:0] instr;
	output [15:0] MWrite;
	output [14:0] MAddr;
	output loadM;
	output [14:0] outPC;
	output [15:0] outA, outD;
	output [15:0] aluX, aluY, outALU;
	output [5:0] aluInstr;
	
	wire [15:0] inA, inD, outA, outD, aluX, aluY, outALU;
	wire [14:0] inPC, outPC;
	wire loadA, loadD, loadPC;
	wire lt, eq, gt;
	
	Reg16 regA(.in(inA), .load(loadA), .out(outA), .rst(rst), .clk(clk));
	Reg16 regD(.in(inD), .load(loadD), .out(outD), .rst(rst), .clk(clk));
	PC pc(.in(inPC), .load(loadPC), .inc(1'b1), .out(outPC), .rst(rst), .clk(clk));
	ALU alu(.x(aluX), .y(aluY), .instr(instr[11:6]), .out(outALU), .eq(eq), .lt(lt), .gt(gt));
	
	assign inA = instr[15] ? outALU : instr;
	assign inD = outALU;
	assign aluX = outD;
	assign aluY = instr[12] ? MRead : outA;
	
	assign loadA = !instr[15] | instr[5];
	assign loadD = instr[15] & instr[4];
	assign loadM = instr[15] & instr[3];
	assign MWrite = outALU;
	assign MAddr = outA[14:0];
	assign MAddr = outA[14:0];
	
	assign inPC = outA[14:0];
	assign loadPC = instr[15] & ((instr[2] & lt) | (instr[1] & eq) | (instr[0] & gt));
endmodule
