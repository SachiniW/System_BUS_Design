`timescale 1ns/10ps

module Bus_interconnect_tb;

reg m1_clk;
reg m1_rst;
reg m2_clk;
reg m2_rst;

reg m1_req = 0;
reg m2_req = 0;
reg m1_slave = 0;
reg m2_slave = 0;
reg trans_done = 0;

wire m1_grant;
wire m2_grant;
wire arbiter_busy;

wire s1_clk; 
wire s1_rst;
wire s1_master_valid;
wire s1_master_ready;
wire s1_rx_address;
wire s1_rx_data;
wire s1_write_en;
wire s1_read_en;

wire s2_clk; 
wire s2_rst;
wire s2_master_valid;
wire s2_master_ready;
wire s2_rx_address;
wire s2_rx_data;
wire s2_write_en;
wire s2_read_en;

wire s3_clk; 
wire s3_rst;
wire s3_master_valid;
wire s3_master_ready;
wire s3_rx_address;
wire s3_rx_data;
wire s3_write_en;
wire s3_read_en;

reg s1_slave_split_en = 0;
reg s2_slave_split_en = 0;
reg s3_slave_split_en = 0;


Bus_interconnect UUT(

.sys_clk(m1_clk),
.sys_rst(m1_rst),
.m1_request(m1_req), 
.m2_request(m2_req),
.m1_slave_sel(m1_slave),
.m2_slave_sel(m2_slave),
.trans_done(trans_done),

.m1_grant(m1_grant),
.m2_grant(m2_grant),
.arbiter_busy(arbiter_busy),
.bus_busy(bus_busy),

.m1_clk(m1_clk), 
.m1_rst(m1_rst),
.m1_master_valid(1'b1),
.m1_master_ready(1'b1),
.m1_tx_address(1'b1),
.m1_tx_data(1'b1),
.m1_rx_data(),
.m1_write_en(1'b1),
.m1_read_en(1'b1),
.m1_slave_valid(),
.m1_slave_ready(),

.m2_clk(m2_clk), 
.m2_rst(m2_rst),
.m2_master_valid(1'b1),
.m2_master_ready(1'b1),
.m2_tx_address(1'b0),
.m2_tx_data(1'b1),
.m2_rx_data(),
.m2_write_en(1'b1),
.m2_read_en(1'b0),
.m2_slave_valid(),
.m2_slave_ready(),

.s1_clk(s1_clk), 
.s1_rst(s1_rst),
.s1_master_valid(s1_master_valid),
.s1_master_ready(s1_master_ready),
.s1_rx_address(s1_rx_address),
.s1_rx_data(s1_rx_data),
.s1_tx_data(1'b1),
.s1_write_en(s1_write_en),
.s1_read_en(s1_read_en),
.s1_slave_valid(1'b1),
.s1_slave_ready(1'b1),

.s2_clk(s2_clk), 
.s2_rst(s2_rst),
.s2_master_valid(s2_master_valid),
.s2_master_ready(s2_master_ready),
.s2_rx_address(s2_rx_address),
.s2_rx_data(s2_rx_data),
.s2_tx_data(1'b1),
.s2_write_en(s2_write_en),
.s2_read_en(s2_read_en),
.s2_slave_valid(1'b1),
.s2_slave_ready(1'b1),

.s3_clk(s3_clk), 
.s3_rst(s3_rst),
.s3_master_valid(s3_master_valid),
.s3_master_ready(s3_master_ready),
.s3_rx_address(s3_rx_address),
.s3_rx_data(s3_rx_data),
.s3_tx_data(1'b1),
.s3_write_en(s3_write_en),
.s3_read_en(s3_read_en),
.s3_slave_valid(1'b1),
.s3_slave_ready(1'b1),

.s1_slave_split_en(s1_slave_split_en),
.s2_slave_split_en(s2_slave_split_en),
.s3_slave_split_en(s3_slave_split_en)

);


initial begin
    m1_clk = 0;
    m2_clk = 0;
    m1_rst = 0;
	 m2_rst = 0;
	 #2 m1_rst = 1;
	    m2_rst = 1;
	 #3 m1_rst = 0;
	    m2_rst = 0;

	#10 m1_req = 1;
	m2_req = 1;
	m1_slave = 1;
	m2_slave = 1;
	#10 m1_slave = 0;
	#10 m2_slave = 0;
   #10 m1_req = 0; 
   #10 m2_req = 0; 

   #20 s1_slave_split_en = 1;
   	#10 m2_req = 1;
	m2_slave = 1;
	#10 m2_slave = 1;
	m2_req = 0;
	#50 s1_slave_split_en = 0;	

        #50 trans_done = 1;
	#10 trans_done = 0;

// 	#10 m2_req = 1;
// 	m2_slave = 1;
// 	#10 m2_slave = 1;
//    #10 m2_req = 0;

// 	#10 m1_req = 1;
// 	m1_slave = 1;
// 	#10 m1_slave = 0;
//    #10 m1_req = 0;  

// 	#50 m1_req = 1;
// 	m1_slave = 1;
// 	#10 m1_slave = 0;
//    #10 m1_req = 0;

// 	#50 m2_req = 1;
// 	m1_req = 1;
// 	m2_slave = 1;
// 	#10 m2_slave = 1;
//    #10 m2_req = 0; 
// 	m1_req = 0; 		 



	end

always
	#5 m1_clk = !m1_clk;

always
	#5 m2_clk = !m2_clk;


endmodule 