`timescale 1ns/10ps

module slave_in_port_tb;
	
	reg clk; 
	reg reset;
	reg rx_address;
	reg rx_data;
	reg master_valid;
	reg read_en;
	reg write_en;
	wire slave_ready;
	wire rx_done;
	wire [11:0]address;
	wire [7:0]data;
	
	slave_in_port UUT(
		.clk(clk), 
		.reset(reset),
		.rx_address(rx_address),
		.rx_data(rx_data),
		.master_valid(master_valid),
		.read_en(read_en),
		.write_en(write_en),
		.slave_ready(slave_ready),
		.rx_done(rx_done),
		.address(address),
		.data(data));

	initial begin
		clk = 0;
		reset = 0;
		rx_address = 0;
		master_valid = 0;
		read_en = 0;
		
		#15
		master_valid = 1;
		write_en = 1;
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 0;
		rx_data = 0;
		write_en = 0;
		#10 
		rx_address = 1;
		rx_data = 0;
		#10 
		rx_address = 0;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 0;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 0;
		#10
		rx_address = 1;
		#10 
		rx_address = 0;
		#10 
		rx_address = 0;
		#10 
		rx_address = 1;
		master_valid = 0;



		#500
		master_valid = 1;
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 0;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		rx_data = 1;
		#10 
		rx_address = 1;
		#10 
		rx_address = 1;
		#10 
		rx_address = 1;
		#10 
		rx_address = 1;
		master_valid = 0;
	end


	always
		#5 clk = !clk;

endmodule 