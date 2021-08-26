`timescale 1ns/10ps

module BRAM_tb;
	
	reg reset;
	reg clk;
	reg valid = 0;
	reg ready = 0;
	reg [11:0]data;
	reg [7:0]data_in;
	wire [7:0]d_out;
	
	
	BRAM UUT(
	.aclr(reset),
	.address(data),
	.clock(clk),
	.data(data_in),
	.rden(valid),
	.wren(ready),
	.q(d_out));
	
	initial begin
		clk = 0;
		reset = 0;
		#5 reset = 1;
		#3 reset = 0;
		#10 data = 12'd15;
		ready = 1;
		data_in = 8'd5;
		
		#20 ready = 0;
		data_in = 0;
		
		#10 data = 12'd0;
		#7 data = 12'd15;
		valid = 1;
		
	end


	always
		#5 clk = !clk;

endmodule 