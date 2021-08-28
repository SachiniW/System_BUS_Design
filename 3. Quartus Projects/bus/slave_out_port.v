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
	output slave_tx_done,
	output reg tx_data);

reg [3:0]data_state = 0;
reg data_idle;
reg data_done;
wire handshake = slave_valid & master_ready;

assign slave_ready = data_idle;
assign slave_tx_done = data_done;

parameter 
IDLE  = 0,
DATA1 = 1, 
DATA2 = 2, 
DATA3 = 3, 
DATA4 = 4,
DATA5 = 5, 
DATA6 = 6, 
DATA7 = 7, 
DATA8 = 8;

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
					data_state <= DATA1;
					tx_data <= datain[0];
					data_idle <= 0;
					data_done <= 0;
				end
				else
				begin 
					data_state <= IDLE;
					tx_data <= 0;
					data_idle <= 1;
					data_done <= 0;
				end
			end
			DATA1:
			begin 
				data_state <= DATA2;
				tx_data <= datain[1];
				data_idle <= 0;
				data_done <= 0;
			end 
			DATA2:
			begin 
				data_state <= DATA3;
				tx_data <= datain[2];
				data_idle <= 0;
				data_done <= 0;
			end 
			DATA3:
			begin 
				data_state <= DATA4;
				tx_data <= datain[3];
				data_idle <= 0;
			    data_done <= 0;
			end 
			DATA4:
			begin 
				data_state <= DATA5;
				tx_data <= datain[4];
				data_idle <= 0;
				data_done <= 0;
			end 
			DATA5:
			begin 
				data_state <= DATA6;
				tx_data <= datain[5];
				data_idle <= 0;
				data_done <= 0;
			end 
			DATA6:
			begin 
				data_state <= DATA7;
				tx_data <= datain[6];
				data_idle <= 0;
			    data_done <= 0;
			end 
			DATA7:
			begin 
				data_state <= IDLE;
				tx_data <= datain[7];
				data_idle <= 0;
				data_done <= 1;
			end 	
			// DATA8:
			// begin 
			// 	data_state <= IDLE;
			// 	tx_data <= datain[7];
			// 	data_idle <= 0;
			// 	data_done <= 1;
			// end 
			default:
				tx_data <= 0;
		endcase
	end
end

endmodule