/* 
 file name : uart_port.v

 Description:
	This file contains the uart port 
	It encapsulated the uart_rx and uart_tx.
	Sets the control signals of the bus
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module uart_port #(parameter DATA_LEN=8, parameter CLKS_PER_BIT=87)(
	input clk,
	input reset,
	
   input rx_data,
   output tx_data,
	
	
   input send_sig,
   input [DATA_LEN-1:0] data_out, 
   output tx_busy,
   output tx_done,
   output receive_sig,
   output [DATA_LEN-1:0] data_in);



uart_tx #(.DATA_LEN(DATA_LEN), .CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX(
   .clk(clk),
	.reset(reset),
   .send_sig(send_sig),
   .data(data_out), 
   .tx_busy(tx_busy),
   .tx_data(tx_data),
   .tx_done(tx_done));
	
uart_rx #(.DATA_LEN(DATA_LEN), .CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX(
   .clk(clk),
	.reset(reset),
   .rx_data(rx_data),
   .receive_sig(receive_sig),
   .data(data_in));
	
endmodule