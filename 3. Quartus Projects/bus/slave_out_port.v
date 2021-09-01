/* 
 file name : slave_out_port.v

 Description:
	This file contains the output port of the slave port.
	It is responsible for sending the requested data back 
	to master.

 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module slave_out_port (
	input clk, 
	input reset,
	input master_ready,
	input [7:0]datain,
	input slave_valid,
	output slave_ready,
	output reg slave_tx_done,
	output reg tx_data,
	// output read_en_in,
	input read_en_in1,
	output [3:0]temp_tx_data_counter,
	output [3:0]tx_data_state);

// reg [11:0]burst   = 12'd4;
// reg [11:0]burst_counter = 12'd0;
reg [3:0]data_state = 0;
reg data_idle;
wire handshake = slave_valid & master_ready;

assign slave_ready = data_idle;

parameter 
IDLE  = 4'd13,
DATA_TRANSMIT = 4'd1,
DATA_TRANSMIT_BURST = 4'd2;

reg [3:0]data_counter = 4'd0;

// assign read_en_in  = rx_done & read_en_in1;
assign temp_tx_data_counter = data_counter; //temp
assign tx_data_state = data_state;  //temp

always @ (posedge clk or posedge reset) 
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
					data_state <= DATA_TRANSMIT;
					tx_data <= datain[1];
					data_counter <= data_counter + 4'd2;
					data_idle <= 0;
					slave_tx_done <= 0;
					// burst_counter <= burst_counter + 1;
				end
				else
				begin 
					data_state <= IDLE;
					tx_data <= datain[data_counter];
					data_counter <= 0;
					data_idle <= 1;
					slave_tx_done <= 0;
					// burst_counter <= 0;
				end
			end
			DATA_TRANSMIT:
			begin 
				if (data_counter < 4'd7)
					begin
						data_state <= data_state;
						tx_data <= datain[data_counter];
						data_counter <= data_counter + 4'd1;
						data_idle <= 0;
						slave_tx_done <= 0;
					end
				else 
					begin
						data_state <= IDLE;
						tx_data <= datain[data_counter];
						data_counter <= 0;
						data_idle <= 0;	
						slave_tx_done <= 1;	
						// burst_counter <= burst_counter + 1;			
					end
			end 
			default:
				begin
					tx_data <= 0;
					data_state <= IDLE;
				end
		endcase
	end
end

// 			DATA_TRANSMIT_BURST:
// 			if (data_counter < 4'd7)
// 			begin
// 				data_state <= data_state;
// 				tx_data <= datain[data_counter];
// 				data_counter <= data_counter + 4'd1;
// 				data_idle <= 0;
// 			end
// 			else 
// 			begin
// 				if (burst - 1 > burst_counter)  
// 				begin
// 					data_state <= DATA_TRANSMIT_BURST;
// 					tx_data <= datain[data_counter];
// 					data_counter <= 0;
// 					data_idle <= 0;
// 					burst_counter <= burst_counter + 1;
// 				end
// 				else             
// 				begin           
// 					data_state <= IDLE;
// 					tx_data <= datain[data_counter];
// 					data_counter <= 0;
// 					data_idle <= 0;
// 					burst_counter <= burst_counter + 1;
// 				end
// 			end
// always @ (posedge clk or posedge reset) 
// begin
// 	if (reset)
// 	begin
// 		data_state <= IDLE;
// 		data_counter <= 0;
// 		data_idle <= 1;
// 	end
// 	else
// 	begin
// 		case (data_state)
// 			IDLE:
// 			begin
// 				// if ((handshake == 1'd1) && (burst_counter < burst)) //handshake
// 				if ((handshake == 1'd1))
// 					begin
// 						data_state         <= DATA_RECIEVE;
// 						data_counter       <= data_counter + 4'd1;
// 						data[data_counter] <= rx_data;
// 						data_idle          <= 0;
// 					end
// 				else
// 					begin
// 						data_state    <= data_state;
// 						data_counter  <= 0;
// 						data_idle     <= 1;
// 					end
// 			end
// 			DATA_RECIEVE:
// 			begin
// 				if (data_counter < 4'd7)
// 				begin
// 					data_state         <= data_state;
// 					data_counter       <= data_counter + 4'd1;
// 					data[data_counter] <= rx_data;
// 					data_idle <= 0;
// 				end
// 				else 
// 				begin
// 					if (burst_counter == 0) data_state <= DATA_BURST_GAP;
// 					else 		
// 					begin
// 						data_state <= IDLE;
// 						data_idle <= 1;
// 					end			
// 					data_counter <= 0;
// 					data[data_counter] <= rx_data;
// 				end
// 			end
// 			DATA_BURST_GAP:
// 			begin
// 				if (data_counter < 3)
// 				begin
// 					data_state <= DATA_BURST_GAP;
// 					data_counter <= data_counter + 1;	
// 					data_idle <= 0;
// 				end
// 				else
// 				begin
// 					data_state <= IDLE;
// 					data_counter <= 0;
// 					data_idle <= 1; //this
// 				end
// 			end
// 			default:
// 			begin
// 				data_state <= IDLE;
// 			end
// 		endcase
// 	end
// end

endmodule