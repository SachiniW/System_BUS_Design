module s2p (input       clk,
   input  rx_address,
	input  rx_data,
	output reg [11:0]address,
	output reg [7:0]data_byte_out);
	
parameter
address_size = 4'd12,
data_size = 4'd8;

reg [3:0]address_bit_idx = 0;
reg [3:0]data_bit_idx = 0;
reg [8:0]data_byte = 0;
reg flag = 0;

always @ (posedge clk)
begin
	data_byte[data_bit_idx] <= rx_data;
	address[address_bit_idx] <= rx_address;
	
	if (address_bit_idx < address_size)
		address_bit_idx <= address_bit_idx + 1;
	else
		address_bit_idx <= 0;
		data_bit_idx <= 0;
		
	if (data_bit_idx < data_size)
		data_bit_idx <= data_bit_idx + 1;
	else
		data_byte_out <= data_byte[8:1];
		data_bit_idx <= 0;
end

endmodule
		
	
		
