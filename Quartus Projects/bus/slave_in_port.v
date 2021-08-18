module slave_in_port (
	input clk, 
	input reset,
	input rx_address,
	input rx_data,
	input master_valid,
	input read_en,
	input write_en,
	output slave_ready,
	output rx_done,
	output reg[11:0]address,
	output reg[7:0]data);
	

reg     [3:0]addr_state = 0;
reg     [3:0]data_state = 0;
reg addr_idle = 1;
reg data_idle = 1;
reg addr_done = 0;
reg data_done = 0;

assign slave_ready = data_idle & addr_idle;
assign rx_done = addr_done;

wire handshake = master_valid & slave_ready;

parameter 
IDLE = 0, 
addr1 = 1, 
addr2 = 2, 
addr3 = 3, 
addr4 = 4,
addr5 = 5, 
addr6 = 6, 
addr7 = 7, 
addr8 = 8, 
addr9 = 9, 
addr10 = 10, 
addr11 = 11,
addr12 = 12;

always @ (addr_state) 
begin
	case (addr_state)
	IDLE:
	begin
		addr_idle = 1;
		addr_done = 0;
	end
	addr1:
	begin
		address[0] = rx_address;
		addr_idle = 0;
	end
	addr2:
		address[1] = rx_address;
	addr3:
		address[2] = rx_address;
	addr4:
		address[3] = rx_address;
	addr5:
		address[4] = rx_address;
	addr6:
		address[5] = rx_address;
	addr7:
		address[6] = rx_address;
	addr8:
		address[7] = rx_address;
	addr9:
		address[8] = rx_address;
	addr10:
		address[9] = rx_address;
	addr11:
		address[10] = rx_address;
	addr12:
	begin
		address[11] = rx_address;
		addr_done = 1;
	end
	default:
		address[0] = rx_address;
	endcase
end

always @ (posedge clk or posedge reset) 
begin
	if (reset)
		addr_state <= IDLE;
	else
		case (addr_state)
			IDLE:
				if (handshake == 1)
				begin
					addr_state <= addr1;
				end
				else
					addr_state <= IDLE;
			addr1:
				addr_state <= addr2;
			addr2:
				addr_state <= addr3;
			addr3:
				addr_state <= addr4;
			addr4:
				addr_state <= addr5;
			addr5:
				addr_state <= addr6;
			addr6:
				addr_state <= addr7;
			addr7:
				addr_state <= addr8;
			addr8:
				addr_state <= addr9;
			addr9:
				addr_state <= addr10;
			addr10:
				addr_state <= addr11;
			addr11:
				addr_state <= addr12;
			addr12:
				addr_state <= IDLE;
				
		endcase
end


parameter 
data1 = 1, 
data2 = 2, 
data3 = 3, 
data4 = 4,
data5 = 5, 
data6 = 6, 
data7 = 7, 
data8 = 8;

always @ (data_state) 
begin
	case (data_state)
	IDLE:
	begin
		data_idle = 1;
		data_done = 0;
	end
	data1:
	begin
		data[0] = rx_data;
		data_idle = 0;
	end
	data2:
		data[1] = rx_data;
	data3:
		data[2] = rx_data;
	data4:
		data[3] = rx_data;
	data5:
		data[4] = rx_data;
	data6:
		data[5] = rx_data;
	data7:
		data[6] = rx_data;
	data8:
	begin
		data[7] = rx_data;
		data_done = 1;
	end
	default:
		data[0] = rx_data;
	endcase
end

always @ (posedge clk or posedge reset) 
begin
	if (reset)
		data_state <= IDLE;
	else
		case (data_state)
			IDLE:
				if (handshake == 1)
				begin
					data_state <= data1;
				end
				else
					data_state <= IDLE;
			data1:
				data_state <= data2;
			data2:
				data_state <= data3;
			data3:
				data_state <= data4;
			data4:
				data_state <= data5;
			data5:
				data_state <= data6;
			data6:
				data_state <= data7;
			data7:
				data_state <= data8;	
			data8:
				data_state <= IDLE;
		endcase
end
endmodule