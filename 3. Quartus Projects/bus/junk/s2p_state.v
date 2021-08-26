module s2p_state (input       clk,
   input  rx_address,
	input  rx_data,
	output reg [11:0]address,
	output reg [7:0]data_byte_out);
	
parameter
address_size = 4'd12,
data_size = 4'd8;

reg [5:0] present = 6'd0;
reg [5:0] next = 6'd1;

reg rst;

reg [3:0]address_bit_idx = 0;
reg [3:0]data_bit_idx = 0;
reg [8:0]data_byte = 0;
reg flag = 0;
reg addr_state = 4'd0;

parameter
addr0 = 4'd0,
addr1 = 4'd1,
addr2 = 4'd2,
addr3 = 4'd3,
addr4 = 4'd4,
addr5 = 4'd5,
addr6 = 4'd6,
addr7 = 4'd7,
addr8 = 4'd8,
addr9 = 4'd9,
addr10 = 4'd10,
addr11 = 4'd11;

always @(posedge clk or posedge rst)
begin 
	if (rst == 1)
	addr_state <= addr0;
	else
	addr_state <= next;
end

always @ (addr_state)
case (addr_state)
	addr0:begin
		address[0] = rx_address;
		next <= addr1;
	end
	addr1:begin
		address[1] = rx_address;
		next <= addr2;
	end
	addr2:begin
		address[2] = rx_address;
		next <= addr3;
	end
	addr3:begin
		address[3] = rx_address;
		next <= addr4;
	end
	addr4:begin
		address[4] = rx_address;
		next <= addr5;
	end
	addr5:begin
		address[5] = rx_address;
		next <= addr6;
	end
	addr6:begin
		address[6] = rx_address;
		next <= addr7;
	end
	addr7:begin
		address[7] = rx_address;
		next <= addr8;
	end
	addr8:begin
		address[8] = rx_address;
		next <= addr9;
	end
	addr9:begin
		address[9] = rx_address;
		next <= addr10;
	end
	addr10:begin
		address[10] = rx_address;
		addr_state <= addr11;
	end
	addr11:begin
		address[11] = rx_address;
		next <= addr0;
	end
endcase



endmodule
		
	
		
