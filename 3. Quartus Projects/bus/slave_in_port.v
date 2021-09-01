/* 
 file name : slave_in_port.v

 Description:
	This file contains the input port of the slave port.
	It is responsible for receiving the address and data from 
	the master.

 Maintainers : Sanjula Thiranjaya <sthiranjaya@gmail.com>
					Sachini Wickramasinghe <sswickramasinghe@gmail.com>
					Kavish Ranawella <kavishranawella@gmail.com>
					
 Revision : v1.0 
*/

module slave_in_port (
	input clk, 
	input reset,
	input rx_address,
	input rx_data,
	// input rx_burst, //new
	input master_valid,
	input read_en,
	input write_en,
	input slave_valid,
	input [11:0]burst,  ////new
	output [3:0]temp_data_state, ///temp
	output [3:0]temp_addr_state, ///temp
	output [3:0]temp_data_counter, ///temp
	output [3:0]temp_addr_counter, ///temp
	output temp_signal,  ////temp
	output slave_ready,
	output reg rx_done,
	output reg[11:0]address,
	output reg[7:0]data,
	output read_en_in2,
	output read_en_in,
	output write_en_in,
	output reg[11:0] burst_counter = 12'd0); //new
	
// reg [11:0]burst       = 12'd4;    
// reg [11:0]burst       = 12'd4;   ///make burst --> burst in addr
// reg [11:0]burst_counter = 12'd0;
reg [3:0]addr_state   = 4'd13;
reg [3:0]data_state   = 4'd13;
reg addr_idle         = 1;
reg data_idle         = 1;
reg data_done         = 0;
reg [3:0]addr_counter = 4'd0;
reg [3:0]data_counter = 4'd0;
reg read_en_in1       = 0;
reg write_en_in1      = 0;

reg test_handshake = 1;  //remove
wire handshake     = master_valid & slave_ready & test_handshake; //remove  -->handshake-->write_handshake
// wire handshake     = master_valid & slave_ready;
wire read_handshake = 1;
// wire handshake = write_handshake || read_handshake;

assign slave_ready = data_idle & addr_idle;
assign read_en_in  = rx_done & read_en_in1;
assign write_en_in = rx_done & write_en_in1;
assign read_en_in2 = read_en_in1;

assign temp_data_counter = data_counter;
assign temp_addr_counter = addr_counter;
assign temp_data_state = data_state; ///temp
assign temp_addr_state = addr_state; ///temp
assign temp_signal = handshake; ///temp



// Statemachine to capture the 12 bit address
parameter 
IDLE                = 13, 
ADDR_RECIEVE        = 1,
ADDR_INC_BURST      = 2, 
DATA_RECIEVE 	    = 3,
DATA_BURST_GAP      = 4,
DATA_RECIEVE_BURST  = 5,
ADDR_WAIT_HANDSHAKE = 6;

always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		addr_state   <= IDLE;
		addr_counter <= 4'd0;
		addr_idle    <= 1;
		read_en_in1	 <= 0;
		write_en_in1 <= 0;
		burst_counter <= 0;
	end
	else
	begin
		case (addr_state)
			IDLE:
			begin
				// if ((handshake == 1'd1) && (burst_counter < burst)) 
				if ((handshake == 1'd1)) 
					begin
						addr_state            <= ADDR_RECIEVE;
						addr_counter          <= addr_counter + 4'd1;
						address[addr_counter] <= rx_address;
						addr_idle             <= 0;
						rx_done 			  <= 0;
						read_en_in1	 		  <= read_en;
						write_en_in1 		  <= write_en;
						burst_counter <= 0;
						// test_handshake <= 1 ;  //remove
					end
				else
					begin
						addr_state    <= IDLE;
					    addr_counter  <= 4'd0;
						addr_idle     <= 1;
						rx_done 	  <= 0;
						read_en_in1	  <= 0;
						write_en_in1  <= 0;
						burst_counter <= burst_counter;
						// test_handshake <= 0;  //remove
					end
			end
			ADDR_RECIEVE:
			begin
				if (addr_counter < 4'd11)
				begin
					addr_state            <= addr_state;
					addr_counter          <= addr_counter + 4'd1;
					address[addr_counter] <= rx_address;
					addr_idle             <= 0;
					rx_done 			  <= 0;
				end
				else 
				begin
					if ((burst_counter < burst-1) && handshake == 1)        addr_state <= ADDR_INC_BURST;   //change to check 0th bit
					else if ((burst_counter < burst-1) && handshake == 0)   addr_state <= ADDR_WAIT_HANDSHAKE;  //chnage to check 0th bit
					else 							                         addr_state <= IDLE;
					addr_counter          <= 0;
					address[addr_counter] <= rx_address;
					addr_idle             <= 1;
					rx_done 			  <= 1;
					burst_counter 		  <= burst_counter + 1;
					test_handshake        <= 0;  //remove
				end
			end
			ADDR_WAIT_HANDSHAKE:
			begin
				if (handshake == 1) 
				begin
					addr_state <= ADDR_INC_BURST;
					addr_counter <= addr_counter + 1;
					rx_done <= 0;
				end
				// else if (read_en_in1 == 1 && read_handshake == 1)
				// begin
				// 	addr_state <= ADDR_INC_BURST;
				// 	addr_counter <= addr_counter + 1;
				// 	rx_done <= 0;
				// end
				else 
				begin
					addr_state <= ADDR_WAIT_HANDSHAKE;
					rx_done <= 0;
				end
			end
			ADDR_INC_BURST:
			begin
				// if ((addr_counter < 4'd7) && (burst_counter < burst))
				if ((addr_counter < 4'd7))
				begin
					addr_state <= addr_state;
					addr_counter <= addr_counter + 4'd1;
					addr_idle <= 1;
					rx_done <= 0;
				end
				else 
				begin
					if (burst_counter < burst-1)  
					begin
						addr_state <= ADDR_WAIT_HANDSHAKE;
						addr_counter <= 0;
						addr_idle <= 1;
						burst_counter <= burst_counter + 1;
						address <= address + 1;
						rx_done <= 1;
					end
					else             
					begin           
						addr_state <= IDLE;
						addr_counter <= 0;
						addr_idle <= 1;
						burst_counter <= burst_counter + 1;
						address <= address + 1;
						rx_done <= 1;
						test_handshake <= 0;  ///remove this
					end
				end
			end
			default:
			begin
				addr_state   <= IDLE;
				addr_counter <= 4'd0;
				addr_idle    <= 1;
			end
		endcase
	end 
end


// Statemachine to capture the 8 bit data

always @ (posedge clk or posedge reset) 
begin
	if (reset)
	begin
		data_state <= IDLE;
		data_counter <= 0;
		data_idle <= 1;
	end
	else
	begin
		case (data_state)
			IDLE:
			begin
				// if ((handshake == 1'd1) && (burst_counter < burst)) //handshake
				if (handshake == 1'd1 && (write_en || write_en_in1))
					begin
						data_state         <= DATA_RECIEVE;
						data_counter       <= data_counter + 4'd1;
						data[data_counter] <= rx_data;
						data_idle          <= 0;
					end
				else
					begin
						data_state    <= data_state;
						data_counter  <= 0;
						data_idle     <= 1;
					end
			end
			DATA_RECIEVE:
			begin
				if (data_counter < 4'd7 && write_en_in1 == 1)
				begin
					data_state         <= data_state;
					data_counter       <= data_counter + 4'd1;
					data[data_counter] <= rx_data;
					data_idle <= 0;
				end
				else 
				begin
					if (burst_counter == 0 && write_en_in1 == 1) data_state <= DATA_BURST_GAP;
					else 		
					begin
						data_state <= IDLE;
						data_idle <= 1;
					end			
					data_counter <= 0;
					data[data_counter] <= rx_data;
				end
			end
			DATA_BURST_GAP:
			begin
				if (data_counter < 3)
				begin
					data_state <= DATA_BURST_GAP;
					data_counter <= data_counter + 1;	
					data_idle <= 0;
				end
				else
				begin
					data_state <= IDLE;
					data_counter <= 0;
					data_idle <= 1; //this
				end
			end
			default:
			begin
				data_state <= IDLE;
			end
		endcase
	end
end

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
// 				if (handshake == 1'd1) //handshake
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
// 					data_state <= DATA_BURST_GAP;
// 					data_counter <= 0;
// 					data[data_counter] <= rx_data;
// 					data_idle <= 0;
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
// 			        if (burst > 0)  data_state <= DATA_RECIEVE_BURST;
// 					else            data_state <= IDLE;
// 					data_counter <= 0;
// 					data_idle <= 1;
// 				end
// 			end
// 			DATA_RECIEVE_BURST:
// 			begin
// 				if (data_counter < 4'd7 || test_handshake == 1)
// 				begin
// 					data_state <= data_state;
// 					data_counter <= data_counter + 4'd1;
// 					data[data_counter] <= rx_data;
// 					data_idle <= 0;
// 				end
// 				else if (data_counter < 4'd7 || ~(test_handshake == 1))
// 				begin
// 					if (burst-1 > burst_counter)  
// 					begin
// 						data_state <= DATA_RECIEVE_BURST;
// 						data_counter <= 0;
// 						data[data_counter] <= rx_data;
// 						data_idle <= 1;
// 					end
// 					else             
// 					begin           
// 						data_state <= IDLE;
// 						data_counter <= 0;
// 						data[data_counter] <= rx_data;
// 						data_idle <= 1;
// 					end
// 				end
// 				else
// 				begin
// 					data_state <= DATA_RECIEVE_BURST;
// 					data_idle <= 0;
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
