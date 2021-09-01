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
	input rx_burst,
	output tx_data,

	input [7:0]datain,
	output [11:0]address,
	output [7:0]data,
	
	output read_en_in,
	output write_en_in,
	output reg split_en = 0);
	

wire [11:0]burst_counter;
wire slave_ready_IN;
wire slave_ready_OUT;
wire rx_done;
wire slave_tx_done;
wire read_en_in1;
wire write_en_in1;

reg [3:0]counterReg = 0; 
reg [11:0]burst = 12'd0;

assign slave_ready = slave_ready_IN & slave_ready_OUT;

reg [2:0]state = 1;
reg [4:0]burst_bit_counter = 4'd0;
reg [2:0]burst_state = 0;

parameter 
IDLE = 0,
NORMAL = 1,
SPLIT = 2,
VALID = 3,
BURST_END = 4,
BURST_BIT_RECIEVE = 5;

	
slave_in_port SLAVE_IN_PORT(
	.clk(clk), 
	.reset(reset),
	.rx_address(rx_address),
	.rx_data(rx_data),
	.master_valid(master_valid),
	.read_en(read_en),
	.write_en(write_en),
	.burst(burst),
	.slave_ready(slave_ready_IN),
	.rx_done(rx_done),
	.address(address),
	.data(data),
	.read_en_in1(read_en_in1),
	.write_en_in1(write_en_in1),
	.read_en_in(read_en_in),
	.write_en_in(write_en_in),
	.burst_counter(burst_counter));

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


always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		burst_state <= IDLE;
		burst_bit_counter <= 0;
	end
	else
	begin
		case (burst_state)
			IDLE:
			begin
				if ((master_valid && slave_ready) && (read_en || write_en))
				begin
					burst[burst_bit_counter] <= rx_burst;
					burst_state <= BURST_BIT_RECIEVE;
					burst_bit_counter <= burst_bit_counter + 1;
				end
				else
				begin
					burst_state <= burst_state;
					burst_bit_counter <= 0;
				end
			end
			BURST_BIT_RECIEVE:
			begin
				if (burst_bit_counter < 4'd12)
				begin
					burst[burst_bit_counter] <= rx_burst;
					burst_bit_counter <= burst_bit_counter + 1;
					burst_state <= burst_state;
				end
				else 
				begin
					burst_state <= IDLE;
					burst_bit_counter <= 0;
				end
			end
			default:
			begin
				burst_state <= IDLE;
			end
		endcase
	end
end

endmodule
