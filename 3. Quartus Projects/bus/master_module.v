/* 
 file name : master_module.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module master_module #(parameter SLAVE_LEN=2, parameter ADDR_LEN=12, parameter DATA_LEN=8)(
	input clk, 
	input reset,
	input button1,
	input button2,
	output busy,
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	
	input [7:0]data_out1,   /////temp
	input [3:0]temp_state1, /////temp
	
	input arbitor_busy,
	input bus_busy,
	input approval_grant,
	output approval_request,
	output tx_slave_select,
	output trans_done,
	
	input rx_data,
	output tx_address,
	output tx_data,
	
	input slave_valid,
	input slave_ready,
	output master_valid,
	output master_ready,
	output write_en,
	output read_en);
	
	
wire [1:0]instruction;
wire [SLAVE_LEN-1:0]slave_select;
wire [ADDR_LEN-1:0]address;
wire [DATA_LEN-1:0]data_out;
wire [DATA_LEN-1:0]data_in;
wire rx_done;
wire tx_done;

wire [2:0]state; ///temp
wire [3:0]temp_state; ///temp
	

master_port #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN)) MASTER_PORT(
	.clk(clk), 
	.reset(reset),
	
	.instruction(instruction),
	.slave_select(slave_select),
	.address(address),
	.data_out(data_out),
	.data_in(data_in),
	.rx_done(rx_done),
	.tx_done(tx_done),
	.state(state),   ///temp
	.temp_state(temp_state),   ///temp
	
	.arbitor_busy(arbitor_busy),
	.bus_busy(bus_busy),
	.approval_grant(approval_grant),
	.approval_request(approval_request),
	.tx_slave_select(tx_slave_select),
	.trans_done(trans_done),
	
	
	.rx_data(rx_data),
	.tx_address(tx_address),
	.tx_data(tx_data),
	
	.slave_valid(slave_valid),
	.slave_ready(slave_ready),
	.master_valid(master_valid),
	.master_ready(master_ready),
	.write_en(write_en),
	.read_en(read_en));
	
button_event1 #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN)) BUTTON_EVENT1(
	.clk(clk), 
	.reset(reset),
	.button1(button1),
	.button2(button2),
	.busy1(busy),
	.display1_pin(display1_pin),
	.display2_pin(display2_pin),
	
	.data_in(data_in),
	.rx_done(rx_done),
	.tx_done(tx_done),
	.trans_done(trans_done),
	.instruction(instruction),
	.slave_select(slave_select),
	.address(address),
	.data_out(data_out),
	.tx_data(tx_data), ///temp
	.state1(temp_state1),///temp
	.temp_state(temp_state)); /////temp
	
	
endmodule 