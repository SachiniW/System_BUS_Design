/* 
 file name : slave_port.v

 Description:
	This file contains the slave port 
	It encapsulated the input and output ports.
	Sets the control signals of the bus
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module slave_port(

	input clk, 
	input reset,

	input read_en,
	input write_en,

	input master_ready,
	input master_valid,
	
	output reg slave_valid,
	output slave_ready,

	input rx_address,
	input rx_data,

	output slave_tx_done,
	output rx_done,
	output tx_data,


	input [7:0]datain,
	output [11:0]address,
	output [7:0]data,
	
	output read_en_in,
	output write_en_in);
	
	
wire slave_ready_IN;
wire slave_ready_OUT;

reg temp2 = 0;
reg temp3 = 0;
reg read_en_in1 = 0;
reg write_en_in1 = 0;

assign slave_ready = slave_ready_IN & slave_ready_OUT;
assign read_en_in = rx_done & read_en_in1;
assign write_en_in = rx_done & write_en_in1;
	
slave_in_port SLAVE_IN_PORT(
	.clk(clk), 
	.reset(reset),
	.rx_address(rx_address),
	.rx_data(rx_data),
	.master_valid(master_valid),
	.read_en(read_en),
	.write_en(write_en),
	.slave_ready(slave_ready_IN),
	.rx_done(rx_done),
	.address(address),
	.data(data));
	
slave_out_port SLAVE_OUT_PORT(
	.clk(clk), 
	.reset(reset),
	.master_ready(master_ready),
	.datain(datain),
	.slave_valid(slave_valid),
	.slave_ready(slave_ready_OUT),
	.slave_tx_done(slave_tx_done),
	.tx_data(tx_data));
	

always @ (posedge clk)
begin

	//Driving the data valid signal at slave
	if ((read_en_in1 == 1) & (rx_done == 1)) 
		slave_valid <= 1;
	else if((slave_tx_done == 1) & (slave_valid == 1))
		slave_valid <= 0;
	
	//Driving and latching the read_en signal
	if (read_en == 1)
		read_en_in1 <= 1;
	if ((rx_done==1) & (read_en_in1 == 1))
		read_en_in1 <= 0;
	

	//Driving and latching the write_en signal
	if (write_en == 1)
		write_en_in1 <= 1;
	if ((rx_done==1) & (write_en_in1 == 1))
		write_en_in1 <= 0;
		
end
	
endmodule
