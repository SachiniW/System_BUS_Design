/* 
 file name : button_event1.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module button_event1 #(SLAVE_LEN=2, ADDR_LEN=12, DATA_LEN=8)(
	input clk, 
	input reset,
	input button1,
	input button2,
	output busy,
	
	input [DATA_LEN-1:0]data_in,
	input rx_done,
	input tx_done,
	input trans_done,
	output reg [1:0]instrucution,
	output reg [SLAVE_LEN-1:0]slave_select,
	output reg [ADDR_LEN-1:0]address,
	output reg [DATA_LEN-1:0]data_out);
	
reg [1:0]state = 0;
parameter IDLE=0, BUTTON_EVENT_1=1, BUTTON_EVENT_2=2;

reg [DATA_LEN-1:0]rx_val = 0; 

always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		state <= IDLE;
		instruction <= 2'b00;
		slave_select <= 0;
		address <= 0;
		data_out <= 0;
		rx_val <= 0;
		busy <= 0; 
	end	
	
	else
		case(state)
		
		IDLE:
		begin
			if (button1==0)
			begin
				state <= BUTTON_EVENT_1;
				instruction <= 2'b10;
				slave_select <= 0;
				address <= 898;
				data_out <= 77;
				rx_val <= rx_val;
				busy <= 1;
			end
			else if (button2==0)
			begin
				state <= BUTTON_EVENT_2;
				instruction <= 2'b11;
				slave_select <= 0;
				address <= 898;
				data_out <= 85;
				rx_val <= rx_val;
				busy <= 1; 
			end
			else
			begin
				state <= IDLE;
				instruction <= 2'b00;
				slave_select <= slave_select;
				address <= address;
				data_out <= data_out;
				rx_val <= rx_val; 
				busy <= 0;
			end
		end
		
		BUTTON_EVENT_1:
		begin
			if (trans_done==1)
			begin
				state <= IDLE;
				instruction <= 2'b00;
				slave_select <= slave_select;
				address <= address;
				data_out <= data_out;
				rx_val <= rx_val;
				busy <= 0; 
			end
			else
			begin
				state <= BUTTON_EVENT_1;
				instruction <= instruction;
				slave_select <= slave_select;
				address <= address;
				data_out <= data_out;
				rx_val <= rx_val;
				busy <= 1;
			end
		end
		
		BUTTON_EVENT_2:
		begin
			if (trans_done==1)
			begin
				state <= IDLE;
				instruction <= 2'b00;
				slave_select <= slave_select;
				address <= address;
				data_out <= data_out;
				rx_val <= data_in;
				busy <= 0; 
			end
			else
			begin
				state <= BUTTON_EVENT_2;
				instruction <= instruction;
				slave_select <= slave_select;
				address <= address;
				data_out <= data_out;
				rx_val <= rx_val;
				busy <= 1;
			end
		end
		
		default:
		begin
			state <= IDLE;
			instruction <= 2'b00;
			slave_select <= slave_select;
			address <= address;
			data_out <= data_out;
			rx_val <= rx_val;
			busy <= 0;
		end
	endcase
	
	
	
end
endmodule