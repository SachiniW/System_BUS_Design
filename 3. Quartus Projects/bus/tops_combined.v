/* 
 file name : tops_combined.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

//`define EXTERNAL

module tops_combined(
	input clock,
	input rst,	
	input rst_sel1,
	input rst_sel2,
	input rst_sel3,
	input enable1,
	input enable2,
	input enable3,
	input button_raw1,
	input button_raw2,
	input button_raw3,
	input [7:0]switch_array,
	input mode_switch1,
	input mode_switch2,
	input mode_switch3,
	output scaled_clk1,
	output scaled_clk2,
	output scaled_clk3,

	
	`ifdef EXTERNAL
	
		input  bi_uart_rx1,
		input  bo_uart_rx1,
		output bi_uart_tx1,
		output bo_uart_tx1,
		input  bi_uart_rx2,
		input  bo_uart_rx2,
		output bi_uart_tx2,
		output bo_uart_tx2,
		input  bi_uart_rx3,
		input  bo_uart_rx3,
		output bi_uart_tx3,
		output bo_uart_tx3,
	
	`endif

	output [6:0]display1_pin,
	output [6:0]display2_pin,
	output [6:0]display3_pin,
	output [6:0]display4_pin,
	output [6:0]display5_pin,
	output [6:0]display6_pin,
	output [6:0]display7_pin,
	output [6:0]display8_pin
	
//	  output LCD_ON,	// LCD Power ON/OFF
//   output LCD_BLON,	// LCD Back Light ON/OFF
//   output LCD_RW,	// LCD Read/Write Select, 0 = Write, 1 = Read
//   output LCD_EN,	// LCD Enable
//   output LCD_RS,	// LCD Command/Data Select, 0 = Command, 1 = Data
//   inout [7:0] LCD_DATA	// LCD Data bus 8 bits
	);


wire rst1, rst2, rst3;
assign rst1 = ~rst_sel1 || rst;
assign rst2 = ~rst_sel2 || rst;
assign rst3 = ~rst_sel3 || rst;

wire [6:0]display1_pin1;
wire [6:0]display2_pin1;
wire [6:0]display1_pin2;
wire [6:0]display2_pin2;
wire [6:0]display1_pin3;
wire [6:0]display2_pin3;

assign display7_pin = display1_pin1;
assign display8_pin = display2_pin1;
assign display5_pin = display1_pin2;
assign display6_pin = display2_pin2;
assign display3_pin = display1_pin3;
assign display4_pin = display2_pin3;

/*********************************************/
//Changing clocks for the three modules

wire clk1, clk2, clk3;
assign clk1 = ~clock;
assign clk2 = clock;
//assign clk3 = clock;

scaledclock #(.maxcount(1)) CLK_DIV(.inclk(clock), .ena(1), .clk(clk3));

parameter MAX_COUNT_CLK1 = 10000000;
parameter MAX_COUNT_CLK2 =  5000000;
parameter MAX_COUNT_CLK3 =  2500000;
parameter CLKS_PER_BIT1 = 2604;
parameter CLKS_PER_BIT2 = 2604;
parameter CLKS_PER_BIT3 = 1302;
parameter MAX_COUNT_TIMEOUT1 = 50000;
parameter MAX_COUNT_TIMEOUT2 = 50000;
parameter MAX_COUNT_TIMEOUT3 = 25000;

/*********************************************/


`ifndef EXTERNAL

	wire bi_uart_rx1;
	wire bo_uart_rx1;
	wire bi_uart_tx1;
	wire bo_uart_tx1;
	wire bi_uart_rx2;
	wire bo_uart_rx2;
	wire bi_uart_tx2;
	wire bo_uart_tx2;
	wire bi_uart_rx3;
	wire bo_uart_rx3;
	wire bi_uart_tx3;
	wire bo_uart_tx3;
	
	assign bi_uart_rx1 = bo_uart_tx3;
	assign bi_uart_rx3 = bo_uart_tx2;
	assign bi_uart_rx2 = bo_uart_tx1;
	assign bo_uart_rx1 = bi_uart_tx2;
	assign bo_uart_rx2 = bi_uart_tx3;
	assign bo_uart_rx3 = bi_uart_tx1;
	
`endif


top2 #(.MAX_COUNT_CLK(MAX_COUNT_CLK1), .CLKS_PER_BIT(CLKS_PER_BIT1), .MAX_COUNT_TIMEOUT(MAX_COUNT_TIMEOUT1)) 
	top_module_1(
	.clock(clk1),	
	.rst(rst1),
	.enable(enable1),
	.button1_raw(button_raw1),
	.switch_array(switch_array),
	.mode_switch(mode_switch1),
	.scaled_clk(scaled_clk1),

	.bi_uart_rx(bi_uart_rx1),
	.bo_uart_rx(bo_uart_rx1),
	.bi_uart_tx(bi_uart_tx1),
	.bo_uart_tx(bo_uart_tx1),
	
	
	.display1_pin(display1_pin1),
	.display2_pin(display2_pin1)
	);

top2 #(.MAX_COUNT_CLK(MAX_COUNT_CLK2), .CLKS_PER_BIT(CLKS_PER_BIT2), .MAX_COUNT_TIMEOUT(MAX_COUNT_TIMEOUT2))
	top_module_2(
	.clock(clk2),	
	.rst(rst2),
	.enable(enable2),
	.button1_raw(button_raw2),
	.switch_array(switch_array),
	.mode_switch(mode_switch2),
	.scaled_clk(scaled_clk2),

	.bi_uart_rx(bi_uart_rx2),
	.bo_uart_rx(bo_uart_rx2),
	.bi_uart_tx(bi_uart_tx2),
	.bo_uart_tx(bo_uart_tx2),
	
	
	.display1_pin(display1_pin2),
	.display2_pin(display2_pin2)
	);

top2 #(.MAX_COUNT_CLK(MAX_COUNT_CLK3), .CLKS_PER_BIT(CLKS_PER_BIT3), .MAX_COUNT_TIMEOUT(MAX_COUNT_TIMEOUT3))
	top_module_3(
	.clock(clk3),	
	.rst(rst3),
	.enable(enable3),
	.button1_raw(button_raw3),
	.switch_array(switch_array),
	.mode_switch(mode_switch3),
	.scaled_clk(scaled_clk3),

	.bi_uart_rx(bi_uart_rx3),
	.bo_uart_rx(bo_uart_rx3),
	.bi_uart_tx(bi_uart_tx3),
	.bo_uart_tx(bo_uart_tx3),
	
	
	.display1_pin(display1_pin3),
	.display2_pin(display2_pin3)
	);
	

//LCD_in LCD(
//	.clock(clock),
//	.rst(rst),
//	.Data_Line1(address1),
//	.Data_Line2(data1),
//	.config_state(config_state),
//	.mode_switch(mode_switch),
// .LCD_ON(LCD_ON),	
//   .LCD_BLON(LCD_BLON),	
//   .LCD_RW(LCD_RW),	
//   .LCD_EN(LCD_EN),	
//   .LCD_RS(LCD_RS),	
//   .LCD_DATA(LCD_DATA));
	

endmodule