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

	input [5:0]slave_delay,

	input read_en,
	input write_en,

	input master_ready,
	input master_valid,
	
	output reg slave_valid,
	output slave_ready,

	input rx_address,
	input rx_data,

	// output slave_tx_done,
	// output rx_done,
	output tx_data,


	input [7:0]datain,
	output [11:0]address,
	output [7:0]data,
	
	output read_en_in,
	output write_en_in,
	output reg split_en = 0);
	
	
wire slave_ready_IN;
wire slave_ready_OUT;
wire rx_done;
wire slave_tx_done;

// reg temp = 0;
// reg temp3 = 0;
reg [3:0]counterReg = 0; 
reg read_en_in1 = 0;
reg write_en_in1 = 0;

assign slave_ready = slave_ready_IN & slave_ready_OUT;
assign read_en_in = rx_done & read_en_in1;
assign write_en_in = rx_done & write_en_in1;
// assign read_en_in = rx_done & read_en;
// assign write_en_in = rx_done & write_en;

reg [1:0]state = 1;
parameter 
NORMAL = 1,
SPLIT = 2,
VALID = 3;

	
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
	

// always @ (posedge read_en) 		 read_en_in1 <= 1;
// always @ (posedge write_en)      write_en_in1 <= 1;
// always @ (negedge rx_done) 
// begin
// 	read_en_in1 <= 0;
// 	write_en_in1 <= 0;
// end       
// always @ (posedge slave_tx_done) 
// begin
// 	slave_valid <= 0;
// 	temp <= 0;
// end



// always @ (posedge clk)
// begin
// 	//Driving the data valid signal at slave
// 	if ((read_en_in1 == 1) & (rx_done == 1)) 
// 		temp <= 1;	
// 	else
// 		slave_valid <= temp;	
// end

always @ (posedge clk)
begin
	case (state)
		NORMAL:
		begin
			if ((read_en_in1 == 1) & (rx_done == 1) & (slave_delay < 5)) 
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b0;
				state <= SPLIT;
				split_en <= 1'b0;
			end
			else if ((read_en_in1 == 1) & (rx_done == 1) & (~(slave_delay < 5)))
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b0;
				state <= SPLIT;
				split_en <= 1'b1;
			end
			else
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b0;
				split_en <= 1'b0;
				state <= NORMAL;
			end
		end 
		SPLIT:
		begin
			if (counterReg < slave_delay)
			begin
				counterReg <= counterReg + 4'b1;
				slave_valid <= 1'b0;
				split_en = 1'b1;
				state <= SPLIT;
			end
			else
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b1;
				split_en <= 1'b0;
				state <= VALID;
			end
		end
		VALID:
		begin
			if((slave_tx_done == 1) & (slave_valid == 1))
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b0;
				split_en <= 1'b0;
				state <= NORMAL;
			end
			else
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b1;
				split_en <= 1'b0;
				state <= VALID;
			end

		end
	endcase
end

always @ (posedge clk)
begin

	// //Driving the data valid signal at slave
	// if ((read_en_in1 == 1) & (rx_done == 1)) 
	// // if ((read_en == 1) & (rx_done == 1)) 
	// 	temp <= 1;
	// else if((slave_tx_done == 1) & (slave_valid == 1))
	// begin
	// 	slave_valid <= 0;
	// 	temp <= 0;
	// end
	// else
	// 	slave_valid <= temp;
	
	//Driving and latching the read_en signal
	if (read_en == 1)
		read_en_in1 <= 1;
	if (((rx_done==1) & (read_en_in1 == 1)) | (slave_valid == 1))
		read_en_in1 <= 0;
	

	//Driving and latching the write_en signal
	if (write_en == 1)
		write_en_in1 <= 1;
	if ((rx_done==1) & (write_en_in1 == 1))
		write_en_in1 <= 0;
		
end
	
	
	
endmodule
