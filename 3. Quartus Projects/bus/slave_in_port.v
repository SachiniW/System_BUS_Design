/* 
 file name : slave_in_port.v

 Description:
	This file contains the input port of the slave port.
	It is responsible for receiving the address and data from 
	the master.

 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module slave_in_port (
	input clk, 
	input reset,
	input rx_address,
	input rx_data,
	input master_valid,
	input read_en,
	input write_en,
	output [3:0]temp_data_state, ///temp
	output [3:0]temp_addr_state, ///temp
	output [3:0]temp_data_counter, ///temp
	output [3:0]temp_addr_counter, ///temp
	output temp_signal,  ////temp
	output slave_ready,
	output rx_done,
	output reg[11:0]address,
	output reg[7:0]data);
	

reg [3:0]addr_state = 4'd13;
reg [3:0]data_state = 4'd13;
reg addr_idle = 1;
reg data_idle = 1;
reg addr_done = 0;
reg data_done = 0;

assign slave_ready = data_idle & addr_idle;
assign rx_done = addr_done;

wire handshake = master_valid & slave_ready;
wire trig_event = clk | reset | handshake;

// wire state_check = 0;  //temp
assign temp_data_counter = data_counter;
assign temp_addr_counter = addr_counter;
assign temp_data_state = data_state; ///temp
assign temp_addr_state = addr_state; ///temp
assign temp_signal = handshake; ///temp

// Statemachine to capture the 12 bit address

parameter 
IDLE = 13, 
ADDR_RECIEVE = 1, 
DATA_RECIEVE = 2;

// always @ (posedge handshake) addr_state <= ADDR1;

reg [3:0]addr_counter = 4'd0;
reg [3:0]data_counter = 4'd0;

always @ (posedge clk or posedge reset or posedge handshake) 
begin
	if (reset)
	begin
		addr_state <= IDLE;
		addr_counter <= 4'd0;
		addr_idle <= 1;
		addr_done <= 0;
	end
	else
	begin
		case (addr_state)
			IDLE:
			begin
				if (handshake == 1'd1)
					begin
						addr_state <= ADDR_RECIEVE;
						addr_counter <= 4'd0;
						addr_idle <= 0;
						addr_done <= 0;
					end
				else
					begin
						addr_state <= IDLE;
					    addr_counter <= 4'd0;
						addr_idle <= 1;
						addr_done <= 0;
					end
			end
			ADDR_RECIEVE:
			begin
				if (addr_counter < 4'd11)
				begin
					addr_state <= addr_state;
					addr_counter <= addr_counter + 4'd1;
					address[addr_counter] <= rx_address;
					addr_idle <= 0;
					addr_done <= 0;
				end
				else 
				begin
					addr_state <= IDLE;
					addr_counter <= 0;
					address[addr_counter] <= rx_address;
					addr_idle <= 0;
					addr_done <= 1;
				end
			end
			default:
			begin
				address[0] <= rx_address;	
				addr_state <= IDLE;
			end
		endcase
	end 
end


// Statemachine to capture the 8 bit data

always @ (posedge clk or posedge reset or posedge handshake) 
// always @ (posedge clk or posedge reset)
begin
	if (reset)
	begin
		data_state <= IDLE;
		data_counter <= 0;
		data_idle <= 1;
		data_done <= 0;
	end
	else
	begin
		case (data_state)
			IDLE:
			begin
				if (handshake == 1'd1) //handshake
					begin
						data_state <= DATA_RECIEVE;
						data_counter <= 0;
						data_idle <= 0;
						data_done <= 0;
					end
				else
					begin
						data_state <= data_state;
						data_counter <= 0;
						data_idle <= 1;
						data_done <= 0;
					end
			end
			DATA_RECIEVE:
			begin
				if (data_counter < 4'd7)
				begin
					data_state <= data_state;
					data_counter <= data_counter + 4'd1;
					data[data_counter] <= rx_data;
					data_idle <= 0;
				end
				else 
				begin
					data_state <= IDLE;
					data_counter <= 0;
					data[data_counter] <= rx_data;
					data_idle <= 0;
				end
			end
			default:
			begin
				data_state <= IDLE;
				data[0] <= rx_data;
			end
		endcase
	end
end
endmodule