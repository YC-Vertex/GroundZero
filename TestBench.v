
module TestBench(key, sel, disp, ctrl, dis, rst, clk);
	input clk;
	input rst;
	
	input [6:0] key;
	input sel;
	output [7:0] disp;
	output [3:0] ctrl;
	output [3:0] dis;
	
	wire nrst;
	assign nrst = ~rst;
	
	wire [7:0] segDisp;
	wire [3:0] segCtrl;
	reg [3:0] dis;
	
	vComputer computer(.inPKey(key), .outPDisp(segDisp), .outPCtrl(segCtrl), .rst(nrst), .clk(clk));
	
	assign disp = segDisp;
	assign ctrl = segCtrl;
	
	initial begin
		dis <= 4'b1111;
	end
endmodule


/*
// Memory and Periph Test
module TestBench(key, sel, disp, ctrl, dis, rst, clk);
	input clk;
	input rst;
	
	input [6:0] key;
	input sel;
	output [7:0] disp;
	output [3:0] ctrl;
	output [3:0] dis;
	
	wire nrst;
	assign nrst = ~rst;
	
	reg [15:0] data_in;
	reg [14:0] addr;
	reg writeEna;
	wire [15:0] data_out;
	
	wire [7:0] segDisp;
	wire [3:0] segCtrl;
	wire [7:0] segDisp_;
	wire [3:0] segCtrl_;
	reg [3:0] dis;
	
	reg [31:0] cnt;
	
	MyMemory mem(.in(data_in), .addr(addr), .wEna(writeEna), .inPKey(key), .out(data_out), .outPDisp(segDisp), .outPCtrl(segCtrl), .rst(nrst), .clk(clk));
	SegDisplayer seg(.in(data_out), .out(segDisp_), .sel(segCtrl_), .clk(clk));
	
	assign disp = sel ? segDisp : segDisp_;
	assign ctrl = sel ? segCtrl : segCtrl_;
	
	initial begin 		
		dis <= 4'b1111;
	end
	
	always @ (posedge clk) begin
		cnt <= cnt + 1;
	end
	
	always @ (posedge clk) begin
		if (cnt < 100) begin
			data_in <= 16'd2468;
			addr <= 15'b100_0000_0000_0000;
			writeEna <= 1'b1;
		end
		else begin
			addr <= 15'b000_0000_0000_0000;
			writeEna <= 1'b0;
		end
	end
endmodule
*/

/*
// ROM32K test
module TestBench(key, sel, disp, ctrl, dis, rst, clk);
	input clk;
	input rst;
	
	input [6:0] key;
	input sel;
	output [7:0] disp;
	output [3:0] ctrl;
	output [3:0] dis;
	
	wire nrst;
	assign nrst = ~rst;
	
	wire [15:0] outKey;
	wire [15:0] data_out;
	wire [7:0] segDisp;
	wire [3:0] segCtrl;
	reg [3:0] dis;
	
	KeyHandler prs(.in(key), .out(outKey), .clk(clk));
	ROM32K ins(.dina(16'b0), .addra(outKey[11:0]), .wea(1'b0), .douta(data_out), .clka(clk));
	SegDisplayer seg(.in(data_out), .out(segDisp), .sel(segCtrl), .clk(clk));
	
	assign disp = segDisp;
	assign ctrl = segCtrl;
	
	initial begin
		dis <= 4'b1111;
	end
endmodule
*/

/*
// ALU Test
module TestBench(key, sel, disp, ctrl, dis, rst, clk);
	input clk;
	input rst;
	
	input [6:0] key;
	input sel;
	output [7:0] disp;
	output [3:0] ctrl;
	output [3:0] dis;
	
	wire nrst;
	assign nrst = ~rst;
	
	wire [7:0] segDisp;
	wire [3:0] segCtrl;
	reg [3:0] dis;
	
	reg [15:0] x, y;
	reg [5:0] instr;
	wire [15:0] outALU;
	
	ALU alu(.x(x), .y(y), .instr(instr), .out(outALU));
	SegDisplayer seg(.in(outALU), .out(segDisp), .sel(segCtrl), .clk(clk));
	
	assign disp = segDisp;
	assign ctrl = segCtrl;
	
	initial begin
		dis <= 4'b1111;
		x <= 16'b0000001001100110;
		y <= 16'b0000001001100110;
		instr <= 6'b110000;
	end
endmodule
*/
