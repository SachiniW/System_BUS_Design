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
	output slave_ready,
	output rx_done,
	output reg[11:0]address = 12'b0,
	output reg[7:0]data = 8'b0);
	

reg [3:0]addr_state = 0;
reg [3:0]data_state = 0;
reg addr_idle = 1;
reg data_idle = 1;
reg addr_done = 0;
reg data_done = 0;

assign slave_ready = data_idle & addr_idle;
assign rx_done = addr_done;

wire handshake = master_valid & slave_ready;


// Statemachine to capture the 12 bit address

parameter 
IDLE = 0, 
ADDR1 = 1, 
ADDR2 = 2, 
ADDR3 = 3, 
ADDR4 = 4,
ADDR5 = 5, 
ADDR6 = 6, 
ADDR7 = 7, 
ADDR8 = 8, 
ADDR9 = 9, 
ADDR10 = 10, 
ADDR11 = 11,
ADDR12 = 12;

always @ (posedge clk or posedge reset or posedge handshake) 
begin
	if (reset)
		addr_state <= IDLE;
	else
	begin
		case (addr_state)
			IDLE:
			begin
				if (handshake == 1)
				begin
					addr_state <= ADDR1;
					addr_idle <= 0;
				end
				else
					addr_state <= IDLE;
					addr_idle <= 1;
					addr_done <= 0;
			end
			ADDR1:
			begin;
				address[0] <= rx_address;
				addr_idle <= 0;
				addr_state <= ADDR2;
			end
			ADDR2:
			begin
				addr_state <= ADDR3;
				address[1] <= rx_address;
			end
			ADDR3:
			begin
				addr_state <= ADDR4;
				address[2] <= rx_address;
			end
			ADDR4:
			begin
				addr_state <= ADDR5;
				address[3] <= rx_address;
			end
			ADDR5:
			begin
				addr_state <= ADDR6;
				address[4] <= rx_address;
			end
			ADDR6:
			begin 
				addr_state <= ADDR7;
				address[5] <= rx_address;
			end
			ADDR7:
			begin 
				addr_state <= ADDR8;
				address[6] <= rx_address;
			end 
			ADDR8:
			begin 
				addr_state <= ADDR9;
				address[7] <= rx_address;
			end
			ADDR9:
			begin
				addr_state <= ADDR10;
				address[8] <= rx_address;
			end
			ADDR10:
			begin 
				addr_state <= ADDR11;
				address[9] <= rx_address;
			end 
			ADDR11:
			begin
				addr_state <= ADDR12;
				address[10] <= rx_address;
			end
			ADDR12:
			begin
				addr_state <= IDLE;
				address[11] <= rx_address;
				addr_done = 1;
			end
			default:
				address[0] <= rx_address;	
		endcase
	end 
end


// Statemachine to capture the 8 bit data

parameter 
DATA1 = 1, 
DATA2 = 2, 
DATA3 = 3, 
DATA4 = 4,
DATA5 = 5, 
DATA6 = 6, 
DATA7 = 7, 
DATA8 = 8;

always @ (posedge clk or posedge reset or posedge handshake) 
begin
	if (reset)
		data_state <= IDLE;
	else
	begin
		case (data_state)
			IDLE:
			begin
				if (handshake == 1)
				begin
					data_state <= DATA1;
					data_idle <= 0;
				end
				else
					data_state <= IDLE;
					data_idle <= 1;
					data_done <= 0;
			end
			DATA1:
			begin
				data_state <= DATA2;
				data[0] <= rx_data;
				data_idle <= 0;
			end
			DATA2:
			begin
				data_state <= DATA3;
				data[1] <= rx_data;
				data_idle <= 0;
			end
			DATA3:
			begin
				data_state <= DATA4;
				data[2] <= rx_data;
				data_idle <= 0;
			end
			DATA4:
			begin
				data_state <= DATA5;
				data[3] <= rx_data;
				data_idle <= 0;
			end
			DATA5:
			begin
				data_state <= DATA6;
				data[4] <= rx_data;
				data_idle <= 0;
			end
			DATA6:
			begin
				data_state <= DATA7;
				data[5] <= rx_data;
				data_idle <= 0;
			end
			DATA7:
			begin
				data_state <= DATA8;
				data[6] <= rx_data;
				data_idle <= 0;
			end	
			DATA8:
			begin
				data_state <= IDLE;
				data[7] <= rx_data;
				data_idle <= 0;
			end
			default:
				data[0] = rx_data;
		endcase
	end
end
endmodule