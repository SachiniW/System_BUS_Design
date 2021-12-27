/* 
 file name : increment_module.v

 Description:
	This file contains the code for a increment module containing a master and a slave post.
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module increment_module #(parameter SLAVE_LEN=2, parameter ADDR_LEN=12, parameter DATA_LEN=8, 
								parameter BURST_LEN=12, parameter DELAY_COUNT = 20)(
	input clk,
	input reset,
	
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	
	input button,
	input mode_switch,
	input [7:0]sw_array_data,
	
	//MASTER
	
	input m_arbitor_busy,
	input m_bus_busy,
	input m_approval_grant,
	output m_approval_request,
	output m_tx_slave_select,
	output m_trans_done,
	
	input m_rx_data,
	output m_tx_address,
	output m_tx_data,
	output m_tx_burst_num,
	
	input m_slave_valid,
	input m_slave_ready,
	output m_master_valid,
	output m_master_ready,
	output m_write_en,
	output m_read_en,
	
	//SLAVE
	
	input [5:0]s_slave_delay,

	input s_read_en,
	input s_write_en,

	input s_master_ready,
	input s_master_valid,

	output s_slave_valid,
	output s_slave_ready,

	input s_rx_address,
	input s_rx_data,
	input s_rx_burst, 
	output s_split_en,
	output s_tx_data);
	
	
// MASTER
	
wire [1:0]m_instruction;
wire [SLAVE_LEN-1:0]m_slave_select;
wire [ADDR_LEN-1:0]m_address;
wire [DATA_LEN-1:0]m_data_out;
wire [BURST_LEN-1:0]m_burst_num;
wire [DATA_LEN-1:0]m_data_in;
wire m_rx_done;
wire m_tx_done;
wire m_new_rx;

// SLAVE

wire [7:0]s_datain;
wire [11:0]s_address;
wire [7:0]s_data;
wire s_read_en_in;
wire s_write_en_in;


slave_port SLAVE_PORT(
	.clk(clk), 
	.reset(reset),
	.slave_delay(s_slave_delay),
	.read_en(s_read_en),
	.write_en(s_write_en),
	.master_ready(s_master_ready),
	.master_valid(s_master_valid),
	.slave_valid(s_slave_valid),
	.slave_ready(s_slave_ready),
	.rx_address(s_rx_address),
	.rx_data(s_rx_data),
	.rx_burst(s_rx_burst),
	
	.tx_data(s_tx_data),
	.datain(s_datain),
	.address(s_address),
	.data(s_data),
	.read_en_in(s_read_en_in),
	.write_en_in(s_write_en_in),
	.split_en(s_split_en));
	

master_port #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN), .BURST_LEN(BURST_LEN)) MASTER_PORT(
	.clk(clk), 
	.reset(reset),
	
	.instruction(m_instruction),
	.slave_select(2'd2),
	.address(m_address),
	.data_out(m_data_out),
	.burst_num(12'd0),
	.data_in(m_data_in),
	.rx_done(m_rx_done),
	.tx_done(m_tx_done),
	.new_rx(m_new_rx),
	
	.arbitor_busy(m_arbitor_busy),
	.bus_busy(m_bus_busy),
	.approval_grant(m_approval_grant),
	.approval_request(m_approval_request),
	.tx_slave_select(m_tx_slave_select),
	.trans_done(m_trans_done),
	
	
	.rx_data(m_rx_data),
	.tx_address(m_tx_address),
	.tx_data(m_tx_data),
	.tx_burst_num(m_tx_burst_num),
	
	.slave_valid(m_slave_valid),
	.slave_ready(m_slave_ready),
	.master_valid(m_master_valid),
	.master_ready(m_master_ready),
	.write_en(m_write_en),
	.read_en(m_read_en));
								
increment #(.DELAY_COUNT(DELAY_COUNT)) inc1(
	.clk(clk),
	.reset(reset),
	
	.display1_pin(display1_pin),
	.display2_pin(display2_pin),
	.button(button),
	.mode_switch(mode_switch),
	.sw_array_data(sw_array_data),

	
	//MASTER	
	.m_tx_done (m_tx_done),
	.m_data_out (m_data_out),
	.m_instruction(m_instruction),
	
	//SLAVE
	
	.s_data (s_data),
	.s_write_en_in(s_write_en_in));
	
endmodule
