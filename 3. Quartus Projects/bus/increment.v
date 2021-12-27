/* 
 file name : increment.v

 Description:
	A 4k block RAM which acts as a slave
	
 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module increment #(parameter DELAY_COUNT = 20)(  // change this to suit 5s
	input clk,
	input reset,
	
	output [6:0]display1_pin,
	output [6:0]display2_pin,
	
	input button,
	input mode_switch,
	input [7:0]sw_array_data,
	
	//MASTER	
	input m_tx_done,
	output [7:0]m_data_out,
	output reg [1:0]m_instruction,
	
	//SLAVE
	
	input [7:0]s_data,
	input s_write_en_in);
	
	
parameter[1:0] INC_IDLE = 2'd0;
parameter[1:0] DISPLAY_AND_INCREMENT = 2'd1;
parameter[1:0] DATA_SEND = 2'd2;

parameter delay_count = 200/9; // change this to suit 5s

reg [1:0]inc_state =0;
reg [7:0]output_data;
reg [7:0]data_to_master = 0;
reg [5:0]delay_counter = 0;

bin27 DISPLAY1 (.clock(clk), .reset(reset), .io_bin(output_data[3:0]), .io_seven(display1_pin));
bin27 DISPLAY2 (.clock(clk), .reset(reset), .io_bin(output_data[7:4]), .io_seven(display2_pin));	
	
assign m_data_out = data_to_master;	
	
always @(posedge clk or posedge reset)
begin
if (reset == 1'd1)
	begin
		output_data <= 0;
		delay_counter <= 0;
		inc_state <= INC_IDLE;
		m_instruction <= 2'b00;
	end
else
	begin
		case (inc_state)
			INC_IDLE:begin
				if (s_write_en_in == 1 && mode_switch == 1) //when reciever done
				begin
					output_data <= s_data; // Get data from bridge via slave port
					inc_state <= DISPLAY_AND_INCREMENT;
				end
				else if (button == 1 && mode_switch == 1) //when button 1 is pressed (data = sw[7:0])
				begin
					output_data <= sw_array_data; // Get data from bridge via slave port
					inc_state <= DATA_SEND;
				end				
				else
				begin
					output_data <= output_data;
					delay_counter <= 0;
					m_instruction <= 2'b00;
				end
			end
			DISPLAY_AND_INCREMENT:begin
				if (delay_counter == delay_count)
				begin
					delay_counter <= 0;
					output_data <= output_data + 1; //increment and display the data
					inc_state <= DATA_SEND;					
				end
				else
				begin
					delay_counter <= delay_counter + 1;
				end
			end
			DATA_SEND:begin
				if (m_tx_done == 1) 
				begin	
					inc_state <= INC_IDLE;
					m_instruction <= 2'b00;
				end
				else
				begin
					data_to_master <= output_data; //send data to bridge via master port
					m_instruction <= 2'b10;
				end
			end
			default:begin
					output_data <= 0;
					delay_counter <= 0;
					m_instruction <= 2'b00;
					inc_state <= INC_IDLE;
				end
		endcase			
	end
end
						
endmodule
	