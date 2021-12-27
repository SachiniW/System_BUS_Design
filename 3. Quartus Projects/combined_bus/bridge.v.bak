/* 
 file name : bridge.v

 Description:
	This file contains the code for a bridge between UART and the bus.
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module bridge #(parameter SLAVE_LEN=2, parameter ADDR_LEN=12, parameter DATA_LEN=8, 
								parameter BURST_LEN=12, parameter CLKS_PER_BIT=2604, parameter MAX_COUNT=50000)(
	
	input clk, 
	input bus_clk,
	input reset,
	
	// MASTER
	
	input m_rx_done,	//not used
	input m_tx_done,
	input m_new_rx,	//not used
	input [DATA_LEN-1:0]m_data_in, 	//not used
	output reg [1:0]m_instruction = 2'b00,
	output reg [SLAVE_LEN-1:0]m_slave_select = 1,
	output reg [ADDR_LEN-1:0]m_address = 0,
	output reg [DATA_LEN-1:0]m_data_out = 0,
	output reg [BURST_LEN-1:0]m_burst_num = 0,
	
	
	// SLAVE
	
	input [11:0]s_address, 	//not used
	input [7:0]s_data,
	input s_read_en_in,	//not used
	input s_write_en_in,
	output reg [7:0]s_datain = 0, //not used

	// UART
	
	input u_tx_busy,
   input u_tx_done,
   input u_receive_sig,
   input [DATA_LEN-1:0]u_data_in,
	output reg u_send_sig = 0,
   output reg [DATA_LEN-1:0]u_data_out = 0);
	
reg m_state = 0;
parameter M_IDLE=0, MASTER_OUT=1;

reg [2:0]u_state = 0;
parameter U_IDLE=0, UART_DATA_OUT=1, UART_ACK_OUT=2, UART_ACK_IN=3, U_WAIT=4;

integer count = 0;
integer time_count = 0;
								
always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		m_state <= M_IDLE;
		m_instruction <= 2'b00;
		m_slave_select <= 1;
		m_address <= 0;
		m_data_out <= 0;
		m_burst_num <= 0;
		u_state <= U_IDLE;
		u_data_out <= 0;
		u_send_sig <= 0;
		count <= 0;
		time_count <= 0;
	end	
	
	else
	begin
		// Controls Master
		case(m_state)
		
		M_IDLE:
		begin
			if (u_receive_sig==1)
			begin
				m_state <= MASTER_OUT;
				m_instruction <= 2'b10;
				m_slave_select <= 1;
				m_address <= 0;
				m_data_out <= u_data_in;
				m_burst_num <= 0;
			end
			else
			begin
				m_state <= M_IDLE;
				m_instruction <= 2'b00;
				m_slave_select <= m_slave_select;
				m_address <= m_address;
				m_data_out <= m_data_out;
				m_burst_num <= m_burst_num;
			end
		end
		
		MASTER_OUT:
		begin
			if (m_tx_done==1)
			begin
				m_state <= M_IDLE;
				m_instruction <= 2'b00;
			end
			else
			begin
				m_state <= MASTER_OUT;
				m_instruction <= m_instruction;
			end
			m_slave_select <= m_slave_select;
			m_address <= m_address;
			m_data_out <= m_data_out;
			m_burst_num <= m_burst_num;
		end
		
		default:
		begin
			m_state <= M_IDLE;
			m_instruction <= 2'b00;
			m_slave_select <= m_slave_select;
			m_address <= m_address;
			m_data_out <= m_data_out;
			m_burst_num <= m_burst_num;
		end
		endcase
		
		// Controls UART
		case(u_state)
		
		U_IDLE:
		begin
			if (u_receive_sig==1)
			begin
				u_state <= UART_ACK_OUT;
				u_data_out <= 204;
				u_send_sig <= 1;
				count <= count;
				time_count <= time_count;
			end
			else if (s_write_en_in==1)
			begin
				u_state <= UART_DATA_OUT;
				u_data_out <= s_data;
				u_send_sig <= 1;
				count <= 0;
				time_count <= 0;
			end
			else
			begin
				u_state <= U_IDLE;
				u_data_out <= u_data_out;
				u_send_sig <= 0;
				count <= count;
				time_count <= time_count;
			end
		end
		
		UART_ACK_OUT:
		begin
			if (u_tx_done==1)
			begin
				u_state <= U_IDLE;
			end
			else
			begin
				u_state <= UART_ACK_OUT;
			end
			u_data_out <= u_data_out;
			u_send_sig <= 0;
			count <= count;
			time_count <= time_count;
		end
		
		UART_DATA_OUT:
		begin
			if (u_tx_done==1)
			begin
				u_state <= UART_ACK_IN;
				count <= count+1;
				time_count <= 0;
			end
			else
			begin
				u_state <= UART_DATA_OUT;
				count <= count;
				time_count <= time_count;
			end
			u_data_out <= u_data_out;
			u_send_sig <= 0;
		end
		
		UART_ACK_IN:
		begin
			if (u_receive_sig==1)
			begin
				if (u_data_in == 204)
				begin
					if (s_write_en_in==0)
						u_state <= U_IDLE;
					else
						u_state <= U_WAIT;
					u_send_sig <= 0;
					count <= 0;
				end
				else
				begin
					u_state <= UART_DATA_OUT;
					u_send_sig <= 1;
					count <= count;
				end
				time_count <= 0;
			end
			else
			begin
				if (time_count >= MAX_COUNT)
				begin
					if (count >= 5)
					begin
						if (s_write_en_in==0)
							u_state <= U_IDLE;
						else
							u_state <= U_WAIT;
						u_send_sig <= 0;
						count <= 0;
					end
					else
					begin
						u_state <= UART_DATA_OUT;
						u_send_sig <= 1;
						count <= count;
					end
					time_count <= 0;
				end
				else
				begin
					u_state <= UART_ACK_IN;
					u_send_sig <= 0;
					count <= count;
					time_count <= time_count+1;
				end
			end
			u_data_out <= u_data_out;
		end
		
		U_WAIT:
		begin
			if (s_write_en_in==0)
				u_state <= U_IDLE;
			else
				u_state <= U_WAIT;
			u_data_out <= u_data_out;
			u_send_sig <= u_send_sig;
			count <= count;
			time_count <= time_count;
		end
		
		default:
		begin
			u_state <= U_IDLE;
			u_data_out <= u_data_out;
			u_send_sig <= 0;
			count <= 0;
			time_count <= 0;
		end
		endcase
	end
	
end
								
endmodule