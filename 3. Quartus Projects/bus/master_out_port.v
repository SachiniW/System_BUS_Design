/* 
 file name : master_out_port.v

 Description:
	This file contains the output port of the slave port.
	It is responsible for sending the requested data back 
	to master.

 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module master_out_port (
	input clk, 
	input reset,
	input slave_ready,
	input [11:0]address,
	input [7:0]data, 
	output master_ready,
	output tx_done,  //question
	output reg master_valid,
	output reg tx_address,
	output reg tx_data);

reg [3:0]address_state = 0;
reg [3:0]data_state = 0;
reg address_idle;
reg address_done;
reg data_idle;
reg data_done;
wire handshake = master_valid & slave_ready;

assign master_ready = data_idle && address_idle;
assign master_tx_done = address_done;

parameter 
IDLE  = 0,
START = 1,
ADDR1 = 4, 
ADDR2 = 5, 
ADDR3 = 6, 
ADDR4 = 7,
ADDR5 = 8, 
ADDR6 = 9, 
ADDR7 = 10, 
ADDR8 = 11,
ADDR9 = 12, 
ADDR10 = 13, 
ADDR11 = 14, 
ADDR12 = 15;

always @ (address_state) 
begin
	case (address_state)
	IDLE:
	begin
		address_idle = 1;
		address_done = 0;
		master_valid = 0;
	end
	START:
	begin
		address_idle = 1;
		address_done = 0;
	end	
	ADDR1:
	begin
		tx_address = address[0];
		address_idle = 0;
	end
	ADDR2:
		tx_address = address[1];
	ADDR3:
		tx_address = address[2];
	ADDR4:
		tx_address = address[3];
	ADDR5:
		tx_address = address[4];
	ADDR6:
		tx_address = address[5];
	ADDR7:
		tx_address = address[6];
	ADDR8:
		tx_address = address[7];
	ADDR9:
		tx_address = address[8];
	ADDR10:
		tx_address = address[9];
	ADDR11:
		tx_address = address[10];
	ADDR12:
	begin
		tx_address = address[11];
		address_done = 1;
	end
	default:
		tx_address = address[0];
	endcase
end

always @ (posedge clk or posedge reset) 
begin
	if (reset)
		address_state <= IDLE;
	else
		case (address_state)
			IDLE:
				if (transmit == 1)
					address_state <= START;
				else
					address_state <= IDLE;
			START:
				if (handshake == 1)
					address_state <= ADDR1;
				else
					address_state <= START;
			ADDR1:
				address_state <= ADDR2;
			ADDR2:
				address_state <= ADDR3;
			ADDR3:
				address_state <= ADDR4;
			ADDR4:
				address_state <= ADDR5;
			ADDR5:
				address_state <= ADDR6;
			ADDR6:
				address_state <= ADDR7;
			ADDR7:
				address_state <= ADDR8;	
			ADDR8:
				address_state <= ADDR9;
			ADDR9:
				address_state <= ADDR10;
			ADDR10:
				address_state <= ADDR11;
			ADDR11:
				address_state <= ADDR12;
			ADDR12:
				address_state <= IDLE;
		endcase
end

parameter 
IDLE  = 0,
START = 1,
DATA1 = 4, 
DATA2 = 5, 
DATA3 = 6, 
DATA4 = 7,
DATA5 = 8, 
DATA6 = 9, 
DATA7 = 10, 
DATA8 = 11;

always @ (data_state) 
begin
	case (data_state)
	IDLE:
	begin
		data_idle = 1;
		data_done = 0;
	end
	START:
	begin
		data_idle = 1;
		data_done = 0;
	end
	DATA1:
	begin
		tx_data = data[0];
		data_idle = 0;
	end
	DATA2:
		tx_data = data[1];
	DATA3:
		tx_data = data[2];
	DATA4:
		tx_data = data[3];
	DATA5:
		tx_data = data[4];
	DATA6:
		tx_data = data[5];
	DATA7:
		tx_data = data[6];
	DATA8:
	begin
		tx_data = data[7];
		data_done = 1;
	end
	default:
		tx_data = data[0];
	endcase
end

always @ (posedge clk or posedge reset) 
begin
	if (reset)
		data_state <= IDLE;
	else
		case (data_state)
			IDLE:
				if (transmit == 1)
					data_state <= DATA1;
				else
					data_state <= IDLE;
			START:
				if (handshake == 1)
					data_state <= DATA1;
				else
					data_state <= IDLE;
			DATA1:
				data_state <= DATA2;
			DATA2:
				data_state <= DATA3;
			DATA3:
				data_state <= DATA4;
			DATA4:
				data_state <= DATA5;
			DATA5:
				data_state <= DATA6;
			DATA6:
				data_state <= DATA7;
			DATA7:
				data_state <= DATA8;	
			DATA8:
				data_state <= IDLE;
		endcase
end

endmodule