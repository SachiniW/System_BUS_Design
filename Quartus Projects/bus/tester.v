module tester(
	input clk2,
	input clock_en,
	input start,
	input valid,
	input ready,
	input reset,
	input [11:0]data,
	output clk_LED,
	output idle_out,
	output done_out,
	output [6:0]data_bus,
	output [6:0]address_bus,
	output [7:0]data_reg,
	output [11:0]address_reg,
	output [6:0]state_outTX,
	output [6:0]state_outRX
);


wire clk;
wire addr;
wire [4:0]state_outTX1;
wire [4:0]state_outRX1;

scaledclock clock(.inclk(clk2),
		.ena(clock_en),
		.clk(clk));
		
assign clk_LED = clk;

addr_state_machine receiver(
		.clk(clk), 
		.reset(reset),
		.rx_address(addr),
		.valid(valid),
		.ready(ready),
		.idle_out(idle_out),
	   .done_out(done_out),
		.state_out(state_outRX1),
		.address(address_reg));
		
txdata_state_machine transmitter(
		.clk(clk), 
		.reset(reset),
		.valid(valid),
		.start(start),
		.ready(ready),
		.datain(data),
		.state_out(state_outTX1),
		.tx_address(addr));
		
bin27 display_state_TX(.clock(),
		.reset(),
		.io_bin(state_outTX1),
		.io_seven(state_outTX));
		
bin27 display_state_RX(.clock(),
		.reset(),
		.io_bin(state_outRX1),
		.io_seven(state_outRX));
	
bin27 display_data_bus(.clock(),
		.reset(),
		.io_bin(addr),
		.io_seven(address_bus));
		

endmodule
