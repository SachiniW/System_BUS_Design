`timescale 1ns/10ps

module Bus_mux_tb;

reg m1_clk;
reg m1_rst;
reg m2_clk;
reg m2_rst;

reg [1:0] bus_grant; 
reg [1:0] slave_sel; 

wire s1_clk; 
wire s1_rst;
wire s1_valid;
wire s1_rx_address;
wire s1_rx_data;
wire s1_write_en;
wire s1_read_en;

wire s2_clk; 
wire s2_rst;
wire s2_valid;
wire s2_rx_address;
wire s2_rx_data;
wire s2_write_en;
wire s2_read_en;

wire s3_clk; 
wire s3_rst;
wire s3_valid;
wire s3_rx_address;
wire s3_rx_data;
wire s3_write_en;
wire s3_read_en;

Bus_mux UUT(

.bus_grant(bus_grant), 
.slave_sel(slave_sel),

.m1_clk(m1_clk), 
.m1_rst(m1_rst),
.m1_valid(1'b1),
.m1_tx_address(1'b1),
.m1_tx_data(1'b1),
.m1_rx_data(),
.m1_write_en(1'b1),
.m1_read_en(1'b1),
.m1_slave_ready(),

.m2_clk(m2_clk), 
.m2_rst(m2_rst),
.m2_valid(1'b1),
.m2_tx_address(1'b0),
.m2_tx_data(1'b1),
.m2_rx_data(),
.m2_write_en(1'b1),
.m2_read_en(1'b0),
.m2_slave_ready(),

.s1_clk(s1_clk), 
.s1_rst(s1_rst),
.s1_valid(s1_valid),
.s1_rx_address(s1_rx_address),
.s1_rx_data(s1_rx_data),
.s1_tx_data(1'b1),
.s1_write_en(s1_write_en),
.s1_read_en(s1_read_en),
.s1_slave_ready(1'b1),

.s2_clk(s2_clk), 
.s2_rst(s2_rst),
.s2_valid(s2_valid),
.s2_rx_address(s2_rx_address),
.s2_rx_data(s2_rx_data),
.s2_tx_data(1'b1),
.s2_write_en(s2_write_en),
.s2_read_en(s2_read_en),
.s2_slave_ready(1'b1),

.s3_clk(s3_clk), 
.s3_rst(s3_rst),
.s3_valid(s3_valid),
.s3_rx_address(s3_rx_address),
.s3_rx_data(s3_rx_data),
.s3_tx_data(1'b1),
.s3_write_en(s3_write_en),
.s3_read_en(s3_read_en),
.s3_slave_ready(1'b1)

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
		 

	#5 bus_grant = 2'd1;
       slave_sel = 2'd3;

	#50 bus_grant = 2'd1;
        slave_sel = 2'd1;

    #50 bus_grant = 2'd1;
        slave_sel = 2'd2;

	#50 bus_grant = 2'd2;
        slave_sel = 2'd3;

	#50 bus_grant = 2'd2;
        slave_sel = 2'd2;

    #50 bus_grant = 2'd2;
        slave_sel = 2'd1;


	end

always
	#5 m1_clk = !m1_clk;

always
	#12 m2_clk = !m2_clk;


endmodule 