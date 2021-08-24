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
	input button1,
	input button2,
	output busy);

// Wires in interconnect
wire m1_request; 
wire m2_request;
wire m1_slave_sel;
wire m2_slave_sel;
wire m1_grant;
wire m2_grant;
wire arbiter_busy;
wire m1_valid;
wire m1_tx_address;
wire m1_tx_data;
wire m1_rx_data;
wire m1_write_en;
wire m1_read_en;
wire m1_slave_ready;
wire m2_valid;
wire m2_tx_address;
wire m2_tx_data;
wire m2_rx_data;
wire m2_write_en;
wire m2_read_en;
wire m2_slave_ready;
wire s1_clk;
wire s1_rst;
wire s1_valid;
wire s1_rx_address;
wire s1_rx_data;
wire s1_tx_data;
wire s1_write_en;
wire s1_read_en;
wire s1_slave_ready;
wire s2_clk;
wire s2_rst;
wire s2_valid;
wire s2_rx_address;
wire s2_rx_data;
wire s2_tx_data;
wire s2_write_en;
wire s2_read_en;
wire s2_slave_ready;
wire s3_clk;
wire s3_rst;
wire s3_valid;
wire s3_rx_address;
wire s3_rx_data;
wire s3_tx_data;
wire s3_write_en;
wire s3_read_en;
wire s3_slave_ready;

// slave
wire slave_tx_done;
wire rx_done;

// master
wire bus_busy;
wire trans_done;

//master to slave direct connections
wire slave_valid;
wire master_ready;

assign bus_busy=0;


master_module #(.SLAVE_LEN(2), .ADDR_LEN(12), .DATA_LEN(8)) MASTER1(
	.clk(clk), 
	.reset(reset),
	.button1(button1),
	.button2(button2),
	.busy(busy),
	
	.arbitor_busy(arbiter_busy),
	.bus_busy(bus_busy),  //include in bus
	.approval_grant(m1_grant),
	.approval_request(m1_request),
	.tx_slave_select(m1_slave_sel),
	.trans_done(trans_done), //include in bus
	
	.rx_data(m1_rx_data),
	.tx_address(m1_tx_address),
	.tx_data(m1_tx_data),
	
	.slave_valid(slave_valid), //need port
	.slave_ready(m1_slave_ready),
	.master_valid(m1_valid),
	.master_ready(master_ready), //nead port
	.write_en(m1_write_en),
	.read_en(m1_read_en));
	
Bus_interconnect BUS(
	.sys_clk(clk),
	.sys_rst(reset),
	.m1_request(m1_request), 
	.m2_request(m2_request),
	.m1_slave_sel(m1_slave_sel),
	.m2_slave_sel(m2_slave_sel),
	
	.m1_grant(m1_grant),
	.m2_grant(m2_grant),
	.arbiter_busy(arbiter_busy),
	
	.m1_clk(clk), 
	.m1_rst(reset),
	.m1_valid(m1_valid),
	.m1_tx_address(m1_tx_address),
	.m1_tx_data(m1_tx_data),
	.m1_rx_data(m1_rx_data),
	.m1_write_en(m1_write_en),
	.m1_read_en(m1_read_en),
	.m1_slave_ready(m1_slave_ready),
	
	.m2_clk(clk), 
	.m2_rst(reset),
	.m2_valid(m2_valid),
	.m2_tx_address(m2_tx_address),
	.m2_tx_data(m2_tx_data),
	.m2_rx_data(m2_rx_data),
	.m2_write_en(m2_write_en),
	.m2_read_en(m2_read_en),
	.m2_slave_ready(m2_slave_ready),
	
	.s1_clk(s1_clk), 
	.s1_rst(s1_rst),
	.s1_valid(s1_valid),
	.s1_rx_address(s1_rx_address),
	.s1_rx_data(s1_rx_data),
	.s1_tx_data(s1_tx_data),
	.s1_write_en(s1_write_en),
	.s1_read_en(s1_read_en),
	.s1_slave_ready(s1_slave_ready),
	
	.s2_clk(s2_clk), 
	.s2_rst(s2_rst),
	.s2_valid(s2_valid),
	.s2_rx_address(s2_rx_address),
	.s2_rx_data(s2_rx_data),
	.s2_tx_data(s2_tx_data),
	.s2_write_en(s2_write_en),
	.s2_read_en(s2_read_en),
	.s2_slave_ready(s2_slave_ready),
	
	.s3_clk(s3_clk), 
	.s3_rst(s3_rst),
	.s3_valid(s3_valid),
	.s3_rx_address(s3_rx_address),
	.s3_rx_data(s3_rx_data),
	.s3_tx_data(s3_tx_data),
	.s3_write_en(s3_write_en),
	.s3_read_en(s3_read_en),
	.s3_slave_ready(s3_slave_ready));

slave_4k SLAVE_4K(
	.clk(clk), 
	.reset(reset),

	.read_en(s1_read_en),
	.write_en(s1_write_en),

	.master_ready(master_ready),//need port
	.master_valid(s1_valid),

	.slave_valid(slave_valid),//need port
	.slave_ready(s1_slave_ready),

	.rx_address(s1_rx_address),
	.rx_data(s1_rx_data),

	.slave_tx_done(slave_tx_done),  //not used
	.rx_done(rx_done),					//not used
	.tx_data(s1_tx_data));

endmodule