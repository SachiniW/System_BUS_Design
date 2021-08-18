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
//reg [7:0]data = 0;

assign slave_ready = data_idle;
assign slave_tx_done = data_done;

parameter 
IDLE  = 0,
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
		tx_data = datain[0];
		data_idle = 0;
	end
	data2:
		tx_data = datain[1];
	data3:
		tx_data = datain[2];
	data4:
		tx_data = datain[3];
	data5:
		tx_data = datain[4];
	data6:
		tx_data = datain[5];
	data7:
		tx_data = datain[6];
	data8:
	begin
		tx_data = datain[7];
		data_done = 1;
	end
	default:
		tx_data = datain[0];
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
				begin
					data_state <= IDLE;
//					data <= datain;
				end
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