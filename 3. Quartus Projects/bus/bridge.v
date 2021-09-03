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
								parameter BURST_LEN=12, CLKS_PER_BIT=87)(
	
	input clk, 
	input reset,
	
	// MASTER
	
	input [1:0]m_instruction,
	input [SLAVE_LEN-1:0]m_slave_select,
	input [ADDR_LEN-1:0]m_address,
	input [DATA_LEN-1:0]m_data_out,
	input [BURST_LEN-1:0]m_burst_num,
	output [DATA_LEN-1:0]m_data_in,
	output m_rx_done,
	output m_tx_done,
	output m_new_rx,	
	
	// SLAVE
	
	input [7:0]s_datain,
	output [11:0]s_address,
	output [7:0]s_data,
	output s_read_en_in,
	output s_write_en_in,

	// UART
	
	input u_send_sig,
   input [DATA_LEN-1:0]u_data_out, 
   output u_tx_busy,
   output u_tx_done,
   output u_receive_sig,
   output [DATA_LEN-1:0]u_data_in);
								

								
endmodule