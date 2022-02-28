`timescale 1 ns / 1 ps
module top_tb();

reg clk, reset, enable, button1_raw, button2_raw, button3_raw, mode_switch, rw_switch1,
	 rw_switch2;

reg [11:0]switch_array;

wire m1_busy,m2_busy, scaled_clk; 

parameter CLK_PERIOD=20;
parameter scale=10;

top DUT (
	.clock(clk), 
	.rst(reset), 
	.enable(enable),
	.button1_raw(button1_raw),
	.button2_raw(button2_raw),
	.button3_raw(button3_raw),
	.mode_switch(mode_switch),
	.rw_switch1(rw_switch1),
	.rw_switch2(rw_switch2),
	.switch_array(switch_array),
	.m1_busy(m1_busy),
	.m2_busy(m2_busy),
	.scaled_clk(scaled_clk));

						
always
		#(CLK_PERIOD/2) clk = ~clk; 
		
initial begin

	clk <= 0;
	reset <= 1;
	enable <= 1;
	button1_raw <= 1;
	button2_raw <= 1;
	button3_raw <= 1;
	mode_switch <= 1;
	rw_switch1 <= 0;
	rw_switch2 <= 0;
	switch_array <= 0;
	
	#(scale*CLK_PERIOD)
	reset <= 0;
	#(scale*CLK_PERIOD)
	reset <= 1;
	#(scale*CLK_PERIOD)

	//////////////////////////////////////////////////
	// Test without burst

	// mode_switch <= 0;
	// switch_array <= 10; 
	// button3_raw <= 0;
	// #(5*scale*CLK_PERIOD)  // Button press (0 to 5)
	// switch_array <= 0; 
	// #(2*scale*CLK_PERIOD)  // Button press (5 to 0)
	// button3_raw <= 1;

	// mode_switch <= 1;
	// button1_raw <= 0;
	// #(scale*CLK_PERIOD)  // Write
	// button1_raw <= 1;
	
	// #(50*scale*CLK_PERIOD)  // Write without burst

	// rw_switch1 <= 1;
	// button1_raw <= 0;
	// #(scale*CLK_PERIOD)  // Read
	// button1_raw <= 1;
	
	// #(100*scale*CLK_PERIOD)  // Read without burst


	//////////////////////////////////////////////////
	// Test with burst

	mode_switch <= 0;
	switch_array <= 129;	
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (0 to 1)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (1 to 2)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (2 to 3)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (3 to 4)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (4 to 5)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (5 to 6)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	button3_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Button press (6 to 0)
	button3_raw <= 1;
	#(1*scale*CLK_PERIOD)
	//
	//	mode_switch <= 1;
	//	rw_switch1 <= 0;
	//	button1_raw <= 0;
	//	#(scale*CLK_PERIOD)  // Write
	//	button1_raw <= 1;
	//	
	//	#(200*scale*CLK_PERIOD)  // Write with burst
	//
	//	rw_switch1 <= 1;
	//	button1_raw <= 0;
	//	#(scale*CLK_PERIOD)  // Read
	//	button1_raw <= 1; 
	//	
	//	#(400*scale*CLK_PERIOD)  // Read with burst

	///////////////////////////////////////////////////////////
	// Test split

//	mode_switch <= 0;
//	switch_array <= 18; 
//	button3_raw <= 0;
//	#(8*scale*CLK_PERIOD)  // Button press (0 to 6 to 0 to 1)
//	button3_raw <= 1;
//	button1_raw <= 0;
//	#(1*scale*CLK_PERIOD)  // Select master 2
//	button1_raw <= 1;
//	button3_raw <= 0;
//	#(1*scale*CLK_PERIOD)  // Button press (1 to 2)
//	button3_raw <= 1;
//	button1_raw <= 0;
//	#(1*scale*CLK_PERIOD)  // Select slave 2
//	button1_raw <= 1;
//	button3_raw <= 0;
//	#(3*scale*CLK_PERIOD)  // Button press (2 to 5)
//	switch_array <= 0;
//	#(2*scale*CLK_PERIOD)  // Button press (5 to 0)
//	button3_raw <= 1;

	mode_switch <= 1;
	rw_switch1 <= 0;
	button1_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Write master 1
	button1_raw <= 1;
	
	
	#(1500*scale*CLK_PERIOD)  // Wait till finish
	mode_switch <= 1;
	rw_switch1 <= 1;
	button1_raw <= 0;
	#(1*scale*CLK_PERIOD)  // Write master 1
	button1_raw <= 1;
	
//	#(3*scale*CLK_PERIOD)  // Wait 3 cycles
//	rw_switch2 <= 0;
//	button2_raw <= 0;
//	#(1*scale*CLK_PERIOD)  // Write master 2
//	button2_raw <= 1;
	
	#(1500*scale*CLK_PERIOD)  // Wait till finish

	
	#30
 
	$finish;
end
						
endmodule