module state_machine (

input   clk,
input  reset,
input  rx_address,
input  rx_data,
output reg [11:0]address,
output reg [7:0]data_byte_out);

reg [3:0]address_bit_idx = 0;
reg [3:0]data_bit_idx = 0;
reg [8:0]data_byte = 0;
reg flag = 0;
reg addr_state = 6'd0;


parameter
addr0 = 0,
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
addr11 = 11;

always @ (addr_state) 
begin
	case (addr_state)
		addr0:
			address[0] = rx_address;
		addr1:
			address[1] = rx_address;
		addr2:
			address[2] = rx_address;
		addr3:
			address[3] = rx_address;
		addr4:
			address[4] = rx_address;
		addr5:
			address[5] = rx_address;
		addr6:
			address[6] = rx_address;
		addr7:
			address[7] = rx_address;
		addr8:
			address[8] = rx_address;
		addr9:
			address[9] = rx_address;
		addr10:
			address[10] = rx_address;
		addr11:
			address[11] = rx_address;
		default:
			address[11] = rx_address;
	endcase
end

always @ (posedge clk or posedge reset) 
begin
if (reset)
	addr_state <= addr0;
else
	case (addr_state)
		addr0:
			addr_state <= addr1;
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
			addr_state <= addr0;
	endcase
end
endmodule