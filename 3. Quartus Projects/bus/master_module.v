/* 
 file name : master_module.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module master_module #(SLAVE_LEN=2, ADDR_LEN=12, DATA_LEN=8)(
	input clk, 
	input reset,
	input button1,
	input button2,
	output busy,
	
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
	

master_port #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN)) MASTER_PORT(
	.clk(clk), 
	.reset,
	
	.instrucution(instrucution),
	.slave_select(slave_select),
	.address(address),
	.data_out(data_out),
	.data_in(data_in),
	.rx_done(rx_done),
	.tx_done(tx_done),
	
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
	.busy(busy),
	
	.data_in(data_in),
	.rx_done(rx_done),
	.tx_done(tx_done),
	.trans_done(trans_done),
	.instrucution(instrucution),
	.slave_select(slave_select),
	.address(address),
	.data_out(data_out));
	
	
endmodule 