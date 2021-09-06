/* 
 file name : top2.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module top2(
	input clock,	
	input rst,
	input enable,
	input button1_raw,
	input button2_raw,
	input button3_raw,
	input [11:0]switch_array,
	input mode_switch,
	input rw_switch1,
	input rw_switch2,
	output scaled_clk,
	output m1_busy,
	output m2_busy,
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	output [6:0]display3_pin,
	output [6:0]display4_pin,
	output [6:0]display5_pin,
	output [6:0]display6_pin,
	output [6:0]display7_pin,
	output [6:0]display8_pin
	
//	output LCD_ON,	// LCD Power ON/OFF
//   output LCD_BLON,	// LCD Back Light ON/OFF
//   output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
//   output LCD_EN,	// LCD Enable
//   output LCD_RS,	// LCD Command/Data Select, 0 = Command, 1 = Data
//   inout [7:0] LCD_DATA	// LCD Data bus 8 bits
	);
	
parameter SLAVE_LEN=2; 
parameter ADDR_LEN=12; 
parameter DATA_LEN=8;
parameter BURST_LEN=12;

/***********************************************************/
//Change when switching between FPGA and testbench

//FPGA
//parameter CLKS_PER_BIT=2604;    //Baudrate= 19200, Input clock = 50MHz
//parameter MAX_COUNT_CLK=50000000;	//Clock slow enough to see values getting updated
//parameter MAX_COUNT_TIMEOUT=50000; // 1ms timeout with 50MHz input clock

//Testbench
parameter CLKS_PER_BIT=20;  //Fast enough to reduce testbench time
parameter MAX_COUNT_CLK=4;	//Fast enough to reduce testbench time
parameter MAX_COUNT_TIMEOUT=100; //Fast enough to reduce testbench time

/***********************************************************/

// UART wires
wire i_uart_rx;
wire i_uart_tx;
wire o_uart_rx;
wire o_uart_tx;
assign i_uart_rx = o_uart_tx;
assign o_uart_rx = i_uart_tx;
	
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
wire m1_tx_burst_num;
wire m1_rx_data;
wire m1_write_en;
wire m1_read_en;
wire m1_slave_ready;
wire m2_master_valid;
wire m2_tx_address;
wire m2_tx_data;
wire m2_tx_burst_num;
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
wire s1_slave_split_en;
wire s2_slave_split_en;
wire s3_slave_split_en;

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

// command processor to master
wire read1;
wire write1;
wire [DATA_LEN-1:0]data1;
wire [ADDR_LEN:0]address1;
wire [SLAVE_LEN-1:0]slave1;
wire [BURST_LEN:0]burst_num1;
wire read2;
wire write2;
wire [DATA_LEN-1:0]data2;
wire [ADDR_LEN:0]address2;
wire [SLAVE_LEN-1:0]slave2;
wire [BURST_LEN:0]burst_num2;
wire [3:0]config_state;//to LCD display

// output port conversions
wire reset, button1, button2, button3, clk_uart, clk;
assign reset = ~rst;
assign scaled_clk = clk;
assign clk_uart = clock && enable;
assign button1 = ~button1_raw;
assign button2 = ~button2_raw;
assign button3 = ~button3_raw;

scaledclock #(.maxcount(MAX_COUNT_CLK)) CLK_DIV(.inclk(clock), .ena(enable), .clk(clk));

//LCD_in LCD(
//	.clock(clock),
//	.rst(rst),
//	.Data_Line1(address1),
//	.Data_Line2(data1),
//	.config_state(config_state),
//	.mode_switch(mode_switch),
//   .LCD_ON(LCD_ON),	
//   .LCD_BLON(LCD_BLON),	
//   .LCD_RW(LCD_RW),	
//   .LCD_EN(LCD_EN),	
//   .LCD_RS(LCD_RS),	
//   .LCD_DATA(LCD_DATA));
	
//command_processor #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN)) COMMAND(
//	.clk(clk), 
//	.reset(reset),
//	.button1(button1),
//	.button2(button2),
//	.button3(button3),
//	.switch_array(switch_array),
//	.mode_switch(mode_switch),
//	.rw_switch1(rw_switch1),
//	.rw_switch2(rw_switch2),
//	.display1_pin(display1_pin),
//	.display2_pin(display2_pin),
//	.display3_pin(display3_pin),
//	.display4_pin(display4_pin),
//	.display_val4(config_state),
//
//	.read1(read1),
//	.write1(write1),
//	.data1(data1),
//	.address1(address1),
//	.slave1(slave1),
//	.burst_num1(burst_num1),
//	.read2(read2),
//	.write2(write2),
//	.data2(data2),
//	.address2(address2),
//	.slave2(slave2),
//	.burst_num2(burst_num2));

