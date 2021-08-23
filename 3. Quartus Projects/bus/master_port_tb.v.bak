`timescale 1ns/10ps

module slave_port_tb;

reg clk; 
reg reset;

reg read_en;
reg write_en;

reg master_ready;
reg master_valid;

wire slave_valid;
wire slave_ready;

reg rx_address;
reg rx_data;

wire slave_tx_done;
wire rx_done;
wire tx_data;


reg [7:0]datain;
wire[11:0]address;
wire[7:0]data;


slave_port UUT(
	.clk(clk), 
	.reset(reset),
	.read_en(read_en),
	.write_en(write_en),
	.master_ready(master_ready),
	.master_valid(master_valid),
	.slave_valid(slave_valid),
	.slave_ready(slave_ready),
	.rx_address(rx_address),
	.rx_data(rx_data),
	.slave_tx_done(slave_tx_done),
	.rx_done(rx_done),
	.tx_data(tx_data),
	.datain(datain),
	.address(address),
	.data(data));
	
	initial begin
	
		clk = 0; 
		reset = 0;
		read_en = 0;
		write_en = 0;
		master_ready = 0;
		master_valid = 0;
		rx_address = 0;
		rx_data = 0;
		datain = 8'd0;
		
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
		
		
		#200

		datain = 8'b11001100;
		#15
		master_ready = 1;
		#10 
		master_ready = 0;

	end
	
	always
		#5 clk = !clk;

endmodule 
