`timescale 1 ns / 1 ps
module tops_combined_tb();

reg clock,rst,rst_sel1,rst_sel2,rst_sel3,enable1,enable2,enable3;
reg button_raw1,button_raw2,button_raw3;
reg [7:0]switch_array;
reg mode_switch1,mode_switch2,mode_switch3;
wire scaled_clk1, scaled_clk2, scaled_clk3;

parameter CLK_PERIOD=20;
parameter scale=10;

tops_combined DUT (
	.clock(clock), 
	.rst(reset), 
	.rst_sel1(rst_sel1),
	.rst_sel2(rst_sel2),
	.rst_sel3(rst_sel3),
	.enable1(enable1),
	.enable2(enable2),
	.enable3(enable3),
	.button_raw1(button_raw1),
	.mode_switch1(mode_switch1),
	.button_raw2(button_raw2),
	.mode_switch2(mode_switch2),
	.button_raw3(button_raw3),
	.mode_switch3(mode_switch3),
	.switch_array(switch_array),
	.scaled_clk1(scaled_clk1),
	.scaled_clk2(scaled_clk2),
	.scaled_clk3(scaled_clk3));

						
always
		#(CLK_PERIOD/2) clock = ~clock; 
		
initial begin

	clock        <= 0;
	rst	       <= 1;
	rst_sel1     <= 1;
	rst_sel2     <= 1;
	rst_sel3     <= 1;
	enable1      <= 1;
	enable2      <= 1;
	enable3      <= 1;
	button_raw1  <= 1;
	button_raw2  <= 1; 
	button_raw3  <= 1; 
	switch_array <= 6;
	mode_switch1 <= 1;
	mode_switch2 <= 1;
	mode_switch3 <= 1;
	
	#(scale*CLK_PERIOD)

	///////////////////////////////////////////////////////////
	// Test external bus

	switch_array <= 18; 
	button_raw1 <= 0;
	#(1*scale*CLK_PERIOD)  // Bitton press
	button_raw1 <= 1;
	
	#(500*scale*CLK_PERIOD)  // Wait till finish

	
	#30
 
	$finish;
end
						
endmodule