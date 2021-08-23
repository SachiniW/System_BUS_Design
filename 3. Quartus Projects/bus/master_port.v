/* 
 file name : master_port.v

 Description:
	This file contains the master port 
	It encapsulated the input and output ports.
	Sets the control signals of the bus
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module master_port #(SLAVE_LEN=2, ADDR_LEN=12, DATA_LEN=8)(

	input clk, 
	input reset,
	
	input [1:0]instrucution,
	input [SLAVE_LEN-1:0]slave_select,
	input [ADDR_LEN-1:0]address,
	input [DATA_LEN-1:0]data_out,
	output [DATA_LEN-1:0]data_in,
	output rx_done,
	output tx_done,
	
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
	
	
wire master_ready_IN;
wire master_ready_OUT;

assign master_ready = master_ready_IN && master_ready_OUT;

wire read_en_IN;
wire read_en_OUT;

assign read_en = read_en_IN || read_en_OUT;

assign trans_done = (instruction==2'b10) ? tx_done : (instruction==2'b11) ? rx_done : 0 ;

master_in_port #(.DATA_LEN(DATA_LEN)) MASTER_IN_PORT(
	.clk(clk), 
	.reset(reset),
	
	.tx_done(tx_done),
	.instrucution(instruction),
	.data(data_in),
	.rx_done(rx_done),
	
	.rx_data(rx_data),
	.slave_valid(slave_valid),
	.master_ready(master_ready_IN),
	.read_en(read_en_IN));

master_out_port #(.SLAVE_LEN(SLAVE_LEN), .ADDR_LEN(ADDR_LEN), .DATA_LEN(DATA_LEN)) MASTER_OUT_PORT(
	.clk(clk), 
	.reset(reset),
	
	.slave_select(slave_select),
	.instruction(instruction), 
	.address(address),
	.data(data_out),
	.tx_done(tx_done),
	
	.slave_ready(slave_ready),
	.arbitor_busy(arbitor_busy),
	.bus_busy(bus_busy),	
	.approval_grant(approval_grant),
	.master_ready(master_ready_OUT),
	.approval_request(approval_request),
	.tx_slave_select(tx_slave_select),
	.master_valid(master_valid),
	.write_en(write_en),
	.read_en(read_en_OUT),	
	.tx_address(tx_address),
	.tx_data(tx_data));
	

//always @ (posedge clk)
//begin
//
//	//Driving the data valid signal at slave
//	if ((read_en_in1 == 1) & (rx_done == 1)) 
//		slave_valid <= 1;
//	else if((slave_tx_done == 1) & (slave_valid == 1))
//		slave_valid <= 0;
//	
//	//Driving and latching the read_en signal
//	if (read_en == 1)
//		read_en_in1 <= 1;
//	if ((rx_done==1) & (read_en_in1 == 1))
//		read_en_in1 <= 0;
//	
//
//	//Driving and latching the write_en signal
//	if (write_en == 1)
//		write_en_in1 <= 1;
//	if ((rx_done==1) & (write_en_in1 == 1))
//		write_en_in1 <= 0;
//		
//end
	
endmodule
