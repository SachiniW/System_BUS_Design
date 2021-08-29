/* 
 file name : master_out_port.v

 Description:
	This file contains the output port of the master port.
	It is responsible for accessing a slave.

 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module master_out_port #(parameter SLAVE_LEN=2, parameter ADDR_LEN=12, parameter DATA_LEN=8)(
	input clk, 
	input reset,
	
	input [SLAVE_LEN-1:0]slave_select,
	input [1:0]instruction, 
	input [ADDR_LEN-1:0]address,
	input [DATA_LEN-1:0]data,
	input rx_done,
	output reg tx_done,
	output [3:0]temp_state,   ////temp
	
	input slave_ready,
	input arbitor_busy,
	input bus_busy,
	input approval_grant,
	output reg master_ready,
	output reg approval_request,
	output reg tx_slave_select,
	output reg master_valid,
	output reg write_en,
	output reg read_en,	
	output reg tx_address,
	output reg tx_data);


reg [3:0]state = 0;

parameter IDLE=0, WAIT_ARBITOR=1, TRANSMIT_SELECT=2, WAIT_APPROVAL=3, WAIT_HANDSHAKE=4, 
				TRANSMIT_DATA_ADDR=5, TRANSMIT_DATA=6, TRANSMIT_ADDR=7, WAIT_BUS=8, FINISH=9, READ_WAIT=10;
parameter INACTIVE=2'b00, WRITE=2'b10, READ=2'b11;

integer count = 0;

assign temp_state = count;  ////temp

always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		count <= 0;
		state <=IDLE;
		master_ready<= 1;
		approval_request<= 0;
		tx_slave_select<= 0;
		master_valid<= 0;
		write_en<= 0;
		read_en<= 0;	
		tx_address<= 0;
		tx_data<= 0;
		tx_done<= 0;
	end
	else
		case (state)
		
		IDLE:
		begin
			if (instruction[1]==1)
			begin
				count <= count+1;
				state <= WAIT_ARBITOR;
				master_ready<= 0;
				approval_request <= 1;
				tx_slave_select <= slave_select[count];
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
			
			else
			begin
				count <= count;
				state <=IDLE;
				master_ready <= 1;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
			
		end
		
		WAIT_ARBITOR:
		begin
			if (arbitor_busy==0 && approval_request==1 && bus_busy == 0)
			begin
				if (count >= SLAVE_LEN-1)
				begin
					count<=0;
					//if (bus_busy==0)
					state <= WAIT_APPROVAL;
					//else	
					//	state <=WAIT_BUS;
				end
				else
				begin
					count <= count+1;
					state <=TRANSMIT_SELECT;
				end
				master_ready <= 0;
				approval_request <= 1;
				tx_slave_select <= slave_select[count];
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
			
			else
			begin
				count <= count;
				state <=WAIT_ARBITOR;
				master_ready <= 0;
				approval_request <= 1;
				tx_slave_select <= tx_slave_select;
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
		end
		
		TRANSMIT_SELECT:
		begin
			if (count >= SLAVE_LEN-1)
			begin
				count <= 0;
				if (bus_busy==0)
					state <=WAIT_APPROVAL;
				else	
					state <=WAIT_BUS;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= slave_select[count];
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
			
			else
			begin
				count <= count+1;
				state <=TRANSMIT_SELECT;
				master_ready <= 0;
				approval_request <= 1;
				tx_slave_select <= slave_select[count];
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
		end
		
		WAIT_BUS:
		begin
			if (bus_busy==0)
			begin
				count <= count;
				state <= WAIT_APPROVAL;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
			
			else
			begin
				count <= count;
				state <= WAIT_BUS;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 0;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
		end
		
		WAIT_APPROVAL:
		begin
			if (approval_grant==1)
			begin
				count <= count+1;
				state <=WAIT_HANDSHAKE;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				if (instruction[0]==1)
				begin
					write_en <= 0;
					read_en <= 1;	
				end
				else
				begin
					write_en <= 1;
					read_en <= 0;	
				end
				tx_address <= address[count];
				tx_data <= data[count];
				tx_done <= 0;
			end
			
			else
			begin
			
				if (bus_busy == 1) 
				begin
					count <= count+1;
					state <= WAIT_ARBITOR;
					master_ready<= 0;
					approval_request <= 1;
					tx_slave_select <= slave_select[count];
					master_valid <= 0;
					write_en <= 0;
					read_en <= 0;	
					tx_address <= tx_address;
					tx_data <= tx_data;
					tx_done <= 0;
				end
				
				else
				begin
					count <= count;
					state <= WAIT_APPROVAL;
					master_ready <= 0;
					approval_request <= 0;
					tx_slave_select <= tx_slave_select;
					master_valid <= 0;
					write_en <= 0;
					read_en <= 0;	
					tx_address <= tx_address;
					tx_data <= tx_data;
					tx_done <= 0;
				end

			end
		end
		
		WAIT_HANDSHAKE:
		begin
			if (master_valid==1 && slave_ready==1)
			begin
				count <= count+1;
				state <=TRANSMIT_DATA_ADDR;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= address[count];
				tx_data <= data[count];
				tx_done <= 0;
			end
			
			else
			begin
				count <= count;
				state <= WAIT_HANDSHAKE;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;	
				tx_address <= tx_address;
				tx_data <= tx_data;
				tx_done <= 0;
			end
		end
		
		TRANSMIT_DATA_ADDR:
		begin
			if (count >= DATA_LEN-1 && count >= ADDR_LEN-1)
			begin
				count <= 0;
				if (instruction[0]==0)
					state <= FINISH;
				else
					state <= READ_WAIT;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= address[count];
				tx_data <= data[count];
				tx_done <= 1;
			end
			
			else if (count >= DATA_LEN-1 && count < ADDR_LEN-1)
			begin
				count <= count+1;
				state <= TRANSMIT_ADDR;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= address[count];
				tx_data <= data[count];
				tx_done <= 0;
			end
			
			else if (count < DATA_LEN-1 && count >= ADDR_LEN-1)
			begin
				count <= count+1;
				state <= TRANSMIT_DATA;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= address[count];
				tx_data <= data[count];
				tx_done <= 0;
			end
			
			else
			begin
				count <= count+1;
				state <= TRANSMIT_DATA_ADDR;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= 0;
				read_en <= 0;	
				tx_address <= address[count];
				tx_data <= data[count];
				tx_done <= 0;
			end
		end
		
		TRANSMIT_DATA:
		begin
			if (count >= DATA_LEN-1)
			begin
				count <= 0;
				if (instruction[0]==0)
					state <= FINISH;
				else
					state <= READ_WAIT;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= tx_address;
				tx_data <= data[count];
				tx_done <= 1;
			end
			
			else
			begin
				count <= count+1;
				state <= TRANSMIT_DATA;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;	
				tx_address <= tx_address;
				tx_data <= data[count];
				tx_done <= 0;
			end
		end
		
		TRANSMIT_ADDR:
		begin
			if (count >= ADDR_LEN-1)
			begin
				count <= 0;
				if (instruction[0]==0)
					state <= FINISH;
				else
					state <= READ_WAIT;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= address[count];
				tx_data <= tx_data;
				tx_done <= 1;
			end
			
			else
			begin
				count <= count+1;
				state <= TRANSMIT_ADDR;
				master_ready <= 0;
				approval_request <= 0;
				tx_slave_select <= tx_slave_select;
				master_valid <= 1;
				write_en <= write_en;
				read_en <= read_en;
				tx_address <= address[count];
				tx_data <= tx_data;
				tx_done <= 0;
			end
		end
		
		READ_WAIT:
		begin
			count <= count;
			if (rx_done == 1)
				state <= IDLE;
			else
				state <= READ_WAIT;
			master_ready <= 1;
			approval_request <= 0;
			tx_slave_select <= tx_slave_select;
			master_valid <= 0;
			write_en <= 0;
			read_en <= 0;	
			tx_address <= tx_address;
			tx_data <= tx_data;
			tx_done <= 0;
		end
		
		FINISH:
		begin
			count <= count;
			state <=IDLE;
			master_ready <= 1;
			approval_request <= 0;
			tx_slave_select <= tx_slave_select;
			master_valid <= 0;
			write_en <= 0;
			read_en <= 0;	
			tx_address <= tx_address;
			tx_data <= tx_data;
			tx_done <= 0;
		end
		
		default:
		begin 
			count <= 0;
			state <= IDLE;
			master_ready <= 1;
			approval_request <= 0;
			tx_slave_select <= tx_slave_select;
			master_valid <= 0;
			write_en <= 0;
			read_en <= 0;
			tx_address <= tx_address;
			tx_data <= tx_data;
			tx_done <= 0;
		end
		
		endcase
end

endmodule