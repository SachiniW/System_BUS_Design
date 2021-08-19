`timescale 1ns/10ps

module Bus_Arbiter_tb;

reg clk;
reg reset;
reg m1_req = 0;
reg m2_req = 0;
reg m1_slave = 0;
reg m2_slave = 0;

wire m1_grant;
wire m2_grant;
wire [1:0] bus_grant; 
wire [1:0] slave_sel; 

Bus_Arbiter UUT(
.sys_clk(clk), 
.sys_rst(reset),
.m1_request (m1_req), 
.m2_request(m2_req),
.m1_slave_sel(m1_slave),
.m2_slave_sel(m2_slave),
.m1_grant(m1_grant),
.m2_grant(m2_grant),
.bus_grant(bus_grant), 
.slave_sel(slave_sel));

	initial begin
		clk = 0;
		reset = 0;
        #2 reset = 1;
        #3 reset = 0;

	#10 m1_req = 1;
	m1_slave = 1;
	#10 m1_slave = 0;
        #10 m1_req = 0; 

	#10 m2_req = 1;
	m2_slave = 1;
	#10 m2_slave = 1;
        #10 m2_req = 0;

	#10 m1_req = 1;
	m1_slave = 1;
	#10 m1_slave = 0;
        #10 m1_req = 0;  

	#50 m1_req = 1;
	m1_slave = 1;
	#10 m1_slave = 0;
        #10 m1_req = 0;

	#50 m2_req = 1;
	m1_req = 1;
	m2_slave = 1;
	#10 m2_slave = 1;
        #10 m2_req = 0; 
	m1_req = 0; 



	end

always
	#5 clk = !clk;

//always @(posedge clk)
	//begin
//	if (m1_req == 1)
//       m1_slave = 1; 
//	end


endmodule 