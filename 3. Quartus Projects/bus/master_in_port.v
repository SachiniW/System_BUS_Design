/* 
 file name : master_in_port.v

 Description:
	This file contains the input port of the master port.
	It is responsible for receiving the data from 
	the slave.

 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module master_in_port #(parameter DATA_LEN=8)(
	input clk, 
	input reset,
	
	input tx_done,
	input [1:0]instruction,
	output reg[DATA_LEN-1:0]data,
	output reg rx_done,
	
	input rx_data,
	input slave_valid,
	output reg master_ready,
	output reg read_en);
	
reg [2:0]state = 0;
parameter IDLE=0, WAIT_HANDSHAKE=1, RECEIVE_DATA=2;


integer count = 0;

always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		count <= 0;
		state <= IDLE;
		data	<= 0;
		rx_done <= 0;
		master_ready <= 1;
		read_en <= 0;
	end	
	
	else
		case (state)
		
		IDLE:
		begin
			if (instruction == 2'b11 && tx_done == 1)
			begin
				count <= 0;
				state <= WAIT_HANDSHAKE;
				data	<= data;
				rx_done <= 0;
				master_ready <= 1;
				read_en <= 1;
			end
			
			else
			begin
				count <= count;
				state <= IDLE;
				data	<= data;
				rx_done <= 0;
				master_ready <= 1;
				read_en <= 0;
			end
		end
		
		WAIT_HANDSHAKE:
		begin
			if (slave_valid == 1 && master_ready == 1)
			begin
				// count <= count + 1;
				state <= RECEIVE_DATA;
				// data[count] <= rx_data;
				//data[DATA_LEN-1:count+1] <= data[DATA_LEN-1:count+1];
				rx_done <= 0;
				master_ready <= 0;
				read_en <= 1;
			end
			
			else
			begin
				count <= count;
				state <= WAIT_HANDSHAKE;
				data	<= data;
				rx_done <= 0;
				master_ready <= 1;
				read_en <= 1;
			end
		end
		
		RECEIVE_DATA:
		begin
			if (count >= DATA_LEN-1)
			begin
				count <= 0;
				state <= IDLE;
				//data[count-1:0] <= data[count-1:0];
				data[count] <= rx_data;
				rx_done <= 1;
				master_ready <= 0;
				read_en <= 1;
			end
			
			else
			begin
				count <= count + 1;
				state <= RECEIVE_DATA;
				//data[count-1:0] <= data[count-1:0];
				data[count] <= rx_data;
				//data[DATA_LEN-1:count+1] <= data[DATA_LEN-1:count+1];
				rx_done <= 0;
				master_ready <= 0;
				read_en <= 1;
			end
		end
		
		default:
		begin 
			count <= count;
			state <= IDLE;
			data	<= data;
			rx_done <= 0;
			master_ready <= 1;
			read_en <= 0;
		end
		
		endcase
end




//reg addr_idle = 1;
//reg data_idle = 1;
//reg addr_done = 0;
//reg data_done = 0;
//
//
//assign slave_ready = data_idle & addr_idle;
//assign rx_done = addr_done;
//
//wire handshake = master_valid & slave_ready;


// Statemachine to capture the 12 bit address

//parameter 
//IDLE = 0, 
//ADDR1 = 1, 
//ADDR2 = 2, 
//ADDR3 = 3, 
//ADDR4 = 4,
//ADDR5 = 5, 
//ADDR6 = 6, 
//ADDR7 = 7, 
//ADDR8 = 8, 
//ADDR9 = 9, 
//ADDR10 = 10, 
//ADDR11 = 11,
//ADDR12 = 12;
//
//always @ (addr_state) 
//begin
//	case (addr_state)
//	IDLE:
//	begin
//		addr_idle = 1;
//		addr_done = 0;
//	end
//	ADDR1:
//	begin
//		address[0] = rx_address;
//		addr_idle = 0;
//	end
//	ADDR2:
//		address[1] = rx_address;
//	ADDR3:
//		address[2] = rx_address;
//	ADDR4:
//		address[3] = rx_address;
//	ADDR5:
//		address[4] = rx_address;
//	ADDR6:
//		address[5] = rx_address;
//	ADDR7:
//		address[6] = rx_address;
//	ADDR8:
//		address[7] = rx_address;
//	ADDR9:
//		address[8] = rx_address;
//	ADDR10:
//		address[9] = rx_address;
//	ADDR11:
//		address[10] = rx_address;
//	ADDR12:
//	begin
//		address[11] = rx_address;
//		addr_done = 1;
//	end
//	default:
//		address[0] = rx_address;
//	endcase
//end
//
//always @ (posedge clk or posedge reset) 
//begin
//	if (reset)
//		addr_state <= IDLE;
//	else
//		case (addr_state)
//			IDLE:
//				if (handshake == 1)
//				begin
//					addr_state <= ADDR1;
//				end
//				else
//					addr_state <= IDLE;
//			ADDR1:
//				addr_state <= ADDR2;
//			ADDR2:
//				addr_state <= ADDR3;
//			ADDR3:
//				addr_state <= ADDR4;
//			ADDR4:
//				addr_state <= ADDR5;
//			ADDR5:
//				addr_state <= ADDR6;
//			ADDR6:
//				addr_state <= ADDR7;
//			ADDR7:
//				addr_state <= ADDR8;
//			ADDR8:
//				addr_state <= ADDR9;
//			ADDR9:
//				addr_state <= ADDR10;
//			ADDR10:
//				addr_state <= ADDR11;
//			ADDR11:
//				addr_state <= ADDR12;
//			ADDR12:
//				addr_state <= IDLE;
//				
//		endcase
//end
//
//
//// Statemachine to capture the 8 bit data
//
//parameter 
//DATA1 = 1, 
//DATA2 = 2, 
//DATA3 = 3, 
//DATA4 = 4,
//DATA5 = 5, 
//DATA6 = 6, 
//DATA7 = 7, 
//DATA8 = 8;
//
//always @ (data_state) 
//begin
//	case (data_state)
//	IDLE:
//	begin
//		data_idle = 1;
//		data_done = 0;
//	end
//	DATA1:
//	begin
//		data[0] = rx_data;
//		data_idle = 0;
//	end
//	DATA2:
//		data[1] = rx_data;
//	DATA3:
//		data[2] = rx_data;
//	DATA4:
//		data[3] = rx_data;
//	DATA5:
//		data[4] = rx_data;
//	DATA6:
//		data[5] = rx_data;
//	DATA7:
//		data[6] = rx_data;
//	DATA8:
//	begin
//		data[7] = rx_data;
//		data_done = 1;
//	end
//	default:
//		data[0] = rx_data;
//	endcase
//end
//
//always @ (posedge clk or posedge reset) 
//begin
//	if (reset)
//		data_state <= IDLE;
//	else
//		case (data_state)
//			IDLE:
//				if (handshake == 1)
//				begin
//					data_state <= DATA1;
//				end
//				else
//					data_state <= IDLE;
//			DATA1:
//				data_state <= DATA2;
//			DATA2:
//				data_state <= DATA3;
//			DATA3:
//				data_state <= DATA4;
//			DATA4:
//				data_state <= DATA5;
//			DATA5:
//				data_state <= DATA6;
//			DATA6:
//				data_state <= DATA7;
//			DATA7:
//				data_state <= DATA8;	
//			DATA8:
//				data_state <= IDLE;
//		endcase
//end
endmodule