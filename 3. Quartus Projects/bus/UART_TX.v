
//////////////////////////////////////////////////////////////////////
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of clk)/(Frequency of UART)
// Example: 50 MHz Clock, 19200 baud UART
// (50000000)/(19200) = 2604
  
module uart_tx #(parameter DATA_LEN=8, parameter CLKS_PER_BIT=2604)(
   input       clk,
	input       reset,
   input       send_sig,
   input [DATA_LEN-1:0] data, 
   output reg  tx_busy = 0,
   output reg  tx_data = 1,
   output reg  tx_done = 0);
  
parameter IDLE=0, START_BIT=1, DATA_BITS=2, STOP_BIT=3, FINISH=4;
   
reg [2:0] state = IDLE;	
reg [DATA_LEN-1:0] temp_data = 0;

integer clk_count = 0;
integer bit_count = 0;

     
always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		state <= IDLE;
		clk_count <= 0;
		bit_count <= 0;
		temp_data <= 0;
		tx_data <= 1;
		tx_busy <= 0;
		tx_done <= 0;
	end
	else
		case (state)
		
		IDLE:
		begin
			if (send_sig == 1)
			begin
				state <= START_BIT;
				temp_data <= data;
				tx_busy <= 1;
				clk_count <= 0;
			end	
			else
			begin
				state <= IDLE;
				temp_data <= temp_data;
				tx_busy <= 0;
				clk_count <= clk_count;
			end
			bit_count <= bit_count;
			tx_done <= 0;
			tx_data <= 1;	
		end
		
		
		// Send out Start Bit. Start bit = 0
		START_BIT :
		begin
			if (clk_count < CLKS_PER_BIT-1)
			begin
				state <= START_BIT;
				clk_count <= clk_count+1;
				bit_count <= bit_count;
			end	
			else
			begin
				state <= DATA_BITS;
				clk_count <= 0;
				bit_count <= 0;
			end
			temp_data <= temp_data;
			tx_busy <= tx_busy;
			tx_done <= tx_done;
			tx_data <= 0;	
		end		
		
		// Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
		DATA_BITS :
		begin
			if (clk_count < CLKS_PER_BIT-1)
			begin
				state <= DATA_BITS;
				clk_count <= clk_count+1;
				bit_count <= bit_count;
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
			end
			temp_data <= temp_data;
			tx_busy <= tx_busy;
			tx_done <= tx_done;
			tx_data <= temp_data[bit_count];	
		end			
		
		// Send out Stop bit.  Stop bit = 1
		STOP_BIT :
		begin
			if (clk_count < CLKS_PER_BIT-1)
			begin
				state <= STOP_BIT;
				clk_count <= clk_count+1;
				tx_busy <= 1;
				tx_done <= 0;
			end	
			else
			begin
				state <= FINISH;
				clk_count <= 0;
				tx_busy <= 0;
				tx_done <= 1;
			end
			bit_count <= bit_count;
			temp_data <= temp_data;
			tx_data <= 1;	
		end	
				
		// Stay here 1 clock
		FINISH :
		begin
			state <= IDLE;
			clk_count <= clk_count;
			bit_count <= bit_count;
			temp_data <= temp_data;
			tx_data <= 1;
			tx_busy <= 0;
			tx_done <= 0;
		end
		
		
		default :
		begin
			state <= IDLE;
			clk_count <= 0;
			bit_count <= 0;
			temp_data <= temp_data;
			tx_data <= 1;
			tx_busy <= 0;
			tx_done <= 0;
		end
		
		endcase
end

endmodule