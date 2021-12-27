module BRAM_test(
	input clk2,
	input clock_en,
	input reset,
	input [11:0]data,
	input [7:0]data_in,
	input valid,
	input ready,
	output clk_LED,
	output [6:0]state_outTX,
	output [6:0]state_outRX);
	
wire clk;
wire [7:0]d_out;
assign clk_LED = clk;

scaledclock clock(.inclk(clk2),
		.ena(clock_en),
		.clk(clk));

BRAM BRAM(
	.aclr(reset),
	.address(data),
	.clock(clk),
	.data(data_in),
	.rden(valid),
	.wren(ready),
	.q(d_out));
	
bin27 display_state_TX(.clock(),
		.reset(),
		.io_bin(d_out[3:0]),
		.io_seven(state_outTX));
		
bin27 display_state_RX(.clock(),
		.reset(),
		.io_bin(d_out[7:4]),
		.io_seven(state_outRX));
		
endmodule
