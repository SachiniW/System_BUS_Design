`timescale 1ns/10ps

module stemachine_tb;

	reg clk;
	reg reset;
	reg rx_address;
	reg valid;
	reg ready;
	wire [11:0]address;

	addr_state_machine UUT(
		.clk(clk), 
		.reset(reset),
		.rx_address(rx_address),
		.valid(valid),
		.ready(ready),
		.address(address));

	initial begin
		clk = 0;
		reset = 0;
		rx_address = 0;
		valid = 0;
		ready = 0;
		
		#15
		valid = 1;
		ready = 1;
		rx_address = 1;
		#10 rx_address = 0;
		valid = 0;
		ready = 0;
		#10 rx_address = 1;
		#10 rx_address = 0;
		#10 rx_address = 1;
		#10 rx_address = 0;
		#10 rx_address = 1;
		#10 rx_address = 0;
		#10 rx_address = 1;
		#10 rx_address = 1;
		#10 rx_address = 1;
		#10 rx_address = 0;
		#10 rx_address = 1;
	end


	always
		#5 clk = !clk;

endmodule 