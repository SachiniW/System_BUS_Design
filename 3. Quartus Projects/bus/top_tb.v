`timescale 1 ns / 1 ps
module top_tb();

reg clk, reset, m1_button1, m1_button2, m2_button1, m2_button2;
wire m1_busy,m2_busy; 

parameter CLK_PERIOD=20;

top DUT (
	.clk(clk), 
	.reset(reset), 
	.m1_button1(m1_button1),
	.m1_button2(m1_button2),
	.m2_button1(m2_button1),
	.m2_button2(m2_button2),
	.m1_busy(m1_busy),
	.m2_busy(m2_busy));
						
always
		#(CLK_PERIOD/2) clk = ~clk; 
		
initial begin

	clk <= 1'b0;
	reset <= 1'b0;
	m1_button1 <= 1'b1;
	m1_button2 <= 1'b1;
	m2_button1 <= 1'b1;
	m2_button2 <= 1'b1;
	
	#CLK_PERIOD
	
	m1_button1 <= 1'b0;
	#CLK_PERIOD
	m1_button1 <= 1'b1;
	
	#(20*CLK_PERIOD)
	
	m1_button2 <= 1'b0;
	#CLK_PERIOD
	m1_button2 <= 1'b1;
	

	#(40*CLK_PERIOD)


	m2_button1 <= 1'b0;
	#CLK_PERIOD
	m2_button1 <= 1'b1;
	
    #(20*CLK_PERIOD)
	
	m2_button2 <= 1'b0;
	#CLK_PERIOD
	m2_button2 <= 1'b1;
	
	#(40*CLK_PERIOD)
	
//	i_dram_read <= 1'b1;
//	i_dram_addr <= 16'b0000000000100100;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01111100)
//		$display("element 1 correct");
//	else 
//		$display("element 1 wrong");
//	
//	i_dram_addr <= 16'b0000000000100101;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b00101101)
//		$display("element 2 correct");
//	else 
//		$display("element 2 wrong");
//	
//	i_dram_addr <= 16'b0000000000100110;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b11000010)
//		$display("element 3 correct");
//	else 
//		$display("element 3 wrong");
//	
//	i_dram_addr <= 16'b0000000000100111;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01001001)
//		$display("element 4 correct");
//	else 
//		$display("element 4 wrong");
//	
//	i_dram_addr <= 16'b0000000000101000;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b11000100)
//		$display("element 5 correct");
//	else 
//		$display("element 5 wrong");
//	
//	i_dram_addr <= 16'b0000000000101001;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b00110001)
//		$display("element 6 correct");
//	else 
//		$display("element 6 wrong");
//	
//	i_dram_addr <= 16'b0000000000101010;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01000100)
//		$display("element 7 correct");
//	else 
//		$display("element 7 wrong");
//	
//	i_dram_addr <= 16'b0000000000101011;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01000011)
//		$display("element 8 correct");
//	else 
//		$display("element 8 wrong");
//	
//	i_dram_addr <= 16'b0000000000101100;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b11001011)
//		$display("element 9 correct");
//	else 
//		$display("element 9 wrong");
//	
//	i_dram_addr <= 16'b0000000000101101;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01011000)
//		$display("element 10 correct");
//	else 
//		$display("element 10 wrong");
//	
//	i_dram_addr <= 16'b0000000000101110;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01101001)
//		$display("element 11 correct");
//	else 
//		$display("element 11 wrong");
//	
//	i_dram_addr <= 16'b0000000000101111;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01011111)
//		$display("element 12 correct");
//	else 
//		$display("element 12 wrong");
//	
//	i_dram_addr <= 16'b0000000000110000;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b11011100)
//		$display("element 13 correct");
//	else 
//		$display("element 13 wrong");
//	
//	i_dram_addr <= 16'b0000000000110001;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b01111101)
//		$display("element 14 correct");
//	else 
//		$display("element 14 wrong");
//	
//	i_dram_addr <= 16'b0000000000110010;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b00011111)
//		$display("element 15 correct");
//	else 
//		$display("element 15 wrong");
//	
//	i_dram_addr <= 16'b0000000000110011;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b10110001)
//		$display("element 16 correct");
//	else 
//		$display("element 16 wrong");
//	
//	i_dram_addr <= 16'b0000000000110100;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b10111111)
//		$display("element 17 correct");
//	else 
//		$display("element 17 wrong");
//	
//	i_dram_addr <= 16'b0000000000110101;
//	
//	#62.5
//	
//	if (o_dram_data_out == 8'b11000111)
//		$display("element 18 correct");
//	else 
//		$display("element 18 wrong");
		
	#30
 
	$finish;
end
						
endmodule