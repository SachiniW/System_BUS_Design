//////////////////////////////////////////////////////////////////////
// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
module uart_rx #(parameter DATA_LEN=8, parameter CLKS_PER_BIT = 87)(
   input            clk,
	input 			  reset,
   input            rx_data,
   output reg       receive_sig = 0,
   output reg [DATA_LEN-1:0] data = 0);
    
parameter IDLE=0, START_BIT=1, DATA_BITS=2, STOP_BIT=3, FINISH=4;
   
reg [2:0] state = IDLE;

integer clk_count = 0;
integer bit_count = 0;
   
reg rx_data_1 = 1;
reg rx_data_2 = 1;

   
// Purpose: Double-register the incoming data.
// This allows it to be used in the UART RX Clock Domain.
// (It removes problems caused by metastability)
always @(posedge clk or posedge reset)
begin
	if (reset == 1)
	begin
		rx_data_1 <= 1;
		rx_data_2 <= 1;
	end
	else
	begin
		rx_data_1 <= rx_data;
		rx_data_2 <= rx_data_1;
	end
end

   
// Purpose: Control RX state machine
always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		state <= IDLE;
		clk_count <= 0;
		bit_count <= 0;
		data <= 0;
		receive_sig <= 0;
	end
	else
		case (state)
		
		IDLE:
		begin
			if (rx_data_2 == 0)
			begin
				state <= START_BIT;
				clk_count <= 0;
			end	
			else
			begin
				state <= IDLE;
				clk_count <= clk_count;
			end
			bit_count <= bit_count;
			data <= data;
			receive_sig <= 0;	
		end
		
		
		// Check middle of start bit to make sure it's still low
		START_BIT :
		begin
			if (clk_count < ((CLKS_PER_BIT-1)/2))
			begin
				state <= START_BIT;
				clk_count <= clk_count+1;
				bit_count <= bit_count;
			end	
			else
			begin
				if (rx_data_2 == 0)
					state <= DATA_BITS;
				else 
					state <= IDLE;
				clk_count <= 0;
				bit_count <= 0;
			end
			data <= data;
			receive_sig <= 0;	
		end		
		
		// Wait CLKS_PER_BIT-1 clock cycles to sample serial data       
		DATA_BITS :
		begin
			if (clk_count < CLKS_PER_BIT-1)
			begin
				state <= DATA_BITS;
				clk_count <= clk_count+1;
				bit_count <= bit_count;
				data <= data;
			end	
			else
			begin
				if (bit_count < DATA_LEN-1)
				begin
					state <= DATA_BITS;
					bit_count <= bit_count+1;
				end
				else
				begin
					state <= STOP_BIT;
					bit_count <= 0;
				end
				clk_count <= 0;
				data[bit_count] <= rx_data_2;
			end
			receive_sig <= 0;	
		end			
		
		// Receive Stop bit.  Stop bit = 1
		STOP_BIT :
		begin
			if (clk_count < CLKS_PER_BIT-1)
			begin
				state <= STOP_BIT;
				clk_count <= clk_count+1;
				receive_sig <= 0;	
			end	
			else
			begin
				if (rx_data_2 == 1)
				begin
					state <= FINISH;
					receive_sig <= 1;
				end
				else
				begin
					state <= IDLE;
					receive_sig <= 0;
				end
				clk_count <= 0;
			end
			bit_count <= bit_count;
			data <= data;
		end	
				
		// Stay here 1 clock
		FINISH :
		begin
			state <= IDLE;
			clk_count <= clk_count;
			bit_count <= bit_count;
			data <= data;
			receive_sig <= 0;
		end
		
		
		default :
		begin
			state <= IDLE;
			clk_count <= 0;
			bit_count <= 0;
			data <= data;
			receive_sig <= 0;
		end
		
		endcase
end
   
endmodule // uart_rx

