/* 
 file name : button_event1.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module button_event1 #(parameter SLAVE_LEN=2, parameter ADDR_LEN=12, parameter DATA_LEN=8)(
	input clk, 
	input reset,
	input button1,
	input button2,
	output busy1,///changed
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	
	input [DATA_LEN-1:0]data_in,
	input rx_done,
	input tx_done,
	input trans_done,
	output reg [1:0]instruction,
	output reg [SLAVE_LEN-1:0]slave_select,
	output reg [ADDR_LEN-1:0]address,
	output reg [DATA_LEN-1:0]data_out,
	input tx_data,  ///temp
	input [3:0]state1, ////temp
	input [3:0]temp_state); ///temp
	

assign busy1 = tx_data;//tx_done || rx_done;	///temp
reg busy;   ////temp
	
reg [1:0]state = 0;
parameter IDLE=0, BUTTON_EVENT_1=1, BUTTON_EVENT_2=2;

reg [DATA_LEN-1:0]rx_val = 0; 

bin27 DISPLAY1 (.clock(clk), .reset(reset), .io_bin(state1), .io_seven(display1_pin));///changed
bin27 DISPLAY2 (.clock(clk), .reset(reset), .io_bin(temp_state), .io_seven(display2_pin));///changed

always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		state <= IDLE;
		instruction <= 2'b00;
		slave_select <= 1;
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
				slave_select <= 1;
				address <= 1;
				data_out <= 77;
				rx_val <= rx_val;
				busy <= 1;
			end
			else if (button2==0)
			begin
				state <= BUTTON_EVENT_2;
				instruction <= 2'b11;
				slave_select <= 1;
				address <=  1;
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