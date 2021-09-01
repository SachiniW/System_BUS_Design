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
	// input rx_burst,

	// output slave_tx_done,
	// output rx_done,
	output tx_data,


	input [7:0]datain,
	output [11:0]address,
	output [7:0]data,
	
	output [3:0]temp_data_state, ///temp
	output [3:0]temp_addr_state, ///temp
	output [3:0]temp_data_counter, ///temp	
	output [3:0]temp_addr_counter, ///temp	
	output temp_signal,  ////temp
	
	output read_en_in,
	output write_en_in,
	output reg split_en,
	output [3:0]temp_tx_data_counter,
	output [3:0]tx_data_state);
	
wire [11:0]burst_counter;  //new
wire slave_ready_IN;
wire slave_ready_OUT;
wire rx_done;
wire slave_tx_done;

reg [3:0]counterReg = 0; 
reg [11:0]burst = 12'd3;

assign slave_ready = slave_ready_IN & slave_ready_OUT;
reg [2:0]state = 1;
parameter 
NORMAL = 1,
SPLIT = 2,
VALID = 3,
BURST_END = 4;

reg slave_delay = 1;


slave_in_port SLAVE_IN_PORT(
	.clk(clk), 
	.reset(reset),
	.rx_address(rx_address),
	.rx_data(rx_data),
	// .rx_burst(rx_burst),
	.master_valid(master_valid),
	.read_en(read_en),
	.write_en(write_en),
	.slave_valid(slave_valid),
	.burst(burst),   //new
	.temp_data_state(temp_data_state),
	.temp_addr_state(temp_addr_state),  /////temp
	.temp_data_counter(temp_data_counter), ///temp
	.temp_addr_counter(temp_addr_counter), ///temp
	.temp_signal(temp_signal),  /////temp
	.slave_ready(slave_ready_IN),
	.rx_done(rx_done),
	.address(address),
	.data(data),
	.read_en_in2(read_en_in1),
	.read_en_in(read_en_in),
	.write_en_in(write_en_in),
	.burst_counter(burst_counter));  //new
	
slave_out_port SLAVE_OUT_PORT(
	.clk(clk), 
	.reset(reset),
	.master_ready(master_ready),
	.datain(datain),
	.slave_valid(slave_valid),
	.slave_ready(slave_ready_OUT),
	.slave_tx_done(slave_tx_done),
	.tx_data(tx_data),
	// .read_en_in(read_en_in),
	.read_en_in1(read_en_in1),
	.temp_tx_data_counter(temp_tx_data_counter), //temp
	.tx_data_state(tx_data_state)); //temp


always @ (posedge clk)
begin
	case (state)
		NORMAL:
		begin
			if ((read_en_in1 == 1) & (rx_done == 1) & (slave_delay < 5)) 
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b0;
				state <= VALID;
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
			if((slave_tx_done == 1) & (slave_valid == 1) & (burst == 1))
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b0;
				split_en <= 1'b0;
				state <= NORMAL;
			end
			if((slave_tx_done == 1) & (slave_valid == 1) & (burst == burst_counter))
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b1;
				split_en <= 1'b0;
				state <= BURST_END;
			end
			else
			begin
				counterReg <= 4'b0;
				slave_valid <= 1'b1;
				split_en <= 1'b0;
				state <= VALID;
			end
		end
		BURST_END:
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
				state <= BURST_END;
			end
		end
	endcase
end

endmodule