bridge_module #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN),
					.CLKS_PER_BIT(CLKS_PER_BIT), .MAX_COUNT(MAX_COUNT_TIMEOUT)) INPUT_BRIDGE(
	.clk(clk_uart), 
	.reset(reset),
	.bus_clk(clk),
	
	//UART	
	
   .u_rx_data(i_uart_rx),
   .u_tx_data(i_uart_tx),
	
	//MASTER
	
	.m_arbitor_busy(arbiter_busy),
	.m_bus_busy(bus_busy),
	.m_approval_grant(m1_grant),
	.m_approval_request(m1_request),
	.m_tx_slave_select(m1_slave_sel),
	.m_trans_done(m1_trans_done),
	
	.m_rx_data(m1_rx_data),
	.m_tx_address(m1_tx_address),
	.m_tx_data(m1_tx_data),
	.m_tx_burst_num(m1_tx_burst_num),
	
	.m_slave_valid(m1_slave_valid),
	.m_slave_ready(m1_slave_ready),
	.m_master_valid(m1_master_valid),
	.m_master_ready(m1_master_ready),
	.m_write_en(m1_write_en),
	.m_read_en(m1_read_en));
	
//	//SLAVE
//	
//	.s_slave_delay(6'd0),
//	.s_read_en(s2_read_en),
//	.s_write_en(s2_write_en),
//	.s_master_ready(s2_master_ready),
//	.s_master_valid(s2_master_valid),
//	.s_slave_valid(s2_slave_valid),
//	.s_slave_ready(s2_slave_ready),
//	.s_rx_address(s2_rx_address),
//	.s_rx_data(s2_rx_data),
//	.s_rx_burst(s2_rx_burst_num),
//	.s_split_en(s2_split_en),
//	.s_tx_data(s2_tx_data));	

bridge_module #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN),
					.CLKS_PER_BIT(CLKS_PER_BIT), .MAX_COUNT(MAX_COUNT_TIMEOUT)) OUTPUT_BRIDGE(
	.clk(clk_uart), 
	.reset(reset),
	.bus_clk(clk),
	
	//UART	
	
   .u_rx_data(o_uart_rx),
   .u_tx_data(o_uart_tx),
	
//	//MASTER
//	
//	.m_arbitor_busy(arbiter_busy),
//	.m_bus_busy(bus_busy),
//	.m_approval_grant(m1_grant),
//	.m_approval_request(m1_request),
//	.m_tx_slave_select(m1_slave_sel),
//	.m_trans_done(m1_trans_done),
//	
//	.m_rx_data(m1_rx_data),
//	.m_tx_address(m1_tx_address),
//	.m_tx_data(m1_tx_data),
//	.m_tx_burst_num(m1_tx_burst_num),
//	
//	.m_slave_valid(m1_slave_valid),
//	.m_slave_ready(m1_slave_ready),
//	.m_master_valid(m1_master_valid),
//	.m_master_ready(m1_master_ready),
//	.m_write_en(m1_write_en),
//	.m_read_en(m1_read_en),

	//SLAVE
	
	.s_slave_delay(6'd0),
	.s_read_en(s2_read_en),
	.s_write_en(s2_write_en),
	.s_master_ready(s2_master_ready),
	.s_master_valid(s2_master_valid),
	.s_slave_valid(s2_slave_valid),
	.s_slave_ready(s2_slave_ready),
	.s_rx_address(s2_rx_address),
	.s_rx_data(s2_rx_data),
	.s_rx_burst(s2_rx_burst_num),
	.s_split_en(s2_split_en),
	.s_tx_data(s2_tx_data));

increment_module #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN)) INCREMENT(
	.clk(clk), 
	.reset(reset),
	.busy(m2_busy),
	.display1_pin(display7_pin),
	.display2_pin(display8_pin),
	
	.button(button1),
	.sw_array_data(switch_array[7:0]),
	
	//MASTER
	
	.m_arbitor_busy(arbiter_busy),
	.m_bus_busy(bus_busy),  
	.m_approval_grant(m2_grant),
	.m_approval_request(m2_request),
	.m_tx_slave_select(m2_slave_sel),
	.m_trans_done(m2_trans_done), 
	
	.m_rx_data(m2_rx_data),
	.m_tx_address(m2_tx_address),
	.m_tx_data(m2_tx_data),
	.m_tx_burst_num(m2_tx_burst_num),
	
	.m_slave_valid(m2_slave_valid),
	.m_slave_ready(m2_slave_ready),
	.m_master_valid(m2_master_valid),
	.m_master_ready(m2_master_ready),
	.m_write_en(m2_write_en),
	.m_read_en(m2_read_en),
	
	//SLAVE
	
	.s_slave_delay(6'd0),
	.s_read_en(s1_read_en),
	.s_write_en(s1_write_en),
	.s_master_ready(s1_master_ready),
	.s_master_valid(s1_master_valid),
	.s_slave_valid(s1_slave_valid),
	.s_slave_ready(s1_slave_ready),
	.s_rx_address(s1_rx_address),
	.s_rx_data(s1_rx_data),
	.s_rx_burst(s1_rx_burst_num),
	.s_split_en(s1_split_en),
	.s_tx_data(s1_tx_data));
	
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
	.s3_slave_ready(s3_slave_ready),
	
	.s1_slave_split_en(s1_slave_split_en),
	.s2_slave_split_en(s2_slave_split_en),
	.s3_slave_split_en(s3_slave_split_en),

	.m1_tx_burst_num(m1_tx_burst_num),
	.m2_tx_burst_num(m2_tx_burst_num),

	.s1_rx_burst_num(s1_rx_burst_num),
	.s2_rx_burst_num(s2_rx_burst_num),
	.s3_rx_burst_num(s3_rx_burst_num));

endmodule