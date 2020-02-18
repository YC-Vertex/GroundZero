module SegSingle(in, out);
	input [3:0] in;
	output [7:0] out;
	
	reg [7:0] out;
	
	always @ (*) begin
		case(in)
			4'd0: out = 8'hc0;
			4'd1: out = 8'hf9;
			4'd2: out = 8'ha4;
			4'd3: out = 8'hb0;
			4'd4: out = 8'h99;
			4'd5: out = 8'h92;
			4'd6: out = 8'h82;
			4'd7: out = 8'hf8;
			4'd8: out = 8'h80;
			4'd9: out = 8'h90;
			default: out = 8'hff;
		endcase
	end
endmodule

module SegDisplayer(in, out, sel, clk);
	input clk;
	input [15:0] in;
	output [7:0] out;
	output [3:0] sel;
	
	wire [7:0] out;
	reg [3:0] selinv;
	wire [3:0] sel;
	assign sel = ~selinv;
	
	reg [15:0] num;
	reg [3:0] bcdCode;
	reg [15:0] cnt;
	wire enable;
	SegSingle seg(.in(bcdCode), .out(out));
	
	initial begin
		selinv <= 4'b0001;
		num <= 0;
	end
	
	always @ (posedge clk) begin
		if (cnt[15] == 1'b1) 
			cnt <= 0;
		else
			cnt <= cnt + 1;
	end
		
	assign enable = cnt[15];
	
	always @ (posedge clk) begin
		if (enable) begin
			if (selinv == 4'b1000)
				selinv = 4'b0001;
			else
				selinv = selinv << 1;
				
			if (selinv == 4'b0001)
				num = in;
			else
				num = num / 10;
			bcdCode = num % 10;
		end
	end
endmodule



module KeyHandler(in, out, clk);
	input clk;
	input [6:0] in;
	output [15:0] out;
	
	reg [15:0] out;
	wire [6:0] inInv;
	assign inInv = ~in;

	always @ (*) begin
		case (inInv)
			7'b000_0001: out <= 16'd1;
			7'b000_0010: out <= 16'd2;
			7'b000_0100: out <= 16'd3;
			7'b000_1000: out <= 16'd4;
			7'b001_0000: out <= 16'd5;
			7'b010_0000: out <= 16'd6;
			7'b100_0000: out <= 16'd7;
			default: out <= 16'd0;
		endcase
	end
endmodule

/*
module KeyHandler(add, sub, rst, data, clk);
	input clk;
	input add, sub, rst;
	output [15:0] data;
	
	reg [15:0] data;
	reg [23:0] cnt;
	reg flagStart;
	reg flagQuick;
	
	initial begin
		flagStart <= 0;
		flagQuick <= 0;
	end
	
	always @ (posedge clk) begin
		if (!add || !sub) begin
			flagStart = 1;
		end
		else begin
			flagStart = 0;
			flagQuick = 0;
			cnt <= 0;
		end
	
		if (flagStart) begin
			cnt <= cnt + 1;
		end
		
		if (flagStart && cnt[23]) begin
			cnt <= 0;
			flagQuick = 1;
		end
		if (flagQuick & cnt[21]) begin
			cnt <= 0;
		end
	end
	
	always @ (posedge clk) begin
		if (!rst)
			data <= 16'd0;
		else begin
			if ((flagStart && !flagQuick && cnt == 24'd10) || (flagQuick && cnt[21])) begin
				if (!add && data != 16'd9999)
					data <= data + 1;
				if (!sub && data != 16'd0)
					data <= data - 1;
			end
		end
	end
endmodule
*/