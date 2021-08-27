/* 
 file name : top.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module top(
	input clk, 
	input reset,
	input m1_button1,
	input m1_button2,
	input m2_button1,
	input m2_button2,
	output m1_busy,
	output m2_busy);

// Wires in interconnect
wire m1_request; 
wire m2_request;
wire m1_slave_sel;
wire m2_slave_sel;
wire m1_grant;
wire m2_grant;
wire arbiter_busy;
wire m1_master_valid;
wire m1_tx_address;
wire m1_tx_data;
wire m1_rx_data;
wire m1_write_en;
wire m1_read_en;
wire m1_slave_ready;
wire m2_master_valid;
wire m2_tx_address;
wire m2_tx_data;
wire m2_rx_data;
wire m2_write_en;
wire m2_read_en;
wire m2_slave_ready;
wire s1_clk;
wire s1_rst;
wire s1_master_valid;
wire s1_rx_address;
wire s1_rx_data;
wire s1_tx_data;
wire s1_write_en;
wire s1_read_en;
wire s1_slave_ready;
wire s2_clk;
wire s2_rst;
wire s2_master_valid;
wire s2_rx_address;
wire s2_rx_data;
wire s2_tx_data;
wire s2_write_en;
wire s2_read_en;
wire s2_slave_ready;
wire s3_clk;
wire s3_rst;
wire s3_master_valid;
wire s3_rx_address;
wire s3_rx_data;
wire s3_tx_data;
wire s3_write_en;
wire s3_read_en;
wire s3_slave_ready;

// // slave
// wire slave_tx_done;
// wire rx_done;

// master
wire bus_busy;
wire m1_trans_done;
wire m2_trans_done;
wire trans_done = m1_trans_done || m2_trans_done;

//new master to slave connections
wire m1_master_ready;
wire m2_master_ready;
wire s1_master_ready;
wire s2_master_ready;
wire s3_master_ready;

wire m1_slave_valid;
wire m2_slave_valid;
wire s1_slave_valid;
wire s2_slave_valid;
wire s3_slave_valid;


//assign bus_busy=0;

//testing split
wire split_en;


master_module #(.SLAVE_LEN(2), .ADDR_LEN(12), .DATA_LEN(8)) MASTER1(
	.clk(clk), 
	.reset(reset),
	.button1(m1_button1),
	.button2(m1_button2),
	.busy(m1_busy),
	
	.arbitor_busy(arbiter_busy),
	.bus_busy(bus_busy),  //include in bus  ----> INCLUDED
	.approval_grant(m1_grant),
	.approval_request(m1_request),
	.tx_slave_select(m1_slave_sel),
	.trans_done(m1_trans_done), //include in bus  ----> INCLUDED
	
	.rx_data(m1_rx_data),
	.tx_address(m1_tx_address),
	.tx_data(m1_tx_data),
	
	.slave_valid(m1_slave_valid), //need port ----> INCLUDED
	.slave_ready(m1_slave_ready),
	.master_valid(m1_master_valid),
	.master_ready(m1_master_ready), //nead port ----> INCLUDED
	.write_en(m1_write_en),
	.read_en(m1_read_en));

master_module #(.SLAVE_LEN(2), .ADDR_LEN(12), .DATA_LEN(8)) MASTER2(
	.clk(clk), 
	.reset(reset),
	.button1(m2_button1),
	.button2(m2_button2),
	.busy(m2_busy),
	
	.arbitor_busy(arbiter_busy),
	.bus_busy(bus_busy),  //include in bus  ----> INCLUDED
	.approval_grant(m2_grant),
	.approval_request(m2_request),
	.tx_slave_select(m2_slave_sel),
	.trans_done(m2_trans_done), //include in bus  ----> INCLUDED
	
	.rx_data(m2_rx_data),
	.tx_address(m2_tx_address),
	.tx_data(m2_tx_data),
	
	.slave_valid(m2_slave_valid), //need port ----> INCLUDED
	.slave_ready(m2_slave_ready),
	.master_valid(m2_master_valid),
	.master_ready(m2_master_ready), //nead port ----> INCLUDED
	.write_en(m2_write_en),
	.read_en(m2_read_en));
	
Bus_interconnect BUS(
	.sys_clk(clk),
	.sys_rst(reset),
	.m1_request(m1_request), 
	.m2_request(m2_request),
	.m1_slave_sel(m1_slave_sel),
	.m2_slave_sel(m2_slave_sel),
	.trans_done(trans_done),
	
	.m1_grant(m1_grant),
	.m2_grant(m2_grant),
	.arbiter_busy(arbiter_busy),
	.bus_busy(bus_busy),
	
	.m1_clk(clk), 
	.m1_rst(reset),
	.m1_master_valid(m1_master_valid),
	.m1_master_ready(m1_master_ready),
	.m1_tx_address(m1_tx_address),
	.m1_tx_data(m1_tx_data),
	.m1_rx_data(m1_rx_data),
	.m1_write_en(m1_write_en),
	.m1_read_en(m1_read_en),
	.m1_slave_valid(m1_slave_valid),
	.m1_slave_ready(m1_slave_ready),
	
	.m2_clk(clk), 
	.m2_rst(reset),
	.m2_master_valid(m2_master_valid),
	.m2_master_ready(m2_master_ready),
	.m2_tx_address(m2_tx_address),
	.m2_tx_data(m2_tx_data),
	.m2_rx_data(m2_rx_data),
	.m2_write_en(m2_write_en),
	.m2_read_en(m2_read_en),
	.m2_slave_valid(m2_slave_valid),
	.m2_slave_ready(m2_slave_ready),
	
	.s1_clk(s1_clk), 
	.s1_rst(s1_rst),
	.s1_master_valid(s1_master_valid),
	.s1_master_ready(s1_master_ready),
	.s1_rx_address(s1_rx_address),
	.s1_rx_data(s1_rx_data),
	.s1_tx_data(s1_tx_data),
	.s1_write_en(s1_write_en),
	.s1_read_en(s1_read_en),
	.s1_slave_valid(s1_slave_valid),
	.s1_slave_ready(s1_slave_ready),
	
	.s2_clk(s2_clk), 
	.s2_rst(s2_rst),
	.s2_master_valid(s2_master_valid),
	.s2_master_ready(s2_master_ready),
	.s2_rx_address(s2_rx_address),
	.s2_rx_data(s2_rx_data),
	.s2_tx_data(s2_tx_data),
	.s2_write_en(s2_write_en),
	.s2_read_en(s2_read_en),
	.s2_slave_valid(s2_slave_valid),
	.s2_slave_ready(s2_slave_ready),
	
	.s3_clk(s3_clk), 
	.s3_rst(s3_rst),
	.s3_master_valid(s3_master_valid),
	.s3_master_ready(s3_master_ready),
	.s3_rx_address(s3_rx_address),
	.s3_rx_data(s3_rx_data),
	.s3_tx_data(s3_tx_data),
	.s3_write_en(s3_write_en),
	.s3_read_en(s3_read_en),
	.s3_slave_valid(s3_slave_valid),
	.s3_slave_ready(s3_slave_ready));

slave_4k SLAVE_4K(
	.clk(clk), 
	.reset(reset),

	.read_en(s1_read_en),
	.write_en(s1_write_en),

	.master_ready(s1_master_ready),//need port ----> INCLUDED
	.master_valid(s1_master_valid),

	.slave_valid(s1_slave_valid),//need port -----> INCLUDED
	.slave_ready(s1_slave_ready),

	.rx_address(s1_rx_address),
	.rx_data(s1_rx_data),
	.tx_data(s1_tx_data),
	.split_en(split_en));

slave_4k SLAVE_2K1(
	.clk(clk), 
	.reset(reset),

	.read_en(s2_read_en),
	.write_en(s2_write_en),

	.master_ready(s2_master_ready),//need port ----> INCLUDED
	.master_valid(s2_master_valid),

	.slave_valid(s2_slave_valid),//need port -----> INCLUDED
	.slave_ready(s2_slave_ready),

	.rx_address(s2_rx_address),
	.rx_data(s2_rx_data),				
	.tx_data(s2_tx_data),
	.split_en(split_en));

slave_4k SLAVE_2K2(
	.clk(clk), 
	.reset(reset),

	.read_en(s3_read_en),
	.write_en(s3_write_en),

	.master_ready(s3_master_ready),//need port ----> INCLUDED
	.master_valid(s3_master_valid),

	.slave_valid(s3_slave_valid),//need port -----> INCLUDED
	.slave_ready(s3_slave_ready),

	.rx_address(s3_rx_address),
	.rx_data(s3_rx_data),					
	.tx_data(s3_tx_data),
	.split_en(split_en));

endmodule