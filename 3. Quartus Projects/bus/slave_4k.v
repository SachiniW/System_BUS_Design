/* 
 file name : slave_4k.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module slave_4k(
	input clk, 
	input reset,

	input read_en,
	input write_en,

	input master_ready,
	input master_valid,

	output slave_valid,
	output slave_ready,

	input rx_address,
	input rx_data,
	output [7:0]data_out,   ////temp
	output [3:0]temp_state, ///temp
	output temp_signal, ///temp

	// output slave_tx_done,
	// output rx_done,
	output tx_data,
	output split_en);
	
	
wire [7:0]datain;
wire [11:0]address;
wire [7:0]data;
	
assign data_out = data;   ///temp

	slave_port SLAVE_PORT(
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
	// .slave_tx_done(slave_tx_done),
	// .rx_done(rx_done),
	.tx_data(tx_data),
	.datain(datain),
	.address(address),
	.data(data),
	.temp_state(temp_state),  ////temp
	.temp_signal(temp_signal),  /////temp
	.read_en_in(read_en_in),
	.write_en_in(write_en_in),
	.split_en(split_en));
	
	BRAM BRAM(
	.aclr(reset),
	.address(address),
	.clock(clk),
	.data(data),
	.rden(read_en_in),
	.wren(write_en_in),
	.q(datain));
	
	
endmodule 