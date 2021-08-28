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
	output [2:0]temp_state,   ////temp
	
	input rx_data,
	input slave_valid,
	output reg master_ready);
	//output reg read_en);

reg [2:0]state = 0;
parameter IDLE=0, WAIT_HANDSHAKE=1, RECEIVE_DATA=2;

	
assign temp_state = state;  ////temp


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
		//read_en <= 0;
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
				//read_en <= 0;
			end
			
			else
			begin
				count <= count;
				state <= IDLE;
				data	<= data;
				rx_done <= 0;
				master_ready <= 1;
				//read_en <= 0;
			end
		end
		
		WAIT_HANDSHAKE:
		begin
			if (slave_valid == 1 && master_ready == 1)
			begin
				count <= count + 1;
				state <= RECEIVE_DATA;
				data[count] <= rx_data;
				//data[DATA_LEN-1:count+1] <= data[DATA_LEN-1:count+1];
				rx_done <= rx_done;
				master_ready <= 0;
				//read_en <= read_en;
			end
			
			else
			begin
				count <= count;
				state <= WAIT_HANDSHAKE;
				data	<= data;
				rx_done <= rx_done;
				master_ready <= 1;
				//read_en <= read_en;
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
				//read_en <= read_en;
			end
			
			else
			begin
				count <= count + 1;
				state <= RECEIVE_DATA;
				//data[count-1:0] <= data[count-1:0];
				data[count] <= rx_data;
				//data[DATA_LEN-1:count+1] <= data[DATA_LEN-1:count+1];
				rx_done <= rx_done;
				master_ready <= 0;
				//read_en <= read_en;
			end
		end
		
		default:
		begin 
			count <= count;
			state <= IDLE;
			data	<= data;
			rx_done <= 0;
			master_ready <= 1;
			//read_en <= 0;
		end
		
		endcase
end

endmodule