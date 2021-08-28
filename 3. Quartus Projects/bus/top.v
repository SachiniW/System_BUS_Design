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
	input clock, 
	input rst,
	input ena,
	input button1_val,
	input button2_val,
	input button1_sel,
	input button2_sel,
	output clkLED,
	output m1_busy,
	output m2_busy,
	output slave_ready,
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	output [6:0]display3_pin,
	output [6:0]display4_pin,
	output [6:0]display5_pin,
	output [6:0]display6_pin,
	output [6:0]display7_pin,
	output [6:0]display8_pin);


//wire m1_busy1;
//wire m2_busy2;

//assign m1_busy = m1_button1;
//assign m2_busy = m1_button2;
	
	
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

wire reset;

assign reset = ~rst;

scaledclock CLK_DIV(.inclk(clock), .ena(ena), .clk(clk));
assign clkLED = clk;

wire m1_button1;
wire m1_button2;
wire m2_button1;
wire m2_button2;

assign m1_button1 = (button1_sel == 1) ? 1:button1_val;
assign m1_button2 = (button1_sel == 1) ? button1_val:1;
assign m2_button1 = (button2_sel == 1) ? 1:button2_val;
assign m2_button2 = (button2_sel == 1) ? button2_val:1;


wire [7:0] data_out1, data_out2, data_out3;  /////////////temp

wire [3:0] temp_state1, temp_state2, temp_state3;  /////////////temp

wire temp_signal1, temp_signal2, temp_signal3;  /////////////temp

wire m2_busy1;   /////temp
assign m2_busy = temp_signal1; //temp  
assign slave_ready = s1_slave_ready; ////temp

wire [3:0]s1_data_state;
wire [3:0]s1_addr_state;
wire [3:0]s2_data_state;
wire [3:0]s2_addr_state;
wire [3:0]s3_data_state;
wire [3:0]s3_addr_state;
wire [3:0]s1_data_counter;
wire [3:0]s1_addr_counter;

bin27 DISPLAY5 (.clock(0), .reset(0), .io_bin(s1_data_state), .io_seven(display5_pin));
bin27 DISPLAY6 (.clock(0), .reset(0), .io_bin(s1_addr_state), .io_seven(display6_pin));
bin27 DISPLAY7 (.clock(0), .reset(0), .io_bin(s1_data_counter), .io_seven(display7_pin));
bin27 DISPLAY8 (.clock(0), .reset(0), .io_bin(s1_addr_counter), .io_seven(display8_pin));

master_module #(.SLAVE_LEN(2), .ADDR_LEN(12), .DATA_LEN(8)) MASTER1(
	.clk(clk), 
	.reset(reset),
	.button1(m1_button1),
	.button2(m1_button2),
	.busy(m1_busy),
	.display1_pin(display1_pin),
	.display2_pin(display2_pin),
	
	.data_out1(0),    ////////////temp
	.temp_state1(0),    ////////////temp
	
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
	.busy(m2_busy1), //////changed
	.display1_pin(display3_pin),
	.display2_pin(display4_pin),
	
	.data_out1(0),   ////////////temp
	.temp_state1(0),    ////////////temp
	
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
	.data_out(data_out1),    ////temp
	.temp_data_state(s1_data_state),    ////temp
	.temp_addr_state(s1_addr_state),    ////temp
	.temp_data_counter(s1_data_counter),    ////temp
	.temp_addr_counter(s1_addr_counter),    ////temp
	.temp_signal(temp_signal1),  /////temp
	
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
	.data_out(data_out2),    ////temp
	.temp_data_state(s2_data_state),    ////temp
	.temp_addr_state(s2_addr_state),    ////temp
	.temp_data_counter(),    ////temp
	.temp_addr_counter(),    ////temp
	.temp_signal(temp_signal2),  /////temp			
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
	.data_out(data_out3),    ////temp	
	.temp_data_state(s3_data_state),    ////temp
	.temp_addr_state(s3_addr_state),    ////temp
	.temp_data_counter(),    ////temp
	.temp_addr_counter(),    ////temp
	.temp_signal(temp_signal3),  /////temp			
	.tx_data(s3_tx_data),
	.split_en(split_en));

endmodule