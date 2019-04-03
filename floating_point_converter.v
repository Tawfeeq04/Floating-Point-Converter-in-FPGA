module floating_pt_converter(
input wire clk,
input wire [7:0] int,
input wire [2:0] point,
input wire sign,
output reg [31:0] data);

	reg [7:0] exp;
	reg [22:0] mantissa = 0;
	reg [2:0] count = 7;
	reg [2:0] ref = 0;
	reg signal = 0;
	reg conv = 0;
	reg [2:0] diff = 0;
	always @(posedge clk) begin
		if(int[count]==1 && signal == 0) begin
			ref <= count;
			signal <= 1;
		end
		if (ref <= point) begin
			diff <= point - ref;
			exp <= 127 - diff;
		end
		else begin
			diff <= ref - point;
			exp <= 127 + diff;
		end
		if (count == 0) begin
			count <= 7;
			signal <= 0;
		end
		if (count < ref) begin
			mantissa[22-count] <= int[7-count];
		end
		data[31] <= sign;
		data[30:23] <= exp;
		data[22:0] <= mantissa;
		count <= count - 1;
	end
endmodule
