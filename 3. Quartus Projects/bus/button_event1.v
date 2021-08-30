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
	output reg busy,
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	
	input read,
	input write,
	input [DATA_LEN-1:0]data_load,
	input [ADDR_LEN:0]address_load,
	input [SLAVE_LEN-1:0]slave_select_load,
	input [ADDR_LEN:0]burst_num_load,
	
	input [DATA_LEN-1:0]data_in,
	input rx_done,
	input tx_done,
	input trans_done,
	output reg [1:0]instruction=0,
	output reg [SLAVE_LEN-1:0]slave_select=1,
	output reg [ADDR_LEN-1:0]address=0,
	output reg [DATA_LEN-1:0]data_out=0);
	
reg [1:0]state = 0;
parameter IDLE=0, WRITE_EVENT=1, READ_EVENT=2;

reg [DATA_LEN-1:0]rx_val = 0; 

bin27 DISPLAY1 (.clock(clk), .reset(reset), .io_bin(rx_val[3:0]), .io_seven(display1_pin));
bin27 DISPLAY2 (.clock(clk), .reset(reset), .io_bin(rx_val[7:4]), .io_seven(display2_pin));

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
			if (write==1)
			begin
				state <= WRITE_EVENT;
				instruction <= 2'b10;
				slave_select <= slave_select_load;
				address <= address_load;
				data_out <= data_load;
				rx_val <= rx_val;
				busy <= 1;
			end
			else if (read==1)
			begin
				state <= READ_EVENT;
				instruction <= 2'b11;
				slave_select <= slave_select_load;
				address <=  address_load;
				data_out <= data_load;
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
		
		WRITE_EVENT:
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
				state <= WRITE_EVENT;
				instruction <= instruction;
				slave_select <= slave_select;
				address <= address;
				data_out <= data_out;
				rx_val <= rx_val;
				busy <= 1;
			end
		end
		
		READ_EVENT:
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
				state <= READ_EVENT;
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